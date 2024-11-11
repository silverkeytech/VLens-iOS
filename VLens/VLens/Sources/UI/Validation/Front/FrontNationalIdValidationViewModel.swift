//
//  FrontNationalIdValidationViewModel.swift
//  VLensSdkSample
//
//  Created by Mohamed Taher on 08/11/2024.
//

internal import RxSwift

class FrontNationalIdValidationViewModel  {
    
    let stepName = "Front National ID Validation"
    
    let didPostDataSuccessfully = BehaviorSubject<Bool?>(value: false)
    let error = BehaviorSubject<String?>(value: nil)
    
    let dataRepository = DataRepository()
    
    func postData(_ image: String) {
        let request = VerifyIdFrontPost.Request(transactionID: CachedData.shared.transactionId, image: image)
        dataRepository.postVerifyIdFront(
            request: request,
            handleApiResponse: { data in
                self.didPostDataSuccessfully.onNext(true)
            },
            onFaild: { error in
                self.didPostDataSuccessfully.onNext(false)
                self.error.onNext(error?.data ?? "network_error".localized)
            }
        )
    }
    
}

extension FrontNationalIdValidationViewModel: ValidationItemViewModel {
    func getStepIndex() -> Int {
        return 0
    }
    
    func getStepName() -> String {
        return stepName
    }
}
