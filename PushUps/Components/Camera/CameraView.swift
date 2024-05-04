//
//  CameraView.swift
//  PushUps
//
//  Created by Hugo Peyron on 25/04/2024.
//
import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    @ObservedObject var cameraController: CameraController
    @Binding var cameraPosition: AVCaptureDevice.Position
    var previewSize: CGSize
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = cameraController.cameraViewController ?? CameraViewController()
        controller.cameraPosition = self.cameraPosition
        controller.previewSize = self.previewSize
        controller.delegate = cameraController
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        uiViewController.updatePreviewLayerSize(self.previewSize)
    }
}

#Preview {
    CameraView(cameraController: CameraController(), cameraPosition: .constant(.front), previewSize: CGSize(width: 20, height: 200))
}
