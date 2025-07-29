//
//  ViewController.swift
//  Motivational_Quotes
//
//  Created by Евгений Васильев on 28.07.2025.
//

import UIKit

class ViewController: UIViewController {
    
    enum Constants {
        
    }
    
    var citata = Quote(quote: String(), author: String(), category: String())
    
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
        return field
    }()
    
    let stiker1 = StikerView()
    
    //MARK: - Action Func

    func setQuotes() {
        stiker1.loadRandomQuote()
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setQuotes()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(logoImageView)
        view.addSubview(searchTextField)
        view.addSubview(stiker1)
    }
    
    //MARK: - setConstraints
    
    private func setConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        stiker1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stiker1.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 50),
            stiker1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            stiker1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            stiker1.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

}

