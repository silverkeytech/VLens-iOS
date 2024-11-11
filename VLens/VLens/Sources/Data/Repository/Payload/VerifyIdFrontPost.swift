//
//  DigitalIdentityVerifyIdFront.swift
//  VLensSdkSample
//
//  Created by Mohamed Taher on 05/11/2024.
//

struct VerifyIdFrontPost {
    
    struct Request: Codable {
        let transactionID, image: String?

        enum CodingKeys: String, CodingKey {
            case transactionID = "transaction_id"
            case image
        }
    }
    
    struct Data: Codable {
        
    }
    
}
