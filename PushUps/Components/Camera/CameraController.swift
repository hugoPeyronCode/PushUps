//
//  CameraController.swift
//  PushUps
//
//  Created by Hugo Peyron on 26/04/2024.
//

import UIKit

class CameraController: ObservableObject, CameraViewCoordinator {
    @Published var cameraViewController: CameraViewController?
    @Published var image: UIImage?
    @Published var error: Error?
    
    init() {
        let controller = CameraViewController()
        self.cameraViewController = controller
        controller.delegate = self
    }
    
    func takePicture() {
        cameraViewController?.takePicture()
    }
    
    func didTakePicture(_ image: UIImage) {
        DispatchQueue.main.async {
            self.image = image
        }
    }
    
    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async {
            self.error = error
            // Optionally, add more error handling logic here
        }
    }
}
