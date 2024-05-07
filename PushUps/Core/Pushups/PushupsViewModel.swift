//
//  PushupsViewModel.swift
//  PushUps
//
//  Created by Ballet Tom on 21/04/2024.
//

import AVFoundation
import UIKit
import VideoToolbox
import CoreImage
import CoreMotion
import SwiftUI
import Accelerate

class PushUpsViewModel: NSObject, ObservableObject, AVCaptureDepthDataOutputDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let session = AVCaptureSession()
    private let depthDataOutput = AVCaptureDepthDataOutput()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    
    @Published var depthImage: UIImage?
    @Published var distanceLabel: String = "Unknown"
    @Published var autoCounter: Bool = false
    @Published var blackPixelCount: Double = 0.0
    
    @Published var pushupCount: Int = 0
    
    @Published var proximity: Double = 0.0
    
    private var motionManager = CMMotionManager()
    @Published var isFacingUpward = false
    
    // Maintaining a history of the last few states
    var stateHistory: [String] = []
    
    override init() {
        super.init()
        configureCaptureSession()
        startMotionUpdates()
    }
    
    func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (data, error) in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self?.isFacingUpward = data.gravity.z < -0.95
            }
        }
    }
    
    func configureCaptureSession() {
        sessionQueue.async {
            guard let device = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .front),
                  let input = try? AVCaptureDeviceInput(device: device) else {
                print("Failed to get the camera device or create device input")
                return
            }
            
            self.session.beginConfiguration()

            // Set a lower resolution preset for the session to reduce the number of pixels processed
            if self.session.canSetSessionPreset(.vga640x480) {  // VGA quality
                self.session.sessionPreset = .vga640x480
            } else {
                print("Failed to set session preset to Low , using default")
            }

            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            if self.session.canAddOutput(self.depthDataOutput) {
                self.session.addOutput(self.depthDataOutput)
                self.depthDataOutput.setDelegate(self, callbackQueue: self.sessionQueue)
            }
            if self.session.canAddOutput(self.videoDataOutput) {
                self.session.addOutput(self.videoDataOutput)
                self.videoDataOutput.setSampleBufferDelegate(self, queue: self.sessionQueue)
            }
            self.session.commitConfiguration()
            self.session.startRunning()
        }
    }

    func depthDataOutput(_ output: AVCaptureDepthDataOutput, didOutput depthData: AVDepthData, timestamp: CMTime, connection: AVCaptureConnection) {
        let depthMap = depthData.depthDataMap
        UIImage.fromDepthBuffer(depthMap) { [weak self] image, label, blackCount in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.depthImage = image
                self.distanceLabel = label
                self.blackPixelCount = blackCount
                self.updatePushupCount(for: label)
            }
        }
    }
    
    private func updatePushupCount(for newState: String) {
        // Append new state only if it's different from the last state in history
        if let lastState = stateHistory.last {
            if newState != lastState {
                stateHistory.append(newState)
            }
        } else {
            // If the history is empty, add the first state
            stateHistory.append(newState)
        }

        // Keep only the last three states for comparison
        if stateHistory.count > 3 {
            stateHistory.removeFirst()
        }
        
        // Check if the current state history matches the required sequence
        if stateHistory == ["Mid", "Close", "Mid"] {
            withAnimation {
                pushupCount += 1
            }
            // Reset the state history after a successful pushup count
            stateHistory.removeAll()
        }
    }
}

extension UIImage {
    // Assuming depth data is normalized to values between 0 (black, closer) and 255 (white, further)
    static func fromDepthBuffer(_ depthBuffer: CVPixelBuffer, completion: @escaping (UIImage?, String, Double) -> Void) {
        let ciContext = CIContext()
        let depthCIImage = CIImage(cvPixelBuffer: depthBuffer)
                
        guard let cgImage = ciContext.createCGImage(depthCIImage, from: depthCIImage.extent) else {
            completion(nil, "Failed to create image", 0.0)
            return
        }
        
        let image = UIImage(cgImage: cgImage)
        let size = image.size
        let scale = image.scale
        let rect = CGRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale)
        
        // Save the count of black pixels

        // Render the UIImage to a grayscale context to analyze pixel data
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        image.draw(in: rect)
        let grayscaleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let blackPixelCount = analyzePixelsForCloseProximity(grayscaleImage)
//        print(blackPixelCount)
        
        // Analyze pixels
        let threshold = analyzePixelsForCloseProximity(grayscaleImage)
        var label = ""
        if threshold > 0.5 {
            label = "Close"
        } else {
            label = "Mid"
        }
        completion(image, label, blackPixelCount)
        
    }
    
//    private static func analyzePixelsForCloseProximity(_ image: UIImage?) -> Double {
//        guard let cgImage = image?.cgImage else { return 0.0 }
//        let width = cgImage.width
//        let height = cgImage.height
//        let colorSpace = CGColorSpaceCreateDeviceGray()
//        
//        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width, space: colorSpace, bitmapInfo: 0) else { return 0.0 }
//        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
//        
//        guard let pixelData = context.data else { return 0.0 }
//        
//        var blackPixelCount = 0
//        var totalPixels = 0
//        
//        for x in 0 ..< width {
//            for y in 0 ..< height {
//                let offset = y * width + x
//                let pixel = pixelData.load(fromByteOffset: offset, as: UInt8.self)
//                if pixel < 128 {  // Assuming black pixels are those less than mid-gray
//                    blackPixelCount += 1
//                }
//                totalPixels += 1
//            }
//        }
//        return Double(blackPixelCount) / Double(totalPixels)
//    }
    
    private static func analyzePixelsForCloseProximity(_ image: UIImage?) -> Double {
        guard let cgImage = image?.cgImage else {
            print("Failed to get CGImage from UIImage")
            return 0.0
        }
        let width = cgImage.width
        let height = cgImage.height

        // Create a grayscale color space
        let colorSpace = CGColorSpaceCreateDeviceGray()

        // Define grayscale format for the image
        var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 8, colorSpace: Unmanaged.passRetained(colorSpace),
                                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue),
                                          version: 0, decode: nil, renderingIntent: .defaultIntent)
        var sourceBuffer = vImage_Buffer()
        defer {
            free(sourceBuffer.data)
            Unmanaged.passUnretained(colorSpace).release()  // Properly manage memory for the color space
        }

        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, vImage_Flags(kvImageNoFlags))
        if error != kvImageNoError {
            print("Error initializing vImage buffer: \(error)")
            return 0.0
        }

        // Create a histogram
        let alphaBins = 256
        var histogram = [UInt](repeating: 0, count: alphaBins)
        error = vImageHistogramCalculation_Planar8(&sourceBuffer, &histogram, vImage_Flags(kvImageNoFlags))
        if error != kvImageNoError {
            print("Error calculating histogram: \(error)")
            return 0.0
        }

        // Sum up the histogram bins for black pixels (threshold < 128)
        let blackPixelCount = histogram[0..<128].reduce(0, +)
        let totalPixels = width * height

//        print("Black Pixel Count: \(blackPixelCount) out of \(totalPixels)")

        return Double(blackPixelCount) / Double(totalPixels)
    }


}
