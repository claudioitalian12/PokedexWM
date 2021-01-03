//
//  NetworkError.swift
//  Pokedex
//
//  Created by claudio cavalli on 01/05/2020.
//  Copyright © 2020 claudio cavalli. All rights reserved.
//

import Foundation

enum NetworkError: String, Error {
    case badURL = "Error URL"
    case requestFailed = "Request Failed"
    case unknown = "Error"
    case jsonParsingError = "JSON Parsing Error"
    case notConnect = "Connection not working"
}
