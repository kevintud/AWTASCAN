//
//  APIK.swift
//  AWTAScan
//
//  Created by Kevin on 4/3/25.
//

import Foundation

class APIKeysManager {
    private static var apiKeys: [String: Any]? = {
        guard let url = Bundle.main.url(forResource: "APIKeys", withExtension: "plist"),
              let data = try? Data(contentsOf: url) else {
            print("APIKeys.plist not found!")
            return nil
        }
        return (try? PropertyListSerialization.propertyList(from: data, options: [], format: nil)) as? [String: Any]
    }()
    
    static func apiKey(for key: String) -> String? {
        return apiKeys?[key] as? String
    }
}
