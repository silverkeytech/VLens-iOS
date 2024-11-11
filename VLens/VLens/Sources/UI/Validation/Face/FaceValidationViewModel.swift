//
//  FaceValidationViewModel.swift
//  VLensSdkSample
//
//  Created by Mohamed Taher on 10/11/2024.
//

internal import RxSwift

class FaceValidationViewModel {
    
    let currentType: FaceValidationTypes
    let stepName: String
    let stepIndex: Int
    
    var face = ""
    
    init(currentType: FaceValidationTypes, stepName: String, stepIndex: Int) {
        self.currentType = currentType
        self.stepName = stepName
        self.stepIndex = stepIndex
    }
    
}


extension FaceValidationViewModel: ValidationItemViewModel {
    func getStepIndex() -> Int {
        return stepIndex
    }
    
    func getStepName() -> String {
        return stepName
    }
}
