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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(label)
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

