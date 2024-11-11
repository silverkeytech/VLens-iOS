//
//  ValidationMainViewModel.swift
//  VLensSdkSample
//
//  Created by Mohamed Taher on 08/11/2024.
//

internal import RxSwift

class ValidationMainViewModel {
    
    var isDigitalIdentityVerified = false
    var validationErrorMessage = ""
    
    let stepsViewModels: [ValidationItemViewModel]
    var currentStepIndex = 0
    
    init() {
        // generate three random numbers from 1 to 5
        let randomIndex = Array(0...4)
        let generatedValue = Array(randomIndex.shuffled().prefix(3))
        
        // create face types according to the generated values
        guard let face1Type = FaceValidationTypes(rawValue: generatedValue[0]),
              let face2Type = FaceValidationTypes(rawValue: generatedValue[1]),
              let face3Type = FaceValidationTypes(rawValue: generatedValue[2])
        else { fatalError("Invalid face type") }
        
        // create face view models
        let face1ViewModel = FaceValidationViewModel(currentType: face1Type, stepName: face1Type.title, stepIndex: 2)
        let face2ViewModel = FaceValidationViewModel(currentType: face2Type, stepName: face2Type.title, stepIndex: 3)
        let face3ViewModel = FaceValidationViewModel(currentType: face3Type, stepName: face3Type.title, stepIndex: 4)
        
        // create steps view models
        stepsViewModels = [
            FrontNationalIdValidationViewModel(),
            BackNationalIdValidationViewModel(),
            face1ViewModel,
            face2ViewModel,
            face3ViewModel
        ]
    }
    
    
    // Call Face Validation API
    let didPostDataSuccessfully = BehaviorSubject<Bool?>(value: false)
    let error = BehaviorSubject<String?>(value: nil)
    
    let dataRepository = DataRepository()
    
    func postData() {
        let face1 = (stepsViewModels[2] as? FaceValidationViewModel)?.face ?? ""
        let face2 = (stepsViewModels[3] as? FaceValidationViewModel)?.face ?? ""
        let face3 = (stepsViewModels[4] as? FaceValidationViewModel)?.face ?? ""
        
        let request = VerifyLivenessMultiPost.Request(transactionID: CachedData.shared.transactionId, face1: face1, face2: face2, face3: face3)
        dataRepository.postVerifyLivenessMulti(
            request: request,
            handleApiResponse: { data in
                self.isDigitalIdentityVerified = data?.data?.isDigitalIdentityVerified ?? false
                self.didPostDataSuccessfully.onNext(true)
            },
            onFaild: { error in
                self.didPostDataSuccessfully.onNext(false)
                self.error.onNext(error?.data ?? "network_error".localized)
            }
        )
    }

}
