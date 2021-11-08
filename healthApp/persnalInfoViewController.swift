//
//  persnalInfoViewController.swift
//  healthApp
//
//  Created by hong on 2021/10/28.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage



class persnalInfoViewController: UIViewController {
    
    var notExist = false
    
    private let db = Database.database().reference()
    
    private let storage = Storage.storage().reference()
    
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
    
    private let imageView = UIImageView()
    
    private let pickImageButton: UIButton = {
        let pickImageButton = UIButton()
        pickImageButton.setTitle("사진 변경", for: .normal)
        pickImageButton.setTitleColor(.black, for: .normal)
        pickImageButton.backgroundColor = .systemBlue
        return pickImageButton
    }()
    
    private let clearImageButton: UIButton = {
        let clearImageButton = UIButton()
        clearImageButton.setTitle("초기화", for: .normal)
        clearImageButton.setTitleColor(.black, for: .normal)
        clearImageButton.backgroundColor = .orange
        return clearImageButton
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
        nickTextField.borderStyle = .roundedRect
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
        ageTextField.borderStyle = .roundedRect
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
        heightTextField.borderStyle = .roundedRect
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
        weightTextField.borderStyle = .roundedRect
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

        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        view.addSubview(pickImageButton)
        view.addSubview(clearImageButton)
        view.addSubview(nickLabel)
        view.addSubview(nickTextField)
        view.addSubview(ageLabel)
        view.addSubview(ageTextField)
        view.addSubview(heightLabel)
        view.addSubview(heightTextField)
        view.addSubview(weightLabel)
        view.addSubview(weightTextField)
        view.addSubview(recordButton)
        
        
        
        
        moveViewButton.delegate = self
        view.addSubview(moveViewButton)
        
        // 이미지 불러오기
        
        
        
        
        
        
        nickTextField.text = nick
        ageTextField.text = "\(age)"
        heightTextField.text = "\(height)"
        weightTextField.text = "\(weight)"
        imageView.contentMode = .scaleToFill
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        pickImageButton.addTarget(self, action: #selector(pickImageButtonTapped), for: .touchUpInside)
        clearImageButton.addTarget(self, action: #selector(clearImageButtonTapped), for: .touchUpInside)
        
        
        storage.child("\(p_id)/images/profileImage\(p_id).png").downloadURL { url, error in
            guard let url = url, error == nil else {
                
                guard let image = defaultPersonImage else {
                    return
                }
                
                guard let data = image.pngData() else {
                    return
                }
                
                self.storage.child("\(p_id)/images/profileImage\(p_id).png").putData(data)
                self.imageView.image = image
                

                return
            }
            
            
            let urls = URL(string: url.absoluteString)!
            
            let task = URLSession.shared.dataTask(with: urls) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                let image = UIImage(data: data)
                
                DispatchQueue.main.sync {
                    self.imageView.image = image
                }
            }
            
            task.resume()
            

        }
        /*
        if notExist {
            self.imageView.image = defaultPersonImage
        } else {
            guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
                  let url = URL(string: urlString) else {
                return
            }
       
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                let image = UIImage(data: data)
                
                DispatchQueue.main.sync {
                    self.imageView.image = image
                }
            }
            
            task.resume()
            
        }
        
       */
        // Do any additional setup after loading the view.
    }
    
    
    // 이미지 피커 컨트롤러 통해서 이미지 선택
    @objc private func pickImageButtonTapped () {
        let pick = UIImagePickerController()
        pick.allowsEditing = true
        pick.delegate = self
        pick.sourceType = .photoLibrary
        self.present(pick, animated: true, completion: nil)
    }
    
    @objc private func clearImageButtonTapped() {
        
        guard let image = defaultPersonImage else {
            return
        }
        
        guard let data = image.pngData() else {
            return
        }
        
        self.storage.child("\(p_id)/images/profileImage\(p_id).png").putData(data)
        self.imageView.image = image
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
        
        if a_value.isEmpty {
            age = 0
            db.child(p_id).child("PersonalInfo").child("Age").setValue(age)
            
        } else if Int(a_value) == nil {
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
        
        if h_value.isEmpty {
            height = 0.0
            db.child(p_id).child("PersonalInfo").child("Height").setValue(height)
            
        } else if Double(h_value) == nil {
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
        
        if w_value.isEmpty {
            weight = 0.0
            db.child(p_id).child("PersonalInfo").child("Weight").setValue(weight)
            
        } else if Double(w_value) == nil {
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
        titleLabel.frame = CGRect(x: 100, y: 100, width: view.frame.size.width-200, height: 50)
        
        imageView.frame = CGRect(x: 50, y: titleLabel.frame.origin.y + 50, width: view.frame.size.width-100, height: 270)
        pickImageButton.frame = CGRect(x: 80, y: imageView.frame.origin.y + 300, width: 80, height: 50)
        clearImageButton.frame = CGRect(x:240, y: imageView.frame.origin.y + 300, width: 80, height: 50 )
        nickLabel.frame = CGRect(x: 30, y: clearImageButton.frame.origin.y+100, width: 50, height: 50)
        nickTextField.frame = CGRect(x: nickLabel.frame.origin.x+100, y: clearImageButton.frame.origin.y+100, width: 200, height: 40)
        ageLabel.frame = CGRect(x: 30, y: nickLabel.frame.origin.y+50, width: 50, height: 50)
        ageTextField.frame = CGRect(x: nickLabel.frame.origin.x+100, y: nickLabel.frame.origin.y+50, width: 200, height: 40)
        heightLabel.frame = CGRect(x: 30, y: ageLabel.frame.origin.y+50, width: 50, height: 50)
        heightTextField.frame = CGRect(x: nickLabel.frame.origin.x+100, y: ageLabel.frame.origin.y+50, width: 200, height: 40)
        weightLabel.frame = CGRect(x: 30, y: heightLabel.frame.origin.y+50, width: 50, height: 50)
        weightTextField.frame = CGRect(x: nickLabel.frame.origin.x+100, y: heightLabel.frame.origin.y+50, width: 200, height: 40)
        
        recordButton.frame = CGRect(x: view.frame.maxX/2-60, y: weightTextField.frame.origin.y+80, width: 100, height: 50)
        
    }
    


}


extension persnalInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            
            return
        }
        
        guard let data = image.pngData() else {
            return
        }
        
        storage.child("\(p_id)/images/profileImage\(p_id).png").putData(data, metadata: nil) { _, error in
            guard error == nil else {
                return
            }
            
            self.storage.child("\(p_id)/images/profileImage\(p_id).png").downloadURL { url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlStirng = url.absoluteString
                
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.imageView.image = image
                }
                
                UserDefaults.standard.setValue(urlStirng, forKey: "url")  // 개인 저장소에 저장
            }
        }
    }
}
