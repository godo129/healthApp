//
//  ExerciseTypesCollectionViewCell.swift
//  healthApp
//
//  Created by hong on 2021/11/18.
//

import UIKit

class ExerciseTypesCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 150.0/2.0
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.link.cgColor
        return imageView
    }()
    
    private let typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        typeLabel.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.5)
        typeLabel.textAlignment = .center
        return typeLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(typeLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        imageView.frame = contentView.bounds
        typeLabel.frame = CGRect(x: 0, y: imageView.frame.size.height-40, width: contentView.frame.size.width, height: 30)
    }
    
    public func configure(name: String) {
        
        imageView.image = UIImage(named: name)
        typeLabel.text = name
    }
}
