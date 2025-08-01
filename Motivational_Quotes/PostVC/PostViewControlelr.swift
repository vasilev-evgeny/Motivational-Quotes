//
//  PostViewControlelr.swift
//  Motivational_Quotes
//
//  Created by Евгений Васильев on 01.08.2025.
//
//
import UIKit

class PostViewController : UIViewController {
    enum Constants {
        
    }
    
    private var savedQuotes: [CitataManager.SavedQuote] = []
    
    
    //MARK: - Create UI
    
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
        button.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        button.setBackgroundImage(UIImage(named:"selectedButtonImage"), for: .selected)
        return button
    }()
    
    let postButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "postButtonImage"), for: .normal)
        button.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 16
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.isScrollEnabled = true
        cv.clipsToBounds = true
        return cv
    }()
    
    let favlabel : UILabel = {
        let label = UILabel()
        label.text = "Favorites"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let postCitataButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "postCitataButtonImage"), for: .normal)
        button.addTarget(self, action: #selector(postCitataButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 8
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return tv
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите вашу цитату здесь..."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    private var isAddingNewQuote = false {
        didSet {
            collectionView.isHidden = isAddingNewQuote
            textView.isHidden = !isAddingNewQuote
            placeholderLabel.isHidden = !isAddingNewQuote || !textView.text.isEmpty
            
            // Изменяем изображение кнопки в зависимости от режима
            let imageName = isAddingNewQuote ? "selectedButtonImage" : "postCitataButtonImage"
            postCitataButton.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    //MARK: - Set Delegates
    
    func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PostQuoteCell.self, forCellWithReuseIdentifier: "PostQuoteCell")
        textView.delegate = self
        
    }
    
    //MARK: - Action Func
    
    @objc func postCitataButtonTapped() {
        if isAddingNewQuote {
            guard let text = textView.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                showAlert(title: "Ошибка", message: "Пожалуйста, введите цитату")
                return
            }
            
            CitataManager.shared.saveUserQuote(text)
            textView.text = ""
            placeholderLabel.isHidden = false
            loadQuotes()
        }
        isAddingNewQuote.toggle()
        if isAddingNewQuote {
            textView.becomeFirstResponder()
        } else {
            textView.resignFirstResponder()
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func loadQuotes() {
        savedQuotes = CitataManager.shared.getUserQuotes().map {
            CitataManager.SavedQuote(quote: $0.quote, author: $0.author, category: "Пользовательские", date: $0.date)
        }
        collectionView.reloadData()
        
        if savedQuotes.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "Нет сохраненных цитат"
            emptyLabel.textAlignment = .center
            collectionView.backgroundView = emptyLabel
        } else {
            collectionView.backgroundView = nil
        }
    }
    
    @objc func homeButtonTapped() {
        let vc = MainViewController()
        navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func saveButtonTapped() {
        let vc = SavedViewController()
        navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func bottomButtonTapped(sender: UIButton) {
        [savedQuotesButton, homeButton, postButton].forEach { button in
            button?.isSelected = false
        }
        sender.isSelected = true
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setDelegates()
        postButton.isSelected = true
        isAddingNewQuote = false
        loadQuotes()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(bottomView)
        view.addSubview(collectionView)
        view.addSubview(favlabel)
        bottomView.addSubview(bottomButtonsStackView)
        bottomButtonsStackView.addArrangedSubview(savedQuotesButton)
        bottomButtonsStackView.addArrangedSubview(homeButton)
        bottomButtonsStackView.addArrangedSubview(postButton)
        view.addSubview(textView)
        view.addSubview(placeholderLabel)
        view.addSubview(postCitataButton)
    }
    
    //MARK: - setConstraints
    
    private func setConstraints() {
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
        
        favlabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favlabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            favlabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: favlabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -20)
        ])
        
        postCitataButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postCitataButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            postCitataButton.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -18)
        ])
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: favlabel.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -20)
        ])
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 16),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 20),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -20)
        ])
    }
}

//MARK: - Extension COllection

extension PostViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedQuotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostQuoteCell", for: indexPath) as?
                PostQuoteCell else {
            return UICollectionViewCell()
        }
        guard indexPath.item < savedQuotes.count else {
            return cell
        }
        let quote = savedQuotes[indexPath.item]
        cell.label.text = quote.quote
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height: CGFloat = 200
        return CGSize(width: width, height: height)
    }
    
}
//MARK: - Extension textView

extension PostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
}



