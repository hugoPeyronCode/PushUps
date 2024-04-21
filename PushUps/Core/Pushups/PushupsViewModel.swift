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

extension UIImage {
    // Assuming depth data is normalized to values between 0 (black, closer) and 255 (white, further)
    static func fromDepthBuffer(_ depthBuffer: CVPixelBuffer, completion: @escaping (UIImage?, String) -> Void) {
        let ciContext = CIContext()
        let depthCIImage = CIImage(cvPixelBuffer: depthBuffer)
        
        guard let cgImage = ciContext.createCGImage(depthCIImage, from: depthCIImage.extent) else {
            completion(nil, "Failed to create image")
            return
        }
        
        let image = UIImage(cgImage: cgImage)
        let size = image.size
        let scale = image.scale
        let rect = CGRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale)
        
        // Render the UIImage to a grayscale context to analyze pixel data
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        image.draw(in: rect)
        let grayscaleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Analyze pixels
        let threshold = analyzePixelsForCloseProximity(grayscaleImage)
        var label = ""
        if threshold > 0.5 {
            label = "Close"
        } else if threshold > 0.08 {
            label = "Mid"
        } else {
            label = "Far"
        }
        completion(image, label)
        
    }
    
    private static func analyzePixelsForCloseProximity(_ image: UIImage?) -> Double {
        guard let cgImage = image?.cgImage else { return 0.0 }
        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width, space: colorSpace, bitmapInfo: 0) else { return 0.0 }
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let pixelData = context.data else { return 0.0 }
        
        var blackPixelCount = 0
        var totalPixels = 0
        
        for x in 0 ..< width {
            for y in 0 ..< height {
                let offset = y * width + x
                let pixel = pixelData.load(fromByteOffset: offset, as: UInt8.self)
                if pixel < 128 {  // Assuming black pixels are those less than mid-gray
                    blackPixelCount += 1
                }
                totalPixels += 1
            }
        }
        return Double(blackPixelCount) / Double(totalPixels)
    }
}

class CameraManager: NSObject, ObservableObject, AVCaptureDepthDataOutputDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let session = AVCaptureSession()
    private let depthDataOutput = AVCaptureDepthDataOutput()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    
    @Published var depthImage: UIImage?
    @Published var distanceLabel: String = "Unknown"
    @Published var autoCounter: Bool = false
    
    
    private var lastDistanceState: String = "Far"
    @Published var pushupCount: Int = 0
    
    
    private var motionManager = CMMotionManager()
    @Published var isFacingUpward = false
    
    
    override init() {
        super.init()
        self.configureCaptureSession()
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
                // Check if the device is facing upward
                let z = data.gravity.z
                self?.isFacingUpward = z < -0.95
                print(self?.isFacingUpward)
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
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.depthDataOutput) {
                self.session.addOutput(self.depthDataOutput)
                self.depthDataOutput.isFilteringEnabled = false
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
    
    private var temporaryState1: String = "None"
    private var temporaryState2: String = "None"
    private var temporaryState3: String = "None"
    private var temporaryState4: String = "None"
    private var temporaryState5: String = "None"
    
    func depthDataOutput(_ output: AVCaptureDepthDataOutput, didOutput depthData: AVDepthData, timestamp: CMTime, connection: AVCaptureConnection) {
        let depthMap = depthData.depthDataMap
        UIImage.fromDepthBuffer(depthMap) { [weak self] image, label in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.depthImage = image
                self.distanceLabel = label
                
                if label == "Far" {
                    self.temporaryState1 = "true"
                }
                
                if self.temporaryState1 == "true" {
                    if label == "Mid" {
                        self.temporaryState2 = "true"
                    }
                }
                
                if self.temporaryState2 == "true" {
                    if label == "Close" {
                        self.temporaryState3 = "true"
                    }
                }
                
                if self.temporaryState3 == "true" {
                    if label == "Mid" {
                        self.temporaryState4 = "true"
                    }
                }
                
                if self.temporaryState4 == "true" {
                    if label == "Far" {
                        self.pushupCount = self.pushupCount + 1
                        
                        self.temporaryState1 = "false"
                        self.temporaryState2 = "false"
                        self.temporaryState3 = "false"
                        self.temporaryState4 = "false"
                        self.temporaryState5 = "false"
                    }
                }
            }
        }
    }
    
    private func calculateAverageDepth(from depthMap: CVPixelBuffer) -> Float {
        CVPixelBufferLockBaseAddress(depthMap, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(depthMap, .readOnly) }
        
        let width = CVPixelBufferGetWidth(depthMap)
        let height = CVPixelBufferGetHeight(depthMap)
        guard let data = CVPixelBufferGetBaseAddress(depthMap)?.assumingMemoryBound(to: Float32.self) else {
            return 0.0
        }
        
        var totalDepth: Float = 0
        var count: Float = 0
        
        for y in 0..<height {
            for x in 0..<width {
                let idx = y * width + x
                let depth = data[idx]
                if depth > 0 && depth.isFinite {
                    totalDepth += depth
                    count += 1
                }
            }
        }
        
        return (count > 0) ? totalDepth / count : 0.0
    }
    
    
}
