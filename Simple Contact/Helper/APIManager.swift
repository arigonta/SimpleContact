//
//  APIManager.swift
//  Simple Contact
//
//  Created by Ari Gonta on 23/04/20.
//  Copyright © 2020 Ari Gonta. All rights reserved.
//

import Foundation

enum APIError:Error {
    case failedGetAPI
    case failedGetData
    case failedEncoding
    case errorHTTPResponse
}

enum HTTPMethod:String {
    case POST
    case GET
    case PUT
    case DELETE
}

struct APIManager {
    let resourceURL: URL
    init(endpoint: String) {
        let stringURL = "\(Constant.BASE_URL)/\(endpoint)"
        guard let resourceURL = URL(string: stringURL) else {fatalError()}
        self.resourceURL = resourceURL
    }
    
    private func checkStatusCode(_ code: Int, completion: ((Bool) -> Void)) {
        print(code)
        if code > 200 || code < 299 {
            completion(true)
        } else {
            completion(false)
        }
    }
    
     func sendRequest(_ contact: Contact? = nil ,httpMethod: HTTPMethod, completion: @escaping(Result<[Contact], APIError>) -> Void) {
        do {
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = httpMethod.rawValue
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if httpMethod == .POST || httpMethod == .PUT {
                urlRequest.httpBody = try JSONEncoder().encode(contact)
            }
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let jsonData = data else {
                    completion(.failure(.failedGetAPI))
                    return
                }
                if let http = response as? HTTPURLResponse {
                    self.checkStatusCode(http.statusCode) {
                        if $0 == true {
                            do {
                                let contactResponse = try JSONDecoder().decode(ContactReponse.self, from: jsonData)
                                completion(.success(contactResponse.data))
                            } catch {
                                completion(.failure(.failedGetData))
                            }
                        } else {
                            completion(.failure(.errorHTTPResponse))
                        }
                    }
                }
            }
            dataTask.resume()
        } catch {
            completion(.failure(.failedEncoding))
        }
    }
}
