//
//  ViewController.swift
//  Motivational_Quotes
//
//  Created by Евгений Васильев on 28.07.2025.
//

import UIKit

class MainViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    enum Constants {
        static let catKey = "SelectedCategories"
    }
    
    var citata = Quote(quote: String(), author: String(), category: String())
    private var allStickersTexts : [String] = []
    
    
    //MARK: - Create UI
    
    let logoImageView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Logo")
        return view
    }()
    
    let searchTextField : UITextField = {
        let field = UITextField()
        field.placeholder = "Find qoute"
        field.layer.borderWidth = 0.5
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.cornerRadius = 7
        field.returnKeyType = .done
        field.clearButtonMode = .whileEditing
        field.autocorrectionType = .no
        return field
    }()
    
    let categoryButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "categoriesButtonImage"), for: .normal)
        button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let scrollView : UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = true
        return view
    }()
    
    let stickersStackView : UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 5
        view.clipsToBounds = false
        return view
    }()
    
    let topView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let savedQuotesButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "saveButtonImage"), for: .normal)
        button.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
        button.setBackgroundImage(UIImage(named:"selectedButtonImage"), for: .selected)
        return button
    }()
    
    let homeButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "homeButtomImage"), for: .normal)
        button.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
        button.setBackgroundImage(UIImage(named:"selectedButtonImage"), for: .selected)
        return button
    }()
    
    let postButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "postButtonImage"), for: .normal)
        button.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
        button.setBackgroundImage(UIImage(named:"selectedButtonImage"), for: .selected)
        return button
    }()
    
    let bottomButtonsStackView : UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 43
        return view
    }()
    
    //MARK: - Action Func
    
    @objc func categoryButtonTapped() {
        let vc = CategoryViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addSticker() {
        let stiker = StikerView()
        stickersStackView.addArrangedSubview(stiker)
    }
    
    @objc func bottomButtonTapped(sender: UIButton) {
        [savedQuotesButton, homeButton, postButton].forEach { button in
            button?.isSelected = false
        }
        sender.isSelected = true
    }
    
    private func loadInitialQuotes() {
        let loader = UIActivityIndicatorView(style: .large)
        loader.center = view.center
        loader.startAnimating()
        view.addSubview(loader)
        
        CitataManager.shared.loadCitatesForCategories { [weak self] in
            loader.removeFromSuperview()
            self?.updateStickers()
        }
    }
    
    private func updateStickers() {
        // Удаляем все текущие стикеры
        stickersStackView.arrangedSubviews.forEach {
            stickersStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        // Добавляем новые стикеры для всех выбранных категорий
        for _ in CitataManager.shared.selectedCategories {
            addSticker()
        }
        
        // Заполняем стикеры данными
        CitataManager.shared.fillStickers(in: stickersStackView)
    }
    
    //MARK: - Set Delegates
    
    func setDelegates() {
        scrollView.delegate = self
        searchTextField.delegate = self
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setDelegates()
        loadInitialQuotes()
    }
    
    private func setupViews() {
        homeButton.isSelected = true
        view.backgroundColor = .white
        view.addSubview(topView)
        topView.addSubview(searchTextField)
        topView.addSubview(categoryButton)
        topView.addSubview(logoImageView)
        
        view.addSubview(scrollView)
        scrollView.addSubview(stickersStackView)
        view.addSubview(bottomView)
        bottomView.addSubview(bottomButtonsStackView)
        bottomButtonsStackView.addArrangedSubview(savedQuotesButton)
        bottomButtonsStackView.addArrangedSubview(homeButton)
        bottomButtonsStackView.addArrangedSubview(postButton)
    }
    
    //MARK: - setConstraints
    
    private func setConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70)
        ])
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            categoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 35),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            scrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
        
        stickersStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stickersStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stickersStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stickersStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stickersStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stickersStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        bottomButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomButtonsStackView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 26),
            bottomButtonsStackView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 108),
            bottomButtonsStackView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -108),
            bottomButtonsStackView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -42),
            bottomButtonsStackView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor)
        ])
    }
    
    
    //MARK: - Search
    
    func getAllQuotesWithViews() -> [(text: String, sticker: StikerView, index: Int)] {
        var quotesData: [(text: String, sticker: StikerView, index: Int)] = []
        
        for (index, view) in stickersStackView.arrangedSubviews.enumerated() {
            guard let sticker = view as? StikerView, let quoteText = sticker.quoteLabel.text else { continue }
            quotesData.append((text: quoteText, sticker: sticker, index: index))
        }
        
        return quotesData
    }
    
    func highlightMatchingStickers(searchText: String) {
        let quotesData = getAllQuotesWithViews()
        var foundFirstMatch = false
        
        for (text, sticker, _) in quotesData {
            let originalAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black,
                .font: sticker.quoteLabel.font ?? UIFont.systemFont(ofSize: 17)
            ]
            let attributedString = NSMutableAttributedString(string: text, attributes: originalAttributes)
            
            if !searchText.isEmpty && text.lowercased().contains(searchText.lowercased()) {
                attributedString.highlight(text: searchText, with: .red)
                if !foundFirstMatch {
                    let offset = sticker.frame.origin.y - 50
                    scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
                    foundFirstMatch = true
                }
                
                sticker.isHidden = false
            } else if searchText.isEmpty {
                sticker.isHidden = false
            } else {
                sticker.isHidden = true
            }
            sticker.quoteLabel.attributedText = attributedString
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        highlightMatchingStickers(searchText: updatedText)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        highlightMatchingStickers(searchText: "")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let searchText = textField.text, !searchText.isEmpty {
            highlightMatchingStickers(searchText: searchText)
        } else {
            highlightMatchingStickers(searchText: "")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension NSMutableAttributedString {
    func highlight(text: String, with color: UIColor) {
        let range = (self.string.lowercased() as NSString).range(of: text.lowercased())
        if range.location != NSNotFound {
            self.addAttribute(.foregroundColor, value: color, range: range)
            self.addAttribute(.backgroundColor, value: color.withAlphaComponent(0.3), range: range)
        }
    }
}
