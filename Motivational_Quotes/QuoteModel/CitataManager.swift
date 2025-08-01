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
        let url = URL(string: baseURLString)//все равно загружаю любые цитаты так как базовый аккаунт уменя, бесплатный, поэтому не принимаю url а загружаю базовый
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
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Ответ API:", jsonString)
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
    
    func loadRandomQuote(view: StikerView) {
        let url = URL(string: "https://api.api-ninjas.com/v1/quotes")!
        loadQuotes(url: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let quotes):
                    if let randomQuote = quotes.randomElement() {
                        view.quoteLabel.text = randomQuote.quote
                    } else {
                        view.quoteLabel.text = "Нет цитат (пустой ответ)"
                    }
                case .failure(let error):
                    print("Ошибка загрузки:", error)
                    view.quoteLabel.text = "Ошибка: см. консоль"
                }
            }
        }
    }
    
    static let savedQuotesKey = "SavedQuotes"
    
    struct SavedQuote: Codable {
        let quote: String
        let author: String?
        let category: String?
        let date: Date
    }
    
    func saveQuote(_ quote: Quote) {
        var savedQuotes = getSavedQuotes()
        let savedQuote = SavedQuote(quote: quote.quote,
                                    author: quote.author,
                                    category: quote.category,
                                    date: Date())
        savedQuotes.append(savedQuote)
        
        saveQuotesToUserDefaults(savedQuotes)
    }
    
    func getSavedQuotes() -> [SavedQuote] {
        if let data = UserDefaults.standard.data(forKey: CitataManager.savedQuotesKey),
           let savedQuotes = try? JSONDecoder().decode([SavedQuote].self, from: data) {
            return savedQuotes
        }
        return []
    }
    
    func saveQuotesToUserDefaults(_ quotes: [SavedQuote]) {
        if let encoded = try? JSONEncoder().encode(quotes) {
            UserDefaults.standard.set(encoded, forKey: CitataManager.savedQuotesKey)
        }
    }

    
}
//MARK: - extension UserCitates
extension CitataManager {
    struct UserQuote: Codable {
        let quote: String
        let author: String
        let date: Date
    }
    
    private enum UserDefaultsKeys {
        static let userQuotes = "UserQuotes"
    }
    
    func saveUserQuote(_ quote: String, author: String? = nil) {
        var userQuotes = getUserQuotes()
        let newQuote = UserQuote(
            quote: quote,
            author: author ?? "Вы",
            date: Date()
        )
        userQuotes.append(newQuote)
        saveUserQuotes(userQuotes)
    }
    
    func getUserQuotes() -> [UserQuote] {
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.userQuotes),
           let userQuotes = try? JSONDecoder().decode([UserQuote].self, from: data) {
            return userQuotes
        }
        return []
    }
    
    private func saveUserQuotes(_ quotes: [UserQuote]) {
        if let encoded = try? JSONEncoder().encode(quotes) {
            UserDefaults.standard.set(encoded, forKey: UserDefaultsKeys.userQuotes)
        }
    }
    
    func getAllQuotes() -> [SavedQuote] {
        let apiQuotes = getSavedQuotes()
        let userQuotes = getUserQuotes().map {
            SavedQuote(
                quote: $0.quote,
                author: $0.author,
                category: "Пользовательские",
                date: $0.date
            )
        }
        return (apiQuotes + userQuotes).sorted { $0.date > $1.date }
    }
    
    func removeQuote(at index: Int) {
        let allQuotes = getAllQuotes()
        guard index < allQuotes.count else { return }
        
        let quoteToRemove = allQuotes[index]
        if quoteToRemove.category == "Пользовательские" {
            var userQuotes = getUserQuotes()
            userQuotes.removeAll { $0.quote == quoteToRemove.quote && $0.date == quoteToRemove.date }
            saveUserQuotes(userQuotes)
        } else {
            var apiQuotes = getSavedQuotes()
            apiQuotes.removeAll { $0.quote == quoteToRemove.quote && $0.date == quoteToRemove.date }
            saveQuotesToUserDefaults(apiQuotes)
        }
    }
}
