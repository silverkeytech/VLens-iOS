//
//  VLensManager.swift
//  VLens
//
//  Created by Mohamed Taher on 10/11/2024.
//

import UIKit

// MARK: - VLens Entry Point Class
public class VLensManager {
    
    public init(apiKey: String, secretKey: String, tenancyName: String, language: String = "en") {
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
    
    public func present(on viewController: UIViewController) {
        debugPrint("Vlens presented :D")
        
        CachedData.shared.transactionId = UUID().uuidString
        
        let validationViewController = ValidationMainViewController.instance()
        validationViewController.delegate = delegate
        validationViewController.modalPresentationStyle = .fullScreen
        viewController.present(validationViewController, animated: true)
    }
}
