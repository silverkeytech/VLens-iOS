//
//  ViewController.swift
//  VLensDemo
//
//  Created by Mohamed Taher on 10/11/2024.
//

import UIKit
import VLens

class ViewController: UIViewController {

    let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMTQ4MyIsIm5hbWUiOiIrMjAxNTU2MDA1Njc1IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZW1haWxhZGRyZXNzIjoibXRhaGVyaGFzc2FuOTVAZ21haWwuY29tIiwiQXNwTmV0LklkZW50aXR5LlNlY3VyaXR5U3RhbXAiOiJYRDVVTUpMMzZFMlU3SkxQNFlEVTdXQzVINENHVVlPVSIsInJvbGUiOiJCdXNpbmVzc1JlcXVlc3RVc2VyIiwiaHR0cDovL3d3dy5hc3BuZXRib2lsZXJwbGF0ZS5jb20vaWRlbnRpdHkvY2xhaW1zL3RlbmFudElkIjoiNDE3IiwianRpIjoiYjUyNDgwYmEtNjRkYi00ZTA1LWJlNGMtZjc5N2Y5M2M5MTMxIiwiaWF0IjoxNzMxMzEzMzMyLCJ0b2tlbl92YWxpZGl0eV9rZXkiOiI0MWM5N2NjYS01ODQwLTRiNTMtODlmMy05MTk0YTljOGI2MmIiLCJ1c2VyX2lkZW50aWZpZXIiOiIxMTQ4M0A0MTciLCJ0b2tlbl90eXBlIjoiMCIsInJlZnJlc2hfdG9rZW5fdmFsaWRpdHlfa2V5IjoiYWViOTdmNDctMDBmMC00MjJmLTgwZWQtY2U5MTY1YjRhOTVhIiwibmJmIjoxNzMxMzEzMzMyLCJleHAiOjE3MzEzMTUxMzIsImlzcyI6IkFicFplcm9UZW1wbGF0ZSIsImF1ZCI6IkFicFplcm9UZW1wbGF0ZSJ9.rcCLeVVY15xPbXDBoZZekBPExPMbAEcaK7Y2koqLeW4"
    
    private var vlens: VLensManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        vlens = VLensManager(
            apiKey      : "W70qYFzumZYn9nPqZXdZ39eRjpW5qRPrZ4jlxlG6c",
            secretKey   : "",
            tenancyName : "silverkey2",
            language    : "en"
        )
        
        vlens?.delegate = self
        vlens?.setAccessToken(accessToken)
        
        
    }

    @IBAction func getStartedButtonAction(_ sender: Any) {
        vlens?.present(on: self)
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
