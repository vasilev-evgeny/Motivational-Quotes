//
//  CategoryViewController.swift
//  Motivational_Quotes
//
//  Created by Евгений Васильев on 30.07.2025.
//
import UIKit

class CategoryViewController : UIViewController {
    
    enum Constants {
        
    }
    
    //MARK: - Create UI
    
    let catLabel : UILabel = {
        let label = UILabel()
        label.text = "Categories"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let whatLabel : UILabel = {
        let label = UILabel()
        label.text = "What makes you\nfeel that way?"
        label.font = UIFont.systemFont(ofSize: 28, weight: .black)
        label.textAlignment = .center
        return label
    }()
    
    let selectLabel : UILabel = {
        let label = UILabel()
        label.text = "you can select more than one"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 16
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    //MARK: - Set Delegates
    
    func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setDelegates()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(catLabel)
        view.addSubview(whatLabel)
        view.addSubview(selectLabel)
        view.addSubview(collectionView)
    }
    
    //MARK: - setConstraints
    
    private func setConstraints() {
        catLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            catLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            catLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        whatLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            whatLabel.topAnchor.constraint(equalTo: catLabel.bottomAnchor, constant: 50),
            whatLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        selectLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectLabel.topAnchor.constraint(equalTo: whatLabel.bottomAnchor, constant: 15),
            selectLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: selectLabel.bottomAnchor, constant: 15),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
        ])
    }
}

//MARK: - Extension CollectionVew

extension CategoryViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        CategoryList.shared.categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as?
                CategoryCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
    }
}
