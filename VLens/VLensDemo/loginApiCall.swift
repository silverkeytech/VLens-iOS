//
//  loginApiCall.swift
//  VLens
//
//  Created by Mohamed Taher on 21/11/2024.
//

import Foundation
import CoreLocation // For CLLocationCoordinate2D if geoLocation is dynamic

func loginApi(completion: @escaping (String?) -> Void) {
    let urlString = "https://api.vlenseg.com/api/DigitalIdentity/Login"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }

    // Create the request body
    let requestBody: [String: Any] = [
        "geoLocation": [
            "latitude": 30.193033,
            "longitude": 31.463339
        ],
        "imsi": NSNull(),
        "imei": "123456789",
        "phoneNumber": "+201556005675",
        "password": "P@ssword123"
    ]

    // Serialize the request body to JSON
    guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
        print("Failed to serialize request body")
        completion(nil)
        return
    }

    // Configure the request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("text/plain", forHTTPHeaderField: "Accept")
    request.setValue("W70qYFzumZYn9nPqZXdZ39eRjpW5qRPrZ4jlxlG6c", forHTTPHeaderField: "ApiKey")
    request.setValue("silverkey2", forHTTPHeaderField: "TenancyName")
    request.httpBody = jsonData

    // Perform the API call
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error during login:", error.localizedDescription)
            completion(nil)
            return
        }

        guard let data = data else {
            print("No data received")
            completion(nil)
            return
        }

        // Parse the response
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let responseData = json["data"] as? [String: Any],
               let accessToken = responseData["accessToken"] as? String {
                print("Access Token:", accessToken)
                completion(accessToken)
            } else {
                print("Access Token not found in the response")
                completion(nil)
            }
        } catch {
            print("Failed to parse JSON:", error.localizedDescription)
            completion(nil)
        }
    }
    
    task.resume()
}
