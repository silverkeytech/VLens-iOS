//
//  ValidationMainViewController.swift
//  VLensSdkSample
//
//  Created by Mohamed Taher on 08/11/2024.
//

import UIKit
internal import RxSwift
internal import RxCocoa

protocol ValidationMainViewControllerDelegate {
    func didFinishValidationStepNumber(_ stepNumber: Int)
}

class ValidationMainViewController: BaseViewController {

    static func instance() -> ValidationMainViewController {
        let frameworkBundle = Bundle(for: VLensManager.self)
        let storyboard = UIStoryboard(name: "Validation", bundle: frameworkBundle)
        let viewController = storyboard.instantiateViewController(withIdentifier: ValidationMainViewController.stringRepresentation) as! ValidationMainViewController
        return viewController
    }
    
    var delegate: VLensDelegate? = nil
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var stepNameLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    private let frontNationalIdValidationViewController      : FrontNationalIdValidationViewController  = .instance()
    private let backNationalIdValidationViewController       : BackNationalIdValidationViewController   = .instance()
    private let face1ValidationViewController                : FaceValidationViewController             = .instance()
    private let face2ValidationViewController                : FaceValidationViewController             = .instance()
    private let face3ValidationViewController                : FaceValidationViewController             = .instance()
    
    private var currentChildViewController: UIViewController? = nil
    
    private let viewModel = ValidationMainViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        bind()
    }
    
    private func initViews() {
        frontNationalIdValidationViewController.viewModel = viewModel.stepsViewModels[0] as? FrontNationalIdValidationViewModel
        frontNationalIdValidationViewController.stepsDelegate = self
        
        backNationalIdValidationViewController.viewModel = viewModel.stepsViewModels[1] as? BackNationalIdValidationViewModel
        backNationalIdValidationViewController.stepsDelegate = self
        
        face1ValidationViewController.viewModel = viewModel.stepsViewModels[2] as? FaceValidationViewModel
        face1ValidationViewController.stepsDelegate = self
        
        face2ValidationViewController.viewModel = viewModel.stepsViewModels[3] as? FaceValidationViewModel
        face2ValidationViewController.stepsDelegate = self
        
        face3ValidationViewController.viewModel = viewModel.stepsViewModels[4] as? FaceValidationViewModel
        face3ValidationViewController.stepsDelegate = self
                
        initViewsForStep()
    }
    
    private func bind() {
        (viewModel.error ->> { value in if (value != nil) { self.popupErrorMessage(message: value) }}).disposed(by: disposeBag)
        
        (viewModel.didPostDataSuccessfully ->> { value in
            self.removeSpinner()
            if (value ?? false) {
                self.handleValidationResult()
            }
        }).disposed(by: disposeBag)
    }
    
    private func handleValidationResult() {
        
        if (viewModel.isDigitalIdentityVerified) {
            delegate?.didValidateSuccessfully(transactionId: CachedData.shared.transactionId)
        } else {
            delegate?.didFailToValidate(transactionId: CachedData.shared.transactionId, error: viewModel.validationErrorMessage)
        }
        
        let resultMessage = viewModel.isDigitalIdentityVerified ? "validation_success".localized : "validation_failed".localized
        Utils.fixedAlertWithOkAction(sender: self, title: resultMessage, message: nil) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func initViewsForStep(_ index: Int = 0) {
        let stepItemViewModel = viewModel.stepsViewModels[index]
        
        let progress = Float(index + 1) / Float(viewModel.stepsViewModels.count)
        progressView.setProgress(progress, animated: true)
        stepNameLabel.text = viewModel.stepsViewModels[index].getStepName()
        
        switch stepItemViewModel {
        case is FrontNationalIdValidationViewModel:
            switchToViewController(frontNationalIdValidationViewController)
        case is BackNationalIdValidationViewModel:
            switchToViewController(backNationalIdValidationViewController)
        case is FaceValidationViewModel:
            if (viewModel.currentStepIndex == 2) {
                switchToViewController(face1ValidationViewController)

            } else if (viewModel.currentStepIndex == 3) {
                switchToViewController(face2ValidationViewController)

            } else if (viewModel.currentStepIndex == 4) {
                switchToViewController(face3ValidationViewController)
            }
            
        default:
            break
        }
        
    }
    
    private func switchToViewController(_ viewController: UIViewController) {
        // Remove the current child view controller, if any
        if let currentVC = currentChildViewController {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }
        
        currentChildViewController = viewController
        
        addChild(viewController)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }

    @IBAction func nextButtonAction(_ sender: Any) {
        
        guard viewModel.currentStepIndex + 1 < viewModel.stepsViewModels.count else {
            return
        }
        
        viewModel.currentStepIndex += 1
        initViewsForStep(viewModel.currentStepIndex)
    }
    
}

extension ValidationMainViewController: ValidationMainViewControllerDelegate {
    func didFinishValidationStepNumber(_ stepNumber: Int) {
        let numOfSteps = viewModel.stepsViewModels.count
        if (stepNumber + 1 == numOfSteps) {
            showSpinner()
            viewModel.postData()
            return
        }
        
        viewModel.currentStepIndex += 1
        initViewsForStep(stepNumber + 1)
    }
}
