//
//  ServiceProtocol.swift
//  Networking
//
//  Created by Hovo Ohanyan on 09.01.24.
//

import Foundation

protocol Service {
    var baseURL: String { get }
    var path: String { get }
    var parametrs: [String: Any]? { get }
    var method: HTTPMethod { get }
}

extension Service {
    public var url: URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path
        
        if method == .get {
            guard let parametrs = parametrs as? [String: String] else {
                fatalError()
            }
            
            urlComponents?.queryItems = parametrs.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        
        return urlComponents?.url
    }
    
    public var urlRequest: URLRequest {
        guard let url = self.url else {
            fatalError()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
