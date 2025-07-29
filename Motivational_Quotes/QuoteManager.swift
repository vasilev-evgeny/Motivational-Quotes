//
//  QuoteManager.swift
//  Motivational_Quotes
//
//  Created by Евгений Васильев on 29.07.2025.
//
import UIKit

final class QuoteManager {
    
    
    var shared = QuoteManager()
    
    var apiKey = "qUiYfR8gL87+IGZc+6Q5+g==h1xsANlr8cCWUEQ5"
    
    func getQuote(completion : @escaping(Result<[Quotes], Error>) -> Void) {
        var url = URL(string : "https://api.api-ninjas.com/v1/quotes")
        
        var request = URLRequest(url: url!)
        request.setValue("qUiYfR8gL87+IGZc+6Q5+g==h1xsANlr8cCWUEQ5", forHTTPHeaderField: "X-Api-Key")

        performRequest(with: "\(request)", completion: completion)
    }
    
    private func performRequest(with urlString: String, completion : @escaping (Result<[Quotes], Error>) -> Void) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, _ , error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(QuoteData.self, from: data)
                        completion(.success(decodedData.data.quotes))
                    } catch {
                        completion(.failure(error))
                        print(error)
                    }
                    print(data)
                }
            }
            task.resume()
        }
    }
 
}







