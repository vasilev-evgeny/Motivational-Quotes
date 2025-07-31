//
//  StikerView.swift
//  Motivational_Quotes
//
//  Created by Евгений Васильев on 29.07.2025.
//
import UIKit

class StikerView : UIView {
    enum Constants {
        
    }
    
    var quote: Quote?
    
    //MARK: - Create UI
    
    var backGroundImageView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "stiker")
        return view
    }()
    
    let quoteLabel : UILabel = {
        let label = UILabel()
        label.text = "Загрузка цитаты"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let saveButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "saveButtonImage"), for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let refreshButon : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "refreshButtonImage"), for: .normal)
        button.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let categoryLabel : UILabel = {
        let label = UILabel()
        label.text = "категория: "
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    //MARK: - Action Func
    
    @objc func saveButtonTapped() {
        print("bogy slava")
    }
    
    @objc func refreshButtonTapped() {
        print("allilya")
    }
    
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
           self.layer.shadowOpacity = 0.3
           self.layer.shadowOffset = CGSize(width: 0, height: 1)
           self.layer.shadowRadius = 1
           self.layer.cornerRadius = 12
           self.clipsToBounds = false
           self.layer.masksToBounds = false
    }
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            setupViews()
            setConstraints()
        }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    private func setupViews() {
        addSubview(backGroundImageView)
        addSubview(quoteLabel)
        addSubview(saveButton)
        addSubview(refreshButon)
        addSubview(categoryLabel)
        addShadow()
    }
    
    //MARK: - setConstraints
    
    private func setConstraints() {
        backGroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backGroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backGroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backGroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backGroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        quoteLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quoteLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            quoteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            quoteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            saveButton.widthAnchor.constraint(equalToConstant: 20),
            saveButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        refreshButon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            refreshButon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            refreshButon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            refreshButon.widthAnchor.constraint(equalToConstant: 20),
            refreshButon.heightAnchor.constraint(equalToConstant: 20)
        ])
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            categoryLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
