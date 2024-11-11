//
//  BackNationalIdValidationViewController.swift
//  VLensSdkSample
//
//  Created by Mohamed Taher on 08/11/2024.
//

import UIKit
internal import RxSwift

class BackNationalIdValidationViewController: CardDetectionViewController {
    
    static func instance() -> BackNationalIdValidationViewController {
        let frameworkBundle = Bundle(for: VLensManager.self)
        let storyboard = UIStoryboard(name: "Validation", bundle: frameworkBundle)
        let viewController = storyboard.instantiateViewController(withIdentifier: BackNationalIdValidationViewController.stringRepresentation) as! BackNationalIdValidationViewController
        return viewController
    }
    
    var viewModel: BackNationalIdValidationViewModel? = nil
    var stepsDelegate: ValidationMainViewControllerDelegate? = nil
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        //wait 10 sec to start processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            super.viewDidLoad()
            self.bind()
        }
        
    }
    
    private func bind() {
        guard let viewModel else { return }
        
        (viewModel.error ->> { value in if (value != nil) { self.popupErrorMessage(message: value) }}).disposed(by: disposeBag)
        
        (viewModel.didPostDataSuccessfully ->> { value in
            self.removeSpinner()
            if (value ?? false) {
                self.stepsDelegate?.didFinishValidationStepNumber(viewModel.getStepIndex())
            }
            
            if (value == false) {
                self.resetSession()
            }
        }).disposed(by: disposeBag)
    }
    
    override func didCropImageToImage(_ image: CGImage) {
        super.didCropImageToImage(image)
        
        guard let base64Image = convertCGImageToBase64(image) else {
            return
        }

        DispatchQueue.main.async { [self] in
            showSpinner()
            viewModel?.postData(base64Image)
        }
    }
}
