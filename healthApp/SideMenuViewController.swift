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
import Instructions


class SideMenuViewController: UIViewController {
    
    
    private var coachMarksController = CoachMarksController()

    private let instructionButton: UIButton = {
            
        let instructionButton = UIButton()
        instructionButton.setImage(UIImage(named: "what"), for: .normal)
        instructionButton.frame = CGRect(x: 20, y: 60, width: 30, height: 30)
            
        return instructionButton
            
    }()
        
    private var coachDatas = [instructionDatas]()

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
        
        
        storage.child("\(p_id)/images/profileImage\(p_id).png").downloadURL { [self] url, error in
            guard let url = url, error == nil else {
                
                profileImageView.image = defaultPersonImage!
                
                guard let image = defaultPersonImage else {
                    return
                }
                
                guard let data = image.pngData() else {
                    return
                }
                
                storage.child("\(p_id)/images/profileImage\(p_id).png").putData(data)
                
                
                return
            }
            
            
            let urls = URL(string: url.absoluteString)!
            
            
            // 킹피셔 사용해서 이미지 빨리 불러오기
            profileImageView.kf.setImage(with: urls)
            
            /*
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
            */
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
        
        super.viewWillAppear(animated)
        
        view.addSubview(profileImageView)


        
     //   profileImageView.setImage(profileImage, for: .normal)
        nickLabel.text = nick
        
   //     profileImageView.addTarget(self, action: #selector(profileImageViewTapped), for: .touchUpInside)
        
        
        view.addSubview(dogAnimation)
        dogAnimation.play()
   
        
        healthAuth(Year: toY, Month: toM, Date: toD)
   
        stepsLabel.text = "\(UserDefaults.standard.value(forKey: "steps")!) 걸음"
        
        
        // 도움말
        view.addSubview(instructionButton)
                
        // 도움말 데이터 넣어주기
        fillCoachDatas()
        coachMarksController.dataSource = self
        //배경 눌러도 자동으로 넘어가게
        coachMarksController.overlay.isUserInteractionEnabled = true
                
        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("skip", for: .normal)
        coachMarksController.skipView = skipView

        instructionButton.addTarget(self, action: #selector(instructionButtonTapped), for: .touchUpInside)

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
    

        private func fillCoachDatas() {
            
            let item1 = instructionDatas(View: profileImageView, bodyText: "프로필 사진을 보여줍니다", nextText: "다음")
            coachDatas.append(item1)
            let item2 = instructionDatas(View: nickLabel, bodyText: "별명을 나타냅니다", nextText: "다음")
            coachDatas.append(item2)
            let item3 = instructionDatas(View: stepsLabel, bodyText: "걸음 걸이를 나타냅니다", nextText: "다음")
            coachDatas.append(item3)

        }
        
        @objc private func instructionButtonTapped() {
            
            coachMarksController.start(in: .window(over: self))
            
        }


    
    @objc private func profileImageViewTapped() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        profileImageView.frame = CGRect(x: 20, y: 200, width: 260, height: 200)
        nickLabel.frame = CGRect(x: 100, y: profileImageView.frame.origin.y+200, width: 100, height: 50)
        
        stepsLabel.frame = CGRect(x: 100, y: nickLabel.frame.origin.y+60, width: 100, height: 50)
        
        dogAnimation.frame = CGRect(x: 0, y: nickLabel.frame.origin.y + 70, width: view.frame.size.width, height: view.frame.size.width)
        
        
    }
    
    
    
    

    

}

extension SideMenuViewController: CoachMarksControllerDelegate, CoachMarksControllerDataSource {


    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
            return coachDatas.count
        }
        
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        return coachMarksController.helper.makeCoachMark(for: coachDatas[index].View)
    }
        
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
            
        let coachView = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation, hintText: coachDatas[index].bodyText, nextText: coachDatas[index].nextText)
            
        return (bodyView: coachView.bodyView, arrowView: coachView.arrowView)
            
    }

    
}


