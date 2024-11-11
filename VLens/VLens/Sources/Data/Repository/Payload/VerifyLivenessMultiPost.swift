//
//  VerifyLivenessMultiPost.swift
//  VLensSdkSample
//
//  Created by Mohamed Taher on 05/11/2024.
//

struct VerifyLivenessMultiPost {
    
    struct Request: Codable {
        let transactionID, face1, face2, face3: String?

        enum CodingKeys: String, CodingKey {
            case transactionID = "transaction_id"
            case face1 = "face_1"
            case face2 = "face_2"
            case face3 = "face_3"
        }
    }
    
    struct Data: Codable {
        let isDigitalIdentityVerified: Bool?
        let isVerificationProcessCompleted: Bool?
//        let deviceInfo, user: JSONNull?
    }
    
}
