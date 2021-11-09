//
//  SideMenuViewController.swift
//  healthApp
//
//  Created by hong on 2021/11/08.
//

import UIKit
import FirebaseStorage
import Lottie


class SideMenuViewController: UIViewController {
    
    private var profileImageView: UIButton = {
        let profileImageView = UIButton()

        //버튼 형태 변환
        profileImageView.layer.cornerRadius = 95
        profileImageView.clipsToBounds = true
        return profileImageView
    }()
    
    private let dogAnimation: AnimationView = {
        var dogAnimation = AnimationView()
        dogAnimation = .init(name: "runDog")
        dogAnimation.loopMode = .loop
        dogAnimation.animationSpeed = 0.7
        dogAnimation.play()
        return dogAnimation
    }()
    
    
    let storage = Storage.storage().reference()
    
    
    private let nickLabel: UILabel = {
        let nickLabel = UILabel()
        nickLabel.textColor = .white
        nickLabel.textAlignment = .center
        return nickLabel
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(profileImageView)
        view.addSubview(nickLabel)
        nickLabel.text = nick
    
        view.addSubview(dogAnimation)
/*
        storage.child("\(p_id)/images/profileImage\(p_id).png").downloadURL { url, error in
            guard let url = url, error == nil else {
                
                profileImage = defaultPersonImage!
                
                guard let image = defaultPersonImage else {
                    return
                }
                
                guard let data = image.pngData() else {
                    return
                }
                
                self.storage.child("\(p_id)/images/profileImage\(p_id).png").putData(data)
                self.profileImageView.setImage(image, for: .normal)
                
                return
            }
            
            
            let urls = URL(string: url.absoluteString)!
            
            let task = URLSession.shared.dataTask(with: urls) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                let image = UIImage(data: data)
                
                
                
                DispatchQueue.main.sync {
                    self.profileImageView.setImage(image, for: .normal)
                    profileImage = image!
                }
            }
            task.resume()
        }
        
        */
        
        view.backgroundColor = .systemGray

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        profileImageView.setImage(profileImage, for: .normal)
        nickLabel.text = nick
        
        profileImageView.addTarget(self, action: #selector(profileImageViewTapped), for: .touchUpInside)
        
        
            
        }
        
        /*
        
        storage.child("\(p_id)/images/profileImage\(p_id).png").downloadURL { url, error in
            guard let url = url, error == nil else {
                
                profileImage = defaultPersonImage!
                
                guard let image = defaultPersonImage else {
                    return
                }
                
                guard let data = image.pngData() else {
                    return
                }
                
                self.storage.child("\(p_id)/images/profileImage\(p_id).png").putData(data)
                self.profileImageView.setImage(image, for: .normal)
                
                return
            }
            
            
            let urls = URL(string: url.absoluteString)!
            
            let task = URLSession.shared.dataTask(with: urls) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                let image = UIImage(data: data)
                
                
                
                DispatchQueue.main.sync {
                    self.profileImageView.setImage(image, for: .normal)
                    profileImage = image!
                }
            }
            task.resume()
        }
 */
    
    
    @objc private func profileImageViewTapped() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImageView.frame = CGRect(x: 20, y: 200, width: 260, height: 200)
        nickLabel.frame = CGRect(x: 100, y: profileImageView.frame.origin.y+200, width: 100, height: 50)
        
        dogAnimation.frame = CGRect(x: 0, y: nickLabel.frame.origin.y + 70, width: view.frame.size.width, height: view.frame.size.width)
    }
    

}


