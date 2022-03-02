//
//  Error+Extension.swift
//  MET
//
//  Created by Django on 3/2/22.
//

import Moya

extension Swift.Error {
    /// Swift.Error description, handles all type of error
    public var errorDescription: String {
        if let moyaError = self as? MoyaError {
            return moyaError.errorMoyaDescription
        } else {
            return localizedDescription
        }
    }
}
