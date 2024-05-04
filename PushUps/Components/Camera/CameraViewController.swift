//
//  CameraViewController.swift
//  PushUps
//
//  Created by Hugo Peyron on 26/04/2024.
//

import UIKit
import AVFoundation

protocol CameraViewCoordinator: AnyObject {
    func didTakePicture(_ image: UIImage)
    func didFailWithError(_ error: Error)
}

// extension d'un protocol
extension CameraViewCoordinator {
    func printSomething() {
        print("extension du protocol Camera")
    }
}

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    weak var delegate: CameraViewCoordinator?
    var cameraPosition: AVCaptureDevice.Position = .back
    var previewSize: CGSize = .zero {
        didSet {
            updatePreviewLayerSize(previewSize)
        }
    }

    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var capturePhotoOutput: AVCapturePhotoOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }

    func updatePreviewLayerSize(_ size: CGSize) {
        DispatchQueue.main.async { [weak self] in
            self?.previewLayer?.frame = CGRect(origin: .zero, size: size)
        }
    }

    private func setupCaptureSession() {
        configureCamera(withPosition: cameraPosition)
    }

    private func configureCamera(withPosition position: AVCaptureDevice.Position) {
        captureSession.beginConfiguration()

        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoDeviceInput) else {
            delegate?.didFailWithError(CameraError.unableToAddInput)
            return
        }
        captureSession.addInput(videoDeviceInput)

        let photoOutput = AVCapturePhotoOutput()
        guard captureSession.canAddOutput(photoOutput) else {
            delegate?.didFailWithError(CameraError.unableToAddOutput)
            return
        }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        capturePhotoOutput = photoOutput

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        if let previewLayer = self.previewLayer {
            view.layer.addSublayer(previewLayer)
            updatePreviewLayerSize(self.previewSize)
        }

        captureSession.commitConfiguration()

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            delegate?.didFailWithError(error)
            return
        }

        guard let imageData = photo.fileDataRepresentation(),
              var image = UIImage(data: imageData) else {
            delegate?.didFailWithError(CameraError.invalidImageData)
            return
        }

        if cameraPosition == .front {
            image = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .leftMirrored)
        }

        delegate?.didTakePicture(image)
    }

    public func takePicture() {
        let settings = AVCapturePhotoSettings()
        capturePhotoOutput?.capturePhoto(with: settings, delegate: self)
    }

    enum CameraError: Error {
        case unableToAddInput, unableToAddOutput, invalidImageData
    }
}
