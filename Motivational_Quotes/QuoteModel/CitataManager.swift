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
    var catKey = "SelectedCategories"
    
    private let baseURLString = "https://api.api-ninjas.com/v1/quotes"
    var url = URL(string: "https://api.api-ninjas.com/v1/quotes")
    
    func saveSelectedCategories() {
        let defaults = UserDefaults.standard
        defaults.set(CitataManager.shared.selectedCategories, forKey: catKey)
        print(UserDefaults.standard.stringArray(forKey: catKey)!)
    }
    
    func loadCitatesForCategories(completion: @escaping () -> Void) {
        guard !selectedCategories.isEmpty else {
            completion()
            return
        }
        var loadedCount = 0
        let expectedCount = selectedCategories.count
        
        for category in selectedCategories {
            let urlString = "\(baseURLString)?category=\(category)"
            guard let url = URL(string: urlString) else {
                loadedCount += 1
                continue
            }
            loadQuotes(url: url) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let quotes):
                        self!.quotesByCategory[category] = quotes
                    case .failure(let error):
                        print("Ошибка загрузки для категории \(category): \(error)")
                    }
                    loadedCount += 1
                    if loadedCount == expectedCount {
                        completion()
                    }
                }
            }
        }
    }
    
    func loadQuotes(url: URL,completion: @escaping (Result<[Quote], Error>) -> Void) {
        let url = URL(string: baseURLString)
        var request = URLRequest(url: url!)
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
    
    func fillStickers(in stackView: UIStackView) {
        let stickerViews = stackView.arrangedSubviews.compactMap { $0 as? StikerView }
        for (index, category) in selectedCategories.enumerated() {
            guard index < stickerViews.count else { break }
            let stickerView = stickerViews[index]
            stickerView.categoryLabel.text = category.capitalized
            if let quotes = quotesByCategory[category],
               let randomQuote = quotes.randomElement() {
                stickerView.quoteLabel.text = randomQuote.quote
                stickerView.quote = randomQuote 
            } else {
                stickerView.quoteLabel.text = "Цитата не загружена"
            }
        }
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

