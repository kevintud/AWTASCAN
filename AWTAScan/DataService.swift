//
//  DataService.swift
//  AWTAScan
//
//  Created by Kevin Lloyd Tud on 12/8/23.
//

import Foundation


class DataService {
    
    static var fetchedData: [String: Any]?
    static func fetchData(delegateID: String) {
        // Construct the URL with the delegateID
        let baseURL = "https://online.lampawta.com/api/delegate/"
        let apiKey = "bdf0bf18-54cf-4aca-86ec-a03b77c02264"
        
        guard let url = URL(string: "\(baseURL)\(delegateID)?api_key=\(apiKey)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // Store the fetched data
                        self.fetchedData = json
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }.resume()
    }
}
