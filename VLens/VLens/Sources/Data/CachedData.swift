//
//  CachedData.swift
//  VLens
//
//  Created by Mohamed Taher on 10/11/2024.
//

class CachedData {
    
    static let shared = CachedData()
    private init() {}  
    
    // MARK: - Entry Point Properties
    var apiKey      : String   = ""
    var secretKey   : String   = ""
    var tenancyName : String   = ""
    var accessToken : String   = ""
    var language    : String   = "en"
    
    // MARK: - Transaction Properties
    var transactionId = ""
}
