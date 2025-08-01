//
//  SavedViewController.swift
//  Motivational_Quotes
//
//  Created by Евгений Васильев on 01.08.2025.
//
import UIKit

class SavedViewController : UIViewController {
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
        //button.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
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
    
    //MARK: - Set Delegates
    
    func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SavedQuoteCell.self, forCellWithReuseIdentifier: "SavedQuoteCell")
    }
    
    //MARK: - Action Func
    
    private func loadQuotes() {
        savedQuotes = CitataManager.shared.getSavedQuotes().reversed()
           collectionView.reloadData()
           
           if savedQuotes.isEmpty {
               let emptyLabel = UILabel()
               emptyLabel.text = "No saved quotes yet"
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
    
    @objc func postButtonTapped() {
        let vc = PostViewController()
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
        loadQuotes()
        savedQuotesButton.isSelected = true
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
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            collectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -30),
        ])
    }
}

//MARK: - Extension COllection

extension SavedViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        savedQuotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedQuoteCell", for: indexPath) as?
                SavedQuoteCell else {
            return UICollectionViewCell()
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



