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
    var quotesByCategory : [String: [Quote]] = [:]
     var allQuotes : [Quote] = []
    
    private let baseURLString = "https://api.api-ninjas.com/v1/quotes"
    var url = URL(string: "https://api.api-ninjas.com/v1/quotes")
    
    func loadCitatesForCategories() {
        guard !selectedCategories.isEmpty else { return }
            for category in selectedCategories {
                let urlString = "\(baseURLString)?category=\(category)"
                let url = URL(string: urlString)
                loadQuotes(url: url!) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let quotes):
                            self!.quotesByCategory[category] = quotes
                        case .failure(let error):
                            print("Ошибка загрузки для категории \(category): \(error)")
                        }
                    }
                }
            }
        }
    
    func loadQuotes(url: URL,completion: @escaping (Result<[Quote], Error>) -> Void) {
        
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
    
    func loadRandomQuote(view : StikerView) {
        CitataManager.shared.loadQuotes(url: CitataManager.shared.url!) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let quotes):
                    if let randomQuote = quotes.randomElement() {
                        view.quoteLabel.text = randomQuote.quote
                    } else {
                        view.quoteLabel.text = "Цитата не найдена"
                    }
                case .failure:
                    view.quoteLabel.text = "Не удалось загрузить"
                }
            }
        }
    }
}

