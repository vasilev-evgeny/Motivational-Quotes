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
    
    //MARK: - Create UI
    
    let
    
    let quoteLabel : UILabel = {
        let label = UILabel()
        label.text = "цитата даже даже"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 3
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
    
    //MARK: - Action Func
    
    @objc func saveButtonTapped() {
        print("bogy slava")
    }
    
    @objc func refreshButtonTapped() {
        print("allilya")
    }
    
    //MARK: - Lifecycle
    
    func viewDidLoad() {
        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        
    }
    
    //MARK: - setConstraints
    
    private func setConstraints() {
        
    }
}
