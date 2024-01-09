//
//  ServiceResult.swift
//  Networking
//
//  Created by Hovo Ohanyan on 09.01.24.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
    case empty
}
