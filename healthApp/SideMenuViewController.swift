//
//  SideMenuViewController.swift
//  healthApp
//
//  Created by hong on 2021/11/08.
//

import UIKit
import FirebaseStorage
import Lottie
import HealthKit


class SideMenuViewController: UIViewController {
    

    let toY = Int(today.split(separator: "-")[0])!
    let toM = Int(today.split(separator: "-")[1])!
    let toD = Int(today.split(separator: "-")[2])!
    
    
    var stepsLabel: UILabel = {
        var stepsLabel = UILabel()
        stepsLabel.textColor = .white
        stepsLabel.textAlignment = .center
        return stepsLabel
    }()

    
    /*
    private var profileImageView: UIButton = {
        let profileImageView = UIButton()

        //버튼 형태 변환
        profileImageView.layer.cornerRadius = 95
        profileImageView.clipsToBounds = true
        return profileImageView
    }()
 */
    
    private let dogAnimation: AnimationView = {
        var dogAnimation = AnimationView()
        dogAnimation = .init(name: "runDog")
        dogAnimation.loopMode = .loop
        dogAnimation.animationSpeed = 0.7
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
        
        //view.addSubview(profileImageView)
        view.addSubview(nickLabel)
        nickLabel.text = nick
        
        view.addSubview(stepsLabel)

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
        
        
        // 백그라운드에서 돌아가게 함 
        dogAnimation.backgroundBehavior = .pauseAndRestore
        
        
        // 자동으로 함수 계속
        //let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(restartAnimation), userInfo: nil, repeats: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.restartAnimation()
        }

        
    }
    
    @objc func restartAnimation() {
        healthAuth(Year: toY, Month: toM, Date: toD)
        stepsLabel.text = "\(UserDefaults.standard.value(forKey: "steps")!) 걸음"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        view.addSubview(profileImageView)
        // 화면 동그랗게 


        
     //   profileImageView.setImage(profileImage, for: .normal)
        nickLabel.text = nick
        
   //     profileImageView.addTarget(self, action: #selector(profileImageViewTapped), for: .touchUpInside)
        
        
        view.addSubview(dogAnimation)
        dogAnimation.play()
        
        print(toY,toM,toD)
        healthAuth(Year: toY, Month: toM, Date: toD)
        
        
        
        stepsLabel.text = "\(UserDefaults.standard.value(forKey: "steps")!) 걸음"

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
        
       // profileImageView.frame = CGRect(x: 20, y: 200, width: 260, height: 200)
        nickLabel.frame = CGRect(x: 100, y: profileImageView.frame.origin.y+200, width: 100, height: 50)
        
        stepsLabel.frame = CGRect(x: 100, y: nickLabel.frame.origin.y+60, width: 100, height: 50)
        
        dogAnimation.frame = CGRect(x: 0, y: nickLabel.frame.origin.y + 70, width: view.frame.size.width, height: view.frame.size.width)
        
        
    }
    
    
    
    

    

}


