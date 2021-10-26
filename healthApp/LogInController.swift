//
//  LogInController.swift
//  healthApp
//
//  Created by hong on 2021/10/25.
//

import UIKit
import Firebase

class LogInController: UIViewController {
    
    private let backButton: UIButton = {
        let backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
        
        return backButton
    }()
    
    private let Title: UILabel = {
        let Title = UILabel()
        Title.text = "로그인"
        Title.textAlignment = .center
        Title.font = .systemFont(ofSize: 40, weight: .bold)
        
        return Title
        
    }()
    
    private let IdField: UITextField = {
        let IdField = UITextField()
        IdField.placeholder = "Email Address"
        
        return IdField
    }()
    
    private let passwordField: UITextField = {
        let passwordField = UITextField()
        passwordField.placeholder = "password"
        passwordField.isSecureTextEntry = true
        
        return passwordField
    }()
    
    private let LogInButton: UIButton = {
        let LogInButton = UIButton()
        LogInButton.setTitle("Log In", for: .normal)
        LogInButton.setTitleColor(.black, for: .normal)
        return LogInButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.addSubview(backButton)
        view.addSubview(Title)
        view.addSubview(IdField)
        view.addSubview(passwordField)
        view.addSubview(LogInButton)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        LogInButton.addTarget(self, action: #selector(LogInButtonTapped), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    
    @objc private func backButtonTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeView")
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .coverVertical
        present(vc!, animated: true, completion: nil)
    }
    
    
    @objc private func LogInButtonTapped(){
        guard let Id = IdField.text, !Id.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            return
        }
        
        Firebase.Auth.auth().signIn(withEmail: Id, password: password) { [weak self] result, error in
            
            guard let strongSelf = self else {

                return
            }
            
            guard error == nil else {
                
                let LogInFailed = UIAlertController(title: "로그인이 실패했습니다", message: "아이디나 비밀번호를 다시 확인해 주세요", preferredStyle: .alert)
                LogInFailed.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in
                    
                }))
                
                strongSelf.present(LogInFailed, animated: true)
                return
            }
            
            //현재 날짜 넣어주기 
            let c_date = DateFormatter()
            c_date.dateFormat = "yyyy-MM-dd"
            let c_date_string = c_date.string(from: Date())
            cur_date = c_date_string
            today = c_date_string
            
            let LogInSuccessed = UIAlertController(title: " " , message: Id.split(separator: "@")[0]+"님 환영합니다!", preferredStyle: .alert)
            LogInSuccessed.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                let vc = strongSelf.storyboard?.instantiateViewController(withIdentifier: "HomeView")
                vc?.modalPresentationStyle = .fullScreen
                vc?.modalTransitionStyle = .coverVertical
                strongSelf.present(vc!, animated: true, completion: nil)
            }))
            
            strongSelf.present(LogInSuccessed, animated: true)
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        backButton.frame = CGRect(x: 0,
                                  y: 35,
                                  width: view.frame.size.width-300,
                                  height: 20)
        
        Title.frame = CGRect(x: 50,
                             y: 250,
                             width: view.frame.size.width-100,
                             height: 90)
        
        IdField.frame = CGRect(x: 50,
                               y: Title.frame.origin.y+100,
                               width: view.frame.size.width-100,
                               height: 50)
        
        passwordField.frame = CGRect(x: 50,
                                     y: IdField.frame.origin.y+30,
                                     width: view.frame.size.width-100,
                                     height: 50)
        
        LogInButton.frame = CGRect(x: 50,
                                   y: passwordField.frame.origin.y+50,
                                   width: view.frame.size.width-100,
                                   height: 60)
        
    }
    

}
