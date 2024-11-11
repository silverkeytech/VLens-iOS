//
//  VLensDelegate.swift
//  VLens
//
//  Created by Mohamed Taher on 10/11/2024.
//

import Foundation

public protocol VLensDelegate: AnyObject {
    func didValidateSuccessfully(transactionId: String)
    func didFailToValidate(transactionId: String, error: String)
}
