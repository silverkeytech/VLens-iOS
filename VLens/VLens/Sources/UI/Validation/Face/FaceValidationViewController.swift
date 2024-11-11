//
//  FaceValidationViewController.swift
//  VLensSdkSample
//
//  Created by Mohamed Taher on 10/11/2024.
//

import UIKit
import ARKit
import SceneKit

class FaceValidationViewController: UIViewController, ARSCNViewDelegate {

    static func instance() -> FaceValidationViewController {
        let frameworkBundle = Bundle(for: VLensManager.self)
        let storyboard = UIStoryboard(name: "Validation", bundle: frameworkBundle)
        let viewController = storyboard.instantiateViewController(withIdentifier: FaceValidationViewController.stringRepresentation) as! FaceValidationViewController
        return viewController
    }
    
    @IBOutlet weak var cameraPreview: UIView!
    
    private var sceneView: ARSCNView!
    private var isProcessing: Bool = false
    
    var viewModel: FaceValidationViewModel? = nil
    var stepsDelegate: ValidationMainViewControllerDelegate? = nil
    
    private let createdDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize ARSCNView
        sceneView = ARSCNView(frame: self.view.frame)
        sceneView.delegate = self
        sceneView.session = ARSession()
        sceneView.automaticallyUpdatesLighting = true
        self.cameraPreview.addSubview(sceneView)
        
        // Start ARKit face tracking
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    // ARSCNViewDelegate method to handle face tracking updates
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let viewModel else { return }
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        if (createdDate.timeIntervalSinceNow > -10) {
            return
        }
        
        if (isProcessing == true ) {
            return
        }
        
        isProcessing = true
        
        let currentImage = sceneView.snapshot()

        let type = viewModel.currentType
        
        if (type == .smile) {
            let isSmile = self.isSmile(blendShapes: faceAnchor.blendShapes)
            if (isSmile) {
                DispatchQueue.main.async { [self] in
                    viewModel.face = currentImage.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
                    stepsDelegate?.didFinishValidationStepNumber(viewModel.getStepIndex())
                }
                
                return
            }
        }
        
        if (type == .blink) {
            let isBlinking = self.isBlinking(blendShapes: faceAnchor.blendShapes)
            if (isBlinking) {
                DispatchQueue.main.async { [self] in
                    viewModel.face = currentImage.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
                    stepsDelegate?.didFinishValidationStepNumber(viewModel.getStepIndex())
                }
                
                return
            }
        }
        
        if (type == .turnHeadRight) {
            let isTurnRight = self.isTurnRight(faceAnchor: faceAnchor)
            if (isTurnRight) {
                DispatchQueue.main.async { [self] in
                    viewModel.face = currentImage.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
                    stepsDelegate?.didFinishValidationStepNumber(viewModel.getStepIndex())
                }
                
                return
            }
        }
        
        if (type == .turnHeadLeft) {
            let isTurnLeft = self.isTurnLeft(faceAnchor: faceAnchor)
            if (isTurnLeft) {
                DispatchQueue.main.async { [self] in
                    viewModel.face = currentImage.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
                    stepsDelegate?.didFinishValidationStepNumber(viewModel.getStepIndex())
                }
                
                return
            }
        }
        
        if (type == .headStraight) {
            let isHeadStraight = self.isHeadStraight(faceAnchor: faceAnchor)
            if (isHeadStraight) {
                DispatchQueue.main.async { [self] in
                    viewModel.face = currentImage.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
                    stepsDelegate?.didFinishValidationStepNumber(viewModel.getStepIndex())
                }
                
                return
            }
        }

//        let isSmile         = self.isSmile(blendShapes: faceAnchor.blendShapes)
//        let isBlinking      = self.isBlinking(blendShapes: faceAnchor.blendShapes)
//        let isTurnRight     = self.isTurnRight(faceAnchor: faceAnchor)
//        let isTurnLeft      = self.isTurnLeft(faceAnchor: faceAnchor)
//        let isHeadStraight  = self.isHeadStraight(faceAnchor: faceAnchor)
//
//        if ((type == .smile && isSmile)
//            || (type == .blink && isBlinking)
//            || (type == .turnHeadRight && isTurnRight)
//            || (type == .turnHeadLeft && isTurnLeft)
//            || (type == .headStraight && isHeadStraight)) {
//
//            DispatchQueue.main.async { [self] in
//                viewModel.face = currentImage.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
//                stepsDelegate?.didFinishValidationStepNumber(viewModel.getStepIndex())
//            }
//        }
        
        isProcessing = false
    }
    
    private func isSmile(blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber]) -> Bool {
        if let mouthSmileLeft = blendShapes[.mouthSmileLeft]?.floatValue,
           let mouthSmileRight = blendShapes[.mouthSmileRight]?.floatValue {
            if (mouthSmileLeft + mouthSmileRight)/2.0 > 0.5 {
                debugPrint("Smile detected!")
                return true
            }
        }
        
        return false
    }
    
    private func isBlinking(blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber]) -> Bool {
        if let eyeBlinkLeft = blendShapes[.eyeBlinkLeft]?.floatValue,
           let eyeBlinkRight = blendShapes[.eyeBlinkRight]?.floatValue {
            if eyeBlinkLeft > 0.5 && eyeBlinkRight > 0.5 {
                debugPrint("Blink detected!")
                return true
            }
        }
        return false
    }
    
    private func isTurnRight(faceAnchor: ARFaceAnchor) -> Bool {
        let headRotationY = faceAnchor.transform.columns.2.x
        if headRotationY > 0.3 {
            return true
        }
        return false
    }
    
    private func isTurnLeft(faceAnchor: ARFaceAnchor) -> Bool {
        let headRotationY = faceAnchor.transform.columns.2.x
        if headRotationY < -0.3 {
            return true
        }
        return false
    }
    
    private func isHeadStraight(faceAnchor: ARFaceAnchor) -> Bool {
        let headRotationY = faceAnchor.transform.columns.2.x
        if headRotationY > -0.2 && headRotationY < 0.2 {
            return true
        }
        return false
    }
}
