//
//  HTTPError.swift
//  Networking
//
//  Created by Hovo Ohanyan on 09.01.24.
//

import Foundation

enum HTTPError: Error {
    case urlFailed
    case noData
    case requestError
    case parsingFailed
}
