//
//  FaceValidationTypes.swift
//  VLensSdkSample
//
//  Created by Mohamed Taher on 10/11/2024.
//

enum FaceValidationTypes: Int {
    case smile          = 0
    case blink          = 1
    case turnHeadRight  = 2
    case turnHeadLeft   = 3
    case headStraight   = 4
    
    var title: String {
        switch self {
        case .smile:
            return "Smile"
        case .blink:
            return "Blink"
        case .turnHeadRight:
            return "Turn Head Right"
        case .turnHeadLeft:
            return "Turn Head Left"
        case .headStraight:
            return "Head Straight"
        }
    }
}
