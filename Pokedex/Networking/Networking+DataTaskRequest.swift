//
//  Networking+DataTaskRequest.swift
//  Pokedex
//
//  Created by claudio cavalli on 01/05/2020.
//  Copyright © 2020 claudio cavalli. All rights reserved.
//

import UIKit

extension Networking {
    static func dataTask(with request: URLRequest, completionHandler completion: @escaping completionHandler) -> URLSessionDataTask {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error as? URLError {
                switch error.code {
                case .networkConnectionLost,.notConnectedToInternet:
                    guard let myJson = JSONManager<Model>.readResponse(named: request.url!.lastPathString) else {
                        completion(.failure(.requestFailed))
                        return
                    }
                    
                    completion(.success(myJson))
                    return
                default:
                    completion(.failure(.requestFailed))
                    return
                }
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let model = try JSONDecoder().decode(Model.self, from: data)
                        JSONManager<Model>.saveResponse(named: request.url!.lastPathString, object: data)
                        completion(.success(model))
                    } catch {
                        completion(.failure(.jsonParsingError))
                    }
                } else {
                    completion(.failure(.requestFailed))
                }
            } else {
                completion(.failure(.requestFailed))
            }
        }
        return task
    }
    
    static func dataTaskRequest(request: URLRequest, completion: @escaping completionHandler) {
        let sessionDataTask = dataTask(with: request) { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let response):
                    guard let response = response else { return }
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        sessionDataTask.resume()
    }
}
