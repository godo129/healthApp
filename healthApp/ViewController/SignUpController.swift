//
//  SignUpController.swift
//  healthApp
//
//  Created by hong on 2021/10/25.
//

import UIKit
import Firebase
import TextFieldEffects
var cols = UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1)

class SignUpController: UIViewController {
    
    
    
    private let backButton: UIButton = {
        let backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
        
        return backButton
    }()
    
    private let Title: UILabel = {
        let Label = UILabel()
        Label.text = "회원가입"
        Label.font = .systemFont(ofSize: 40, weight: .bold)
        Label.textAlignment = .center
        return Label
    }()
    
    private let IdField: YoshikoTextField = {
        let IdField = YoshikoTextField()
        IdField.placeholder = "ID"
        IdField.placeholderColor = .darkGray
        IdField.inactiveBorderColor = cols
        IdField.activeBorderColor = .orange
        IdField.autocapitalizationType = .none
        return IdField
    }()
    
    private let passwordField: YoshikoTextField = {
        let passwordField = YoshikoTextField()
        passwordField.placeholder = "pasword"
        passwordField.isSecureTextEntry = true
        passwordField.placeholderColor = .darkGray
        passwordField.inactiveBorderColor = cols
        passwordField.activeBorderColor = .orange
        passwordField.autocapitalizationType = .none
        return passwordField
    }()
    
    private let checkPasswordField: YoshikoTextField = {
        let checkPasswordField = YoshikoTextField()
        checkPasswordField.placeholder = "check pasword"
        checkPasswordField.isSecureTextEntry = true
        checkPasswordField.placeholderColor = .darkGray
        checkPasswordField.inactiveBorderColor = cols
        checkPasswordField.activeBorderColor = .orange
        checkPasswordField.autocapitalizationType = .none
        return checkPasswordField
    }()
    
    
    private let signUpButton: UIButton = {
        let signUpButton = UIButton()
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.borderWidth = 2
        signUpButton.layer.borderColor = UIColor.gray.cgColor
        return signUpButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backButton)
        view.addSubview(Title)
        view.addSubview(IdField)
        view.addSubview(passwordField)
        view.addSubview(checkPasswordField)
        view.addSubview(signUpButton)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    
    @objc private func backButtonTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeView")
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .coverVertical
        self.present(vc!, animated: true, completion: nil)
    }
    
    // 회원가입 버튼
    @objc private func signUpButtonTapped() {
        
        guard let id = IdField.text, !id.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let checkPassword = checkPasswordField.text, !checkPassword.isEmpty else {
        
            return
        }
        
        // 비밀번호 불일치, 일치에 따라 나뉨 
        if password != checkPassword {
            let notEqualPasswords = UIAlertController(title: "비밀번호 불일치", message: "비밀번호를 확인해 주세요", preferredStyle: .alert)
            notEqualPasswords.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in
                
            }))
            self.present(notEqualPasswords, animated: true, completion: nil)
            
            return
        } else if password.count <= 5 {
            let underSixPasswords = UIAlertController(title: "", message: "비밀번호를 6개 이상 입력해주세요", preferredStyle: .alert)
            underSixPasswords.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in
                
            }))
            self.present(underSixPasswords, animated: true, completion: nil)
            
            return
        } else  {
            
            Firebase.Auth.auth().createUser(withEmail: id+"@healthApp.com", password: password) { [weak self] result, error in
                
                guard let strongSelf = self else {
                    return
                }
                
                // 이메일 이미 존재하는 경우
                guard error == nil else {
           
                    let existedEmail = UIAlertController(title: "", message: "이미 존재하는 아이디입니다", preferredStyle: .alert)
                    existedEmail.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in
                        
                    }))
                    strongSelf.present(existedEmail, animated: true, completion: nil)
                    
                    return
                }
                
                // 패스워드 일치하지 않는 경우
                
                
                
                
                // 회원 가입 완료 홈 뷰로
                let finished = UIAlertController(title: "회원가입 완료", message: "", preferredStyle: .alert)
                finished.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                    
                    // 홈화면에서 자동으로 로그인 된 상태가 되므로 풀어주기
                    do {
                        try Firebase.Auth.auth().signOut()
            
                    } catch {
                            
                    }
                    
                    // 홈으로 뷰 전환
                    let vc = strongSelf.storyboard?.instantiateViewController(withIdentifier: "HomeView")
                    vc?.modalPresentationStyle = .fullScreen
                    vc?.modalTransitionStyle = .crossDissolve
                    strongSelf.present(vc!, animated: true, completion: nil)
     
                    
                }))
                
                strongSelf.present(finished, animated: true)

                print("You have signed in")
                        
            }
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(15)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.size.equalTo(CGSize(width: 50, height: 30))
        }
        
        Title.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view).offset(-140)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSize(width: 200, height: 50))
        }
        
//        Title.frame = CGRect(x: 50,
//                             y: 250,
//                             width: view.frame.size.width-100,
//                             height: 80)
        
        IdField.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(50)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-50)
            make.top.equalTo(Title).offset(80)
            make.height.equalTo(50)
            
        }
        
//        IdField.frame = CGRect(x: 50,
//                               y: Title.frame.origin.y+100,
//                               width: view.frame.size.width-100,
//                               height: 50)
        
        passwordField.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(50)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-50)
            make.top.equalTo(IdField).offset(50)
            make.height.equalTo(50)
            
        }
        
//        passwordField.frame = CGRect(x: 50,
//                                     y: IdField.frame.origin.y+50,
//                                     width: view.frame.size.width-100,
//                                     height: 50)
        
        checkPasswordField.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(50)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-50)
            make.top.equalTo(passwordField).offset(50)
            make.height.equalTo(50)
            
        }
        
        
//        checkPasswordField.frame = CGRect(x: 50,
//                                          y: passwordField.frame.origin.y+50,
//                                          width: view.frame.size.width-100,
//                                          height: 50)
        
        signUpButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(50)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-50)
            make.top.equalTo(checkPasswordField).offset(80)
            make.height.equalTo(30)
            
        }
        
        
//        signUpButton.frame = CGRect(x: 50,
//                                    y: checkPasswordField.frame.origin.y+70,
//                                    width: view.frame.size.width-100,
//                                    height: 30)
    }


}
