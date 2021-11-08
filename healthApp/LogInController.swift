//
//  LogInController.swift
//  healthApp
//
//  Created by hong on 2021/10/25.
//

import UIKit
import Firebase
import FirebaseDatabase


class LogInController: UIViewController {
    
    private let db = Database.database().reference()
    let storage = Storage.storage().reference()
    
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
        IdField.placeholder = "ID"
        IdField.autocapitalizationType = .none
        return IdField
    }()
    
    private let passwordField: UITextField = {
        let passwordField = UITextField()
        passwordField.placeholder = "password"
        passwordField.isSecureTextEntry = true
        passwordField.autocapitalizationType = .none
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
        
        
        Firebase.Auth.auth().signIn(withEmail: Id+"@healthApp.com", password: password) { [weak self] result, error in
            
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
            
            logined = true
            
            //현재 날짜 넣어주기 
            let c_date = DateFormatter()
            c_date.dateFormat = "yyyy-MM-dd"
            let c_date_string = c_date.string(from: Date())
            cur_date = c_date_string
            today = c_date_string
            
            // 로그인 됬을 때 환영 인사주기 위해 email 정보 얻어오기
            guard let name = Firebase.Auth.auth().currentUser?.email else {
                
                print("정보 못 받음")
                return
            }
            p_id = String(name.split(separator: "@")[0])
            nick = p_id
            
            
            // 로그인 시 개인정보 가져오기
            self?.db.child(p_id).child("PersonalInfo").child("Age").observeSingleEvent(of: .value, with: { snapshot in
                if let value = snapshot.value as? Int {
                    age = value
                } else {
                    age = 0
                }

                
            })
            
            
            self?.storage.child("\(p_id)/images/profileImage\(p_id).png").downloadURL { url, error in
                guard let url = url, error == nil else {
                    
                    profileImage = defaultPersonImage!
                    
                    guard let image = defaultPersonImage else {
                        return
                    }
                    
                    guard let data = image.pngData() else {
                        return
                    }
                    
                    self?.storage.child("\(p_id)/images/profileImage\(p_id).png").putData(data)
                    
                    
                    return
                }
                
                
                let urls = URL(string: url.absoluteString)!
                
                
                let task = URLSession.shared.dataTask(with: urls) { data, _, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    
                    let image = UIImage(data: data)
                    
                    
                    
                    DispatchQueue.main.sync {
                        
                        profileImage = image!
                    }
                }
            
            
                
                task.resume()
            }
            
            self?.db.child(p_id).child("PersonalInfo").child("Weight").observeSingleEvent(of: .value, with: { snapshot in
                if let value = snapshot.value as? Double {
                    weight = value
                } else {
                    weight = 0
                }
            })
            
            self?.db.child(p_id).child("PersonalInfo").child("Height").observeSingleEvent(of: .value, with: { snapshot in
                if let value = snapshot.value as? Double {
                    height = value
                } else {
                    height = 0
                }
            })
            
            
            // 개인 정보 불러오기
            self?.db.child(p_id).child("PersonalInfo").child("Nick").observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? String  else {
                    
                    // 닉네임 없는 경우
                    let LogInSuccessed2 = UIAlertController(title: " " , message: p_id+"님 환영합니다!", preferredStyle: .alert)
                    LogInSuccessed2.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                        let vc = strongSelf.storyboard?.instantiateViewController(withIdentifier: "HomeView")
                        vc?.modalPresentationStyle = .fullScreen
                        vc?.modalTransitionStyle = .coverVertical
                        strongSelf.present(vc!, animated: true, completion: nil)
                    }))
                    
                    strongSelf.present(LogInSuccessed2, animated: true)
                    
                    return
                    
                }
                
                nick = value
                
       
                
                    // 닉네임 있을 땐 닉네임으로 환영
                    let LogInSuccessed = UIAlertController(title: " " , message: nick+"님 환영합니다!", preferredStyle: .alert)
                    LogInSuccessed.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                        let vc = strongSelf.storyboard?.instantiateViewController(withIdentifier: "HomeView")
                        vc?.modalPresentationStyle = .fullScreen
                        vc?.modalTransitionStyle = .coverVertical
                        strongSelf.present(vc!, animated: true, completion: nil)

                        
                    }))
                    
                    strongSelf.present(LogInSuccessed, animated: true)
                
   
                
            }
            
            
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
