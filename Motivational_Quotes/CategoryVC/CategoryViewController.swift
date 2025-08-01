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
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let whatLabel : UILabel = {
        let label = UILabel()
        label.text = "What makes you\nfeel that way?"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 28, weight: .black)
        label.textAlignment = .center
        return label
    }()
    
    let selectLabel : UILabel = {
        let label = UILabel()
        label.text = "you can select more than one"
        label.textColor = .black
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
    
    let changeLabel : UILabel = {
        let label = UILabel()
        label.text = "you can change it later"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    let doneButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "cellSelectedBackgroundImage"), for: .normal)
        button.setTitle("done", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Set Delegates
    
    func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
    }
    
    //MARK: - Action Func
    
    @objc func doneButtonTapped() {
        // Сохраняем выбранные категории
        CitataManager.shared.saveSelectedCategories()
        
        // Получаем MainViewController из navigation stack
        if let mainVC = navigationController?.viewControllers.first(where: { $0 is MainViewController }) as? MainViewController {
            // Очищаем все текущие стикеры
            mainVC.stickersStackView.arrangedSubviews.forEach { view in
                mainVC.stickersStackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
            
            // Добавляем новые стикеры по количеству выбранных категорий
            for _ in 0..<CitataManager.shared.selectedCategories.count {
                mainVC.addSticker()
            }
            
            // Показываем индикатор загрузки
            let loader = UIActivityIndicatorView(style: .large)
            loader.center = mainVC.view.center
            loader.startAnimating()
            mainVC.view.addSubview(loader)
            
            // Загружаем цитаты для новых категорий
            CitataManager.shared.loadCitatesForCategories {
                DispatchQueue.main.async {
                    loader.removeFromSuperview()
                    CitataManager.shared.fillStickers(in: mainVC.stickersStackView)
                }
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
//    @objc func doneButtonTapped() {
//        let defaults = UserDefaults.standard
//        let currentSavedCategories = defaults.stringArray(forKey: "SelectedCategories") ?? []
//        let previousCategories = CitataManager.shared.selectedCategories
//        if currentSavedCategories == previousCategories {
//            print("Категории не изменились — обновление не требуется")
//            navigationController?.popViewController(animated: true)
//            return
//        }
//        CitataManager.shared.saveSelectedCategories()
//        if let mainVC = navigationController?.viewControllers.first(where: { $0 is MainViewController }) as? MainViewController {
//            let difference = CitataManager.shared.selectedCategories.count - mainVC.stickersStackView.arrangedSubviews.count
//            if difference > 0 {
//                for _ in 0..<difference {
//                    mainVC.addSticker()
//                }
//            } else if difference < 0 {
//                for _ in 0..<abs(difference) {
//                    if let lastSticker = mainVC.stickersStackView.arrangedSubviews.last {
//                        mainVC.stickersStackView.removeArrangedSubview(lastSticker)
//                        lastSticker.removeFromSuperview()
//                    }
//                }
//            }
//            let loader = UIActivityIndicatorView(style: .large)
//            loader.center = mainVC.view.center
//            loader.startAnimating()
//            mainVC.view.addSubview(loader)
//            CitataManager.shared.loadCitatesForCategories {
//                loader.removeFromSuperview()
//                CitataManager.shared.fillStickers(in: mainVC.stickersStackView)
//            }
//            navigationController?.popViewController(animated: true)
//        }
//    }

    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setDelegates()
        let defaults = UserDefaults.standard
            if let savedCategories = defaults.array(forKey: "SelectedCategories") as? [String] {
                CitataManager.shared.selectedCategories = savedCategories
            }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(catLabel)
        view.addSubview(whatLabel)
        view.addSubview(selectLabel)
        view.addSubview(collectionView)
        view.addSubview(changeLabel)
        view.addSubview(doneButton)
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
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 137),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -137),
        ])
        
        changeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            changeLabel.bottomAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: -60),
            changeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 72),
            changeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -72),
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: selectLabel.bottomAnchor, constant: 15),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            collectionView.bottomAnchor.constraint(equalTo: changeLabel.topAnchor, constant: -24),
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
        cell.label.text = CategoryList.shared.categoryList[indexPath.item]
      
        let isSelected = CitataManager.shared.selectedCategories.contains(cell.label.text ?? "")
                cell.backgroundImageView.image = isSelected ? UIImage(named: "cellSelectedBackgroundImage") : UIImage(named: "cellBackgroundImage")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell,
                     let categoryText = cell.label.text else { return }
        if let index = CitataManager.shared.selectedCategories.firstIndex(of: categoryText) {
            CitataManager.shared.selectedCategories.remove(at: index)
            cell.backgroundImageView.image = UIImage(named: "cellBackgroundImage")
                } else {
                    CitataManager.shared.selectedCategories.append(categoryText)
                    cell.backgroundImageView.image = UIImage(named: "cellSelectedBackgroundImage")
                }
                collectionView.reloadItems(at: [indexPath])
            }
    }

