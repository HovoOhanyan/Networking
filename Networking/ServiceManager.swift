//
//  ServiceManager.swift
//  Networking
//
//  Created by Hovo Ohanyan on 09.01.24.
//

import Foundation

final class ServiceManager<T: Service> {
    var urlSession = URLSession.shared
    
    func load(service: T, complitonHandler: @escaping (Result<Data>) -> Void) {
        call(request: service.urlRequest, complitionHandler: complitonHandler)
    }
    
    func load<U>(service: T, decodeType: U.Type, complitionHandler: @escaping (Result<U>) -> Void) where U: Codable {
        call(request: service.urlRequest) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                
                do {
                    let resp = try decoder.decode(decodeType, from: data)
                    complitionHandler(.success(resp))
                } catch {
                    complitionHandler(.failure(HTTPError.parsingFailed))
                }
            case .failure(let error):
                complitionHandler(.failure(error))
            case .empty:
                complitionHandler(.failure(HTTPError.noData))
            }
        }
    }
}

extension ServiceManager {
    private func call(request: URLRequest, deliverQueue: DispatchQueue = DispatchQueue.main, complitionHandler: @escaping (Result<Data>) -> Void) {
        urlSession.dataTask(with: request) { data, response, error in
            if let error {
                deliverQueue.async {
                    complitionHandler(.failure(error))
                }
            } else if let data {
                deliverQueue.async {
                    complitionHandler(.success(data))
                }
            } else {
                deliverQueue.async {
                    complitionHandler(.empty)
                }
            }
        }.resume()
    }
}
