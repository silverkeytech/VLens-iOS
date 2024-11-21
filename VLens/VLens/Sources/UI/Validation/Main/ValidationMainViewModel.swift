//
//  ValidationMainViewModel.swift
//  VLensSdkSample
//
//  Created by Mohamed Taher on 08/11/2024.
//

internal import RxSwift

class ValidationMainViewModel {
    
    var withLivenessOnly = false
    
    var isDigitalIdentityVerified = false
    var validationErrorMessage = ""
    
    var face1ViewModel: FaceValidationViewModel? = nil
    var face2ViewModel: FaceValidationViewModel? = nil
    var face3ViewModel: FaceValidationViewModel? = nil
    
    var stepsViewModels: [ValidationItemViewModel] = []
    var currentStepIndex = 0
    
    func initData() {
        // generate three random numbers from 1 to 5
        let randomIndex = Array(0...4)
        let generatedValue = Array(randomIndex.shuffled().prefix(3))
        
        // create face types according to the generated values
        guard let face1Type = FaceValidationTypes(rawValue: generatedValue[0]),
              let face2Type = FaceValidationTypes(rawValue: generatedValue[1]),
              let face3Type = FaceValidationTypes(rawValue: generatedValue[2])
        else { fatalError("Invalid face type") }
        
        
        
        // create steps view models
        if withLivenessOnly {
            // create face view models
            self.face1ViewModel = FaceValidationViewModel(currentType: face1Type, stepName: face1Type.title, stepIndex: 0)
            self.face2ViewModel = FaceValidationViewModel(currentType: face2Type, stepName: face2Type.title, stepIndex: 1)
            self.face3ViewModel = FaceValidationViewModel(currentType: face3Type, stepName: face3Type.title, stepIndex: 2)
            
            stepsViewModels = [
                face1ViewModel!,
                face2ViewModel!,
                face3ViewModel!
            ]
        } else {
            // create face view models
            self.face1ViewModel = FaceValidationViewModel(currentType: face1Type, stepName: face1Type.title, stepIndex: 2)
            self.face2ViewModel = FaceValidationViewModel(currentType: face2Type, stepName: face2Type.title, stepIndex: 3)
            self.face3ViewModel = FaceValidationViewModel(currentType: face3Type, stepName: face3Type.title, stepIndex: 4)
            
            stepsViewModels = [
                FrontNationalIdValidationViewModel(),
                BackNationalIdValidationViewModel(),
                face1ViewModel!,
                face2ViewModel!,
                face3ViewModel!
            ]
        }
    }
    
    
    // Call Face Validation API
    let didPostDataSuccessfully = BehaviorSubject<Bool?>(value: false)
    let error = BehaviorSubject<String?>(value: nil)
    
    let dataRepository = DataRepository()
    
    func postData() {
        let face1 = face1ViewModel?.face ?? ""
        let face2 = face2ViewModel?.face ?? ""
        let face3 = face3ViewModel?.face ?? ""
        
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
