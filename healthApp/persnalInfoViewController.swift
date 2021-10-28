//
//  persnalInfoViewController.swift
//  healthApp
//
//  Created by hong on 2021/10/28.
//

import UIKit
import FirebaseDatabase



class persnalInfoViewController: UIViewController {
    
    private let db = Database.database().reference()
    
    private let backButton: UIButton = {
        let backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
        
        return backButton
    }()
    
    private let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "회원 정보"
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    private let nickLabel : UILabel = {
        let nickLabel = UILabel()
        nickLabel.textAlignment = .right
        nickLabel.text = "별명"
        nickLabel.textColor = .black
        return nickLabel
    }()
    
    private let nickTextField : UITextField = {
        let nickTextField = UITextField()
        nickTextField.textAlignment = .center
        return nickTextField
    }()
    
    private let ageLabel : UILabel = {
        let ageLabel = UILabel()
        ageLabel.textAlignment = .right
        ageLabel.text = "나이"
        ageLabel.textColor = .black
        return ageLabel
    }()
    
    private let ageTextField : UITextField = {
        let ageTextField = UITextField()
        ageTextField.textAlignment = .center
        return ageTextField
    }()
    
    private let heightLabel : UILabel = {
        let heightLabel = UILabel()
        heightLabel.textAlignment = .right
        heightLabel.text = "키"
        heightLabel.textColor = .black
        return heightLabel
    }()
    
    private let heightTextField : UITextField = {
        let heightTextField = UITextField()
        heightTextField.textAlignment = .center
        heightTextField.tintColor = .black
        return heightTextField
    }()
    
    private let weightLabel : UILabel = {
        let weighLabel = UILabel()
        weighLabel.textAlignment = .right
        weighLabel.text = "몸무게"
        weighLabel.textColor = .black
        return weighLabel
    }()
    
    private let weightTextField : UITextField = {
        let weightTextField = UITextField()
        weightTextField.textAlignment = .center
        return weightTextField
    }()
    
    private let recordButton : UIButton = {
        let recordButton = UIButton()
        recordButton.setTitle("저장", for: .normal)
        recordButton.backgroundColor = .systemBlue
        return recordButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(nickLabel)
        view.addSubview(nickTextField)
        view.addSubview(ageLabel)
        view.addSubview(ageTextField)
        view.addSubview(heightLabel)
        view.addSubview(heightTextField)
        view.addSubview(weightLabel)
        view.addSubview(weightTextField)
        view.addSubview(recordButton)
        
        
        nickTextField.text = nick
        ageTextField.text = "\(age)"
        heightTextField.text = "\(height)"
        weightTextField.text = "\(weight)"
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    
    @objc private func backButtonTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeView")
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .coverVertical
        self.present(vc!, animated: true, completion: nil)
    }
    
    @objc private func recordButtonTapped() {
        
        guard let n_value = nickTextField.text  else {
            return
        }
        nick = n_value

        db.child(p_id).child("PersonalInfo").child("Nick").setValue(nick)
        
        guard let a_value =  ageTextField.text else {
  
            return
        }
        
        
        if Int(a_value) == nil {
            let ageAlert = UIAlertController(title: "", message: "나이를 제대로 입력해주세요", preferredStyle: .alert)
            ageAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in
                    
            }))
            self.present(ageAlert, animated: true, completion: nil)
        } else {
            age = Int(a_value)!
            db.child(p_id).child("PersonalInfo").child("Age").setValue(age)
            
        }
        
        
        guard let h_value = heightTextField.text else {
            return
        }
        
        if Double(h_value) == nil {
            let heightAlert = UIAlertController(title: "", message: "키를 제대로 입력해주세요", preferredStyle: .alert)
            heightAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in
                    
            }))
            self.present(heightAlert, animated: true, completion: nil)
        } else {
            height = Double(h_value)!
            db.child(p_id).child("PersonalInfo").child("Height").setValue(height)
            
        }
        
        
        guard let w_value = weightTextField.text else {
            return
        }
        
        if Double(w_value) == nil {
            let weightAlert = UIAlertController(title: "", message: "몸무게를 제대로 입력해주세요", preferredStyle: .alert)
            weightAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in
                    
            }))
            self.present(weightAlert, animated: true, completion: nil)
        } else {
            weight = Double(w_value)!
            db.child(p_id).child("PersonalInfo").child("Weight").setValue(weight)
            
        }
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        backButton.frame = CGRect(x: -10,
                                  y: 35,
                                  width: view.frame.size.width-300,
                                  height: 20)
        titleLabel.frame = CGRect(x: 100, y: 160, width: view.frame.size.width-200, height: 50)
        nickLabel.frame = CGRect(x: 30, y: titleLabel.frame.origin.y+100, width: 50, height: 50)
        nickTextField.frame = CGRect(x: nickLabel.frame.origin.x+70, y: titleLabel.frame.origin.y+75, width: 200, height: 100)
        ageLabel.frame = CGRect(x: 30, y: nickLabel.frame.origin.y+50, width: 50, height: 50)
        ageTextField.frame = CGRect(x: nickLabel.frame.origin.x+70, y: nickTextField.frame.origin.y+50, width: 200, height: 100)
        heightLabel.frame = CGRect(x: 30, y: ageLabel.frame.origin.y+50, width: 50, height: 50)
        heightTextField.frame = CGRect(x: nickLabel.frame.origin.x+70, y: ageTextField.frame.origin.y+50, width: 200, height: 100)
        weightLabel.frame = CGRect(x: 30, y: heightLabel.frame.origin.y+50, width: 50, height: 50)
        weightTextField.frame = CGRect(x: nickLabel.frame.origin.x+70, y: heightTextField.frame.origin.y+50, width: 200, height: 100)
        
        recordButton.frame = CGRect(x: view.frame.maxX/2-40, y: weightTextField.frame.origin.y+200, width: 100, height: 50)
        
    }
    


}
