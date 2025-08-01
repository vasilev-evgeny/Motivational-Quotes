//
//  SavedQuoteCell.swift
//  Motivational_Quotes
//
//  Created by Евгений Васильев on 01.08.2025.
//
import UIKit

class SavedQuoteCell: UICollectionViewCell {
    
    
    let label : UILabel = {
        let label = UILabel()
        label.text = "Citata"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let shareButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "shareButtonImage"), for: .normal)
        return button
    }()
    
    let identifier = "CategoryCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
        addBorder()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(label)
        contentView.addSubview(shareButton)
    }
    
    func addBorder() {
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(red: 78/255, green: 78/255, blue: 78/255, alpha: 1).cgColor
        self.clipsToBounds = false
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    private func setConstraints() {
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            shareButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18)
        ])
    }
}


