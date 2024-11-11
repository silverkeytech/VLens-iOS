//
//  ApiConfig.swift
//  VLens
//
//  Created by Mohamed Taher on 27/07/2023.
//

import Foundation

struct ApiConfig {
    
    private static let BASE_URL = Constants.HOST
    
    // MARK: - HEADER
    static var webApiHeaders = [
        "Content-Type"                  : "application/json",
        "Accept"                        : "*/*",
        "Accept_Language"               : "en",
        "ApiKey"                        : CachedData.shared.apiKey,
        "TenancyName"                   : CachedData.shared.tenancyName,
    ]
    
    // MARK: - API
    static let VERIFY_ID_FRONT_POST            = "\(BASE_URL)/api/DigitalIdentity/verify/id/front"
    static let VERIFY_ID_BACK_POST             = "\(BASE_URL)/api/DigitalIdentity/verify/id/back"
    static let VERIFY_LIVENESS_MULTI_POST      = "\(BASE_URL)/api/DigitalIdentity/verify/liveness/multi"
}
    
