//
//  API.swift
//  AWTAScan
//
//  Created by Kevin on 4/3/25.
//

import Foundation

class API {
    
    // MARK: - GET Request
    static func get(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "API", code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "API", code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "No data returned"])
                completion(.failure(error))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    // MARK: - POST Request
    static func post(urlString: String,
                     parameters: [String: Any],
                     completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "API", code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else {
                let error = NSError(domain: "API", code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "No data returned"])
                completion(.failure(error))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
