//
//  ViewController.swift
//  VLensDemo
//
//  Created by Mohamed Taher on 10/11/2024.
//

import UIKit
import VLens

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var transactionIdTextField: UITextField!
    @IBOutlet weak var accessTextField: UITextField!
    
    @IBOutlet weak var progressView: UIActivityIndicatorView!
        
    private var vlens: VLensManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionIdTextField.delegate = self
        accessTextField.delegate = self
    }
    
    // UITextFieldDelegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func setDefaultDataButtonAction(_ sender: Any) {
        
        progressView.startAnimating()
        
        transactionIdTextField.text = UUID().uuidString
        
        loginApi { accessToken in
            DispatchQueue.main.async {
                self.progressView.stopAnimating()
                self.accessTextField.text = accessToken
           }
        }
    }

    @IBAction func getStartedButtonAction(_ sender: Any) {
        
        if accessTextField.text?.isEmpty ?? true {
            debugPrint("Please provide an access token")
            return
        }
        
        if transactionIdTextField.text?.isEmpty ?? true {
            debugPrint("Please provide a transaction id")
            return
        }
        
        vlens = VLensManager(
            transactionId   : transactionIdTextField.text ?? "",
            apiKey          : "W70qYFzumZYn9nPqZXdZ39eRjpW5qRPrZ4jlxlG6c",
            secretKey       : "",
            tenancyName     : "silverkey2",
            language        : "en"
        )
        
        vlens?.delegate = self
        vlens?.setAccessToken(accessTextField.text ?? "")
        
        vlens?.present(on: self)
    }
    
    @IBAction func getStartedWithLivenessOnlyButtonAction(_ sender: Any) {
        if accessTextField.text?.isEmpty ?? true {
            debugPrint("Please provide an access token")
            return
        }
        
        if transactionIdTextField.text?.isEmpty ?? true {
            debugPrint("Please provide a transaction id")
            return
        }
        
        vlens = VLensManager(
            transactionId   : transactionIdTextField.text ?? "",
            apiKey          : "W70qYFzumZYn9nPqZXdZ39eRjpW5qRPrZ4jlxlG6c",
            secretKey       : "",
            tenancyName     : "silverkey2",
            language        : "en"
        )
        
        vlens?.delegate = self
        vlens?.setAccessToken(accessTextField.text ?? "")
        
        vlens?.present(on: self, withLivenessOnly: true)
    }
    
}

extension ViewController: VLensDelegate {
    func didValidateSuccessfully(transactionId: String) {
        debugPrint("Validation successful with transactionId: \(transactionId)")
    }
    
    func didFailToValidate(transactionId: String, error: String) {
        debugPrint("Validation failed with transactionId: \(transactionId) and error: \(error)")
    }
}
