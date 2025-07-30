//
//  CitataManager.swift
//  Motivational_Quotes
//
//  Created by Евгений Васильев on 29.07.2025.
//

import UIKit

final class CitataManager {
    static let shared = CitataManager()
    
    var selectedCategories : [String] = []
    
    func loadQuotes(completion: @escaping (Result<[Quote], Error>) -> Void) {
        guard let url = URL(string: "https://api.api-ninjas.com/v1/quotes") else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("qUiYfR8gL87+IGZc+6Q5+g==h1xsANlr8cCWUEQ5", forHTTPHeaderField: "X-Api-Key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "NoData", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])
                completion(.failure(error))
                return
            }
            
            do {
                let quotes = try JSONDecoder().decode([Quote].self, from: data)
                completion(.success(quotes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
