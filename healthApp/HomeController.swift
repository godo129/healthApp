//
//  HomeController.swift
//  healthApp
//
//  Created by hong on 2021/10/25.
//

import UIKit
import Firebase
import FirebaseDatabase


class HomeController: UIViewController {
    
    var logined = false
    
    private let db = Database.database().reference()
    
    private let titleLabel: UILabel = {
        let titleLablel = UILabel()
        titleLablel.textAlignment = .center
        titleLablel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLablel.text = "운동"
        return titleLablel
        
    } ()
    
    private let userLabel: UILabel = {
        let userLabel = UILabel()
        userLabel.textAlignment = .left
        userLabel.font = .systemFont(ofSize: 20, weight: .medium)
        
        return userLabel
    } ()
    
    private let logInButton: UIButton = {
        let logInButton = UIButton()
        logInButton.setTitle("로그인", for: .normal)
        logInButton.setTitleColor(.black, for: .normal)
        
        return logInButton
    } ()
    
    private let SignUpButton: UIButton = {
        let SignUpButton = UIButton()
        SignUpButton.setTitle("회원가입", for: .normal)
        SignUpButton.setTitleColor(.black, for: .normal)
        
        return SignUpButton
    }()
    
    private let logOutButton: UIButton = {
        let logOutButton = UIButton()
        logOutButton.setTitle("로그아웃", for: .normal)
        logOutButton.setTitleColor(.black, for: .normal)
        
        return logOutButton
    }()
    
    private let personalInfoButton : UIButton = {
        let personalInfoButton = UIButton()
        personalInfoButton.setTitle("개인정보", for: .normal)
        personalInfoButton.setTitleColor(.black, for: .normal)
        return personalInfoButton
    }()
    
    private let recordViewButton: UIButton = {
        let recordViewButton = UIButton()
        recordViewButton.setImage(UIImage(named: "record"), for: .normal)
        return recordViewButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(titleLabel)
        view.addSubview(userLabel)
        view.addSubview(logInButton)
        view.addSubview(SignUpButton)
        view.addSubview(logOutButton)
        view.addSubview(personalInfoButton)
        
        view.addSubview(recordViewButton)
        
     
        
        if Firebase.Auth.auth().currentUser != nil {
            logined = true
            logInButton.isHidden = true
            SignUpButton.isHidden = true
            logOutButton.isHidden = false
            personalInfoButton.isHidden = false
            userLabel.isHidden = false
            
            
            
        } else {
            logined = false
            logOutButton.isHidden = true
            personalInfoButton.isHidden = true
            userLabel.isHidden = true
            logInButton.isHidden = false
            SignUpButton.isHidden = false
        }
        
        logInButton.addTarget(self, action: #selector(LogInButtonTapped), for: .touchUpInside)
        SignUpButton.addTarget(self, action: #selector(SignUpButtonTapped), for: .touchUpInside)
        logOutButton.addTarget(self, action: #selector(LogOutButtonTapped), for: .touchUpInside)
        personalInfoButton.addTarget(self, action: #selector(personalInfoButtonTapped), for: .touchUpInside)
        recordViewButton.addTarget(self, action: #selector(recordViewButtonTapped), for: .touchUpInside)
        
        
       
        // 로그인 됬을 때 환영 인사주기 위해 email 정보 얻어오기
        guard let name = Firebase.Auth.auth().currentUser?.email else {
            return
        }
        p_id = String(name.split(separator: "@")[0])
        
        
        
        // 닉네임 있을 때와 없을 때 별로 처리 ,, 
        
        
        db.child(p_id).child("PersonalInfo").child("Nick").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? String else {
                self.userLabel.text = p_id + "님 환영합니다!!!"
                return
            }
            nick = value
            self.userLabel.text = value + "님 환영합니다!!!"
        }
        
        // 계속 정보 업데이트 
        db.child(p_id).child("PersonalInfo").child("Age").observeSingleEvent(of: .value, with: { snapshot in
            if let value = snapshot.value as? Int {
                age = value
            } else {
                age = 0
            }
            
        })
        
        db.child(p_id).child("PersonalInfo").child("Weight").observeSingleEvent(of: .value, with: { snapshot in
            if let value = snapshot.value as? Double {
                weight = value
            } else {
                weight = 0
            }
        })
        
        db.child(p_id).child("PersonalInfo").child("Height").observeSingleEvent(of: .value, with: { snapshot in
            if let value = snapshot.value as? Double {
                height = value
            } else {
                height = 0
            }
        })

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    
    // 화면 전환
    @objc private func LogInButtonTapped(){
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: "LogInView")
        vcName?.modalPresentationStyle = .fullScreen
        vcName?.modalTransitionStyle = .coverVertical
        present(vcName!, animated: true, completion: nil)
    }
    
    @objc private func SignUpButtonTapped() {
        
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: "SignUpView")
        vcName?.modalPresentationStyle = .fullScreen
        vcName?.modalTransitionStyle = .coverVertical
        self.present(vcName!, animated: true, completion: nil)
        
    }
    
    
    @objc private func LogOutButtonTapped(){
        do {
            try Firebase.Auth.auth().signOut()
            logOutButton.isHidden = true
            userLabel.isHidden = true
            logInButton.isHidden = false
            SignUpButton.isHidden = false
            personalInfoButton.isHidden = true
            
            // 로그 아웃 하면 연결 끊어진 것 표시, 데이터 초기화
            logined = false
            cur_date = ""
            p_id = ""
            nick = ""
            age = 0
            height = 0.0
            weight = 0.0

        } catch {
            
        }
        
    }
    
    @objc private func personalInfoButtonTapped() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PersonalInfoView")
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .coverVertical
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    
    @objc private func recordViewButtonTapped(){
        
        if !logined {
            let alert = UIAlertController(title: "", message: "로그인해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in
                
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExerciseRecordView")
            vc?.modalPresentationStyle = .fullScreen
            vc?.modalTransitionStyle = .coverVertical
            self.present(vc!, animated: true, completion: nil)
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        titleLabel.frame = CGRect(x: 50,
                                  y: 50,
                                  width: view.frame.size.width-100,
                                  height: 100)
        
        userLabel.frame = CGRect(x: 20,
                                 y: titleLabel.frame.origin.y+80,
                                 width: view.frame.size.width,
                                 height: 40)
        
        logInButton.frame = CGRect(x: view.frame.size.width-100,
                                   y: titleLabel.frame.origin.y,
                                   width: 100,
                                   height: 50)
        
        SignUpButton.frame = CGRect(x: view.frame.size.width-100,
                                    y: titleLabel.frame.origin.y+50,
                                    width: 100,
                                    height: 50)
        logOutButton.frame = CGRect(x: view.frame.size.width-100,
                                    y: titleLabel.frame.origin.y,
                                    width: 100,
                                    height: 50)
        
        personalInfoButton.frame = CGRect(x: view.frame.size.width-100, y: titleLabel.frame.origin.y+50, width: 100, height: 50)
        recordViewButton.frame = CGRect(x: 50,
                                  y: titleLabel.frame.origin.y+200,
                                  width: view.frame.size.width-100,
                                  height: 200)
    }
    

}
