//
//  NetErrors.swift
//  MyMacApp
//
//  Created by Richard Lam on 28/5/2024.
//

import Foundation



enum NetError: Error {
    case invalidURL(error: Error?)
    case invalidResponse(error: Error?)
    case invalidData(error: Error?)
    case unreachable(error: Error?)
    case general(error: Error?)
    case httpError(statusCode: Int)
    
}
