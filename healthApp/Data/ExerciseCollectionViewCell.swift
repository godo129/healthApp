//
//  ExerciseCollectionViewCell.swift
//  healthApp
//
//  Created by hong on 2021/11/13.
//

import UIKit



class ExerciseCollectionViewCell: UICollectionViewCell {
    
    var ExerciseImage: UIImageView = {
        let ExerciseImage = UIImageView()
        ExerciseImage.backgroundColor = .white
        ExerciseImage.clipsToBounds = true
        ExerciseImage.contentMode = .scaleAspectFill
        return ExerciseImage
    }()
    
    var ExerciseLabel: UILabel = {
        let ExerciseLabel = UILabel()
        ExerciseLabel.backgroundColor = .gray
        ExerciseLabel.textAlignment = .center
        ExerciseLabel.textColor = .white
        ExerciseLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        return ExerciseLabel
        
    }()
    
    static let identifier = "ExerciseCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemRed

        contentView.addSubview(ExerciseImage)
        contentView.addSubview(ExerciseLabel)
        contentView.clipsToBounds = true

        
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    /*
    func setUpCompo() {
        
        ExerciseLabel = UILabel()
        
        
        ExerciseImage = UIImageView()
        contentView.addSubview(ExerciseImage)
        contentView.addSubview(ExerciseImage)
        ExerciseImage.translatesAutoresizingMaskIntoConstraints = false
        ExerciseImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        ExerciseImage.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        ExerciseImage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        ExerciseImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        
    }
    
    func setUpLabel() {
        ExerciseLabel.font = UIFont.systemFont(ofSize: 20)
        ExerciseLabel.textAlignment = .center
        
    }
 */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ExerciseImage.frame = contentView.bounds
        
        ExerciseLabel.frame = CGRect(x: 5,
                                     y: contentView.frame.size.height-30,
                                     width: contentView.frame.size.width+20,
                                     height: 30)
    }
    
}
