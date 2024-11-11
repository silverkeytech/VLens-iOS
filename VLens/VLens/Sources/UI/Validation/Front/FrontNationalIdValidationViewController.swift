//
//  FrontNationalIdValidationViewController.swift
//  VLensSdkSample
//
//  Created by Mohamed Taher on 08/11/2024.
//

import UIKit
internal import RxSwift

class FrontNationalIdValidationViewController: CardDetectionViewController {
    
    static func instance() -> FrontNationalIdValidationViewController {
        let frameworkBundle = Bundle(for: VLensManager.self)
        let storyboard = UIStoryboard(name: "Validation", bundle: frameworkBundle)
        let viewController = storyboard.instantiateViewController(withIdentifier: FrontNationalIdValidationViewController.stringRepresentation) as! FrontNationalIdValidationViewController
        return viewController
    }
    
    var viewModel: FrontNationalIdValidationViewModel? = nil
    var stepsDelegate: ValidationMainViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didCropImageToImage(_ image: CGImage) {
        super.didCropImageToImage(image)
        
        guard let base64Image = convertCGImageToBase64(image) else {
            return
        }

        DispatchQueue.main.async { [self] in
            viewModel?.postData(base64Image)
            stepsDelegate?.didFinishValidationStepNumber(viewModel?.getStepIndex() ?? 0)
        }
        
    }
}
