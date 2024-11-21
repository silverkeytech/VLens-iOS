//
//  VLensManager.swift
//  VLens
//
//  Created by Mohamed Taher on 10/11/2024.
//

import UIKit

// MARK: - VLens Entry Point Class
public class VLensManager {
    
    public init(transactionId: String, apiKey: String, secretKey: String, tenancyName: String, language: String = "en") {
        CachedData.shared.transactionId = transactionId
        CachedData.shared.apiKey        = apiKey
        CachedData.shared.secretKey     = secretKey
        CachedData.shared.tenancyName   = tenancyName
        CachedData.shared.language      = language
        
        if (Constants.IS_DEBUG) {
            NetworkActivityLogger.shared.level = .debug
            NetworkActivityLogger.shared.startLogging()
        }
    }
    
    public weak var delegate: VLensDelegate? = nil
    
    public func setAccessToken(_ accessToken: String) {
        CachedData.shared.accessToken = accessToken
    }
    
    public func present(on viewController: UIViewController, withLivenessOnly: Bool = false) {
        debugPrint("Vlens presented :D")
        
        
        let validationViewController = ValidationMainViewController.instance(withLivenessOnly: withLivenessOnly)
        validationViewController.delegate = delegate
        validationViewController.modalPresentationStyle = .fullScreen
        viewController.present(validationViewController, animated: true)
    }
}
