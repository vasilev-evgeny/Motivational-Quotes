//
//  CategoryCell.swift
//  Motivational_Quotes
//
//  Created by Евгений Васильев on 30.07.2025.
//
import UIKit

class CategoryCell: UICollectionViewCell {
    
    let backgroundImageView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "cellBackgroundImage")
        return view
    }()
    
    let label : UILabel = {
        let label = UILabel()
        label.text = "Health"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    let identifier = "CategoryCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
        addShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(label)
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
    
    private func setConstraints() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor)
        ])
    }
}

