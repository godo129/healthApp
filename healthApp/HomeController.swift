//
//  HomeController.swift
//  healthApp
//
//  Created by hong on 2021/10/25.
//

import UIKit
import Firebase
import FirebaseDatabase
import CircleMenu
import SideMenu
import Lottie
import FSPagerView



class HomeController: UIViewController, UINavigationControllerDelegate {
    
    let storage = Storage.storage().reference()
    
    private let bannerView: FSPagerView = {
        var bannerView = FSPagerView()
        bannerView.transformer = FSPagerViewTransformer(type: .cubic)
        bannerView.isInfinite = true
        return bannerView
    }()
    
    private let bannerPageController: FSPageControl = {
        let bannerPageController = FSPageControl()
        bannerPageController.setFillColor(.white , for: .normal)
        bannerPageController.setFillColor(.black, for: .selected)
        bannerPageController.setStrokeColor(.black, for: .normal)
        bannerPageController.setStrokeColor(.black, for: .selected)
        
        return bannerPageController
    }()
    
    private let exerciseRecordView: AnimationView = {
        var exerciseRecordView = AnimationView()
        exerciseRecordView = .init(name: "exerciseViewAnimation")
        exerciseRecordView.loopMode = .loop
        exerciseRecordView.animationSpeed = 1.0
        return exerciseRecordView
    }()
    
    private let chartRecordView: AnimationView = {
        var chartRecordView = AnimationView()
        chartRecordView = .init(name: "chartAnimation")
        chartRecordView.loopMode = .loop
        chartRecordView.contentMode = .scaleAspectFit
        chartRecordView.animationSpeed = 1.0
        return chartRecordView
    }()
    
    let moveViewButton = CircleMenu(
      frame: CGRect(x: 380, y: 400, width: 50, height: 50),
      normalIcon:"bar",
      selectedIcon:"close",
      buttonsCount: 8,
      duration: 1,
      distance: 100)
    
    private let db = Database.database().reference()
    
    
    // 애니메이션 배경
    private var backgroundAnimation: AnimationView = {
        var backgroundAnimation = AnimationView()
        backgroundAnimation = .init(name: "snowFlake")
        backgroundAnimation.loopMode = .loop
        backgroundAnimation.animationSpeed = 0.6
        backgroundAnimation.contentMode = .scaleAspectFit
        backgroundAnimation.play()
        return backgroundAnimation
    }()
    
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
    
    private let chartViewButton: UIButton = {
        let chartViewButton = UIButton()
        chartViewButton.setImage(UIImage(named: "chart"), for: .normal)
        return chartViewButton
    }()
    
    
    private let questionButton : UIButton = {
        let questionButton = UIButton()
        questionButton.setImage(UIImage(named: "question"), for: .normal)
        return  questionButton
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //애니메이션
        view.addSubview(backgroundAnimation)
        view.addSubview(exerciseRecordView)
        view.addSubview(chartRecordView)
        
        // 그외
        view.addSubview(titleLabel)
        view.addSubview(userLabel)
        view.addSubview(logInButton)
        view.addSubview(SignUpButton)
        view.addSubview(logOutButton)
        view.addSubview(personalInfoButton)
        
        view.addSubview(recordViewButton)
        view.addSubview(chartViewButton)
        view.addSubview(questionButton)
        
        
        
        
        // 원형 메뉴
        moveViewButton.delegate = self
        view.addSubview(moveViewButton)
        
        // 애니메이션 백그라운드 에서도 돌아가게 
        exerciseRecordView.backgroundBehavior = .pauseAndRestore
        chartRecordView.backgroundBehavior = .pauseAndRestore
        
        
        todayString()
        
      
        //사이드 메뉴 옵션 
        sideBar.leftSide = true
        SideMenuManager.default.addPanGestureToPresent(toView: view.self)
        SideMenuManager.default.leftMenuNavigationController = sideBar
        sideBar.isNavigationBarHidden = true
        sideBar.menuWidth = 300
        
        
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
        chartViewButton.addTarget(self, action: #selector(chartViewButtonTapped), for: .touchUpInside)
        questionButton.addTarget(self, action: #selector(questionButtonTapped), for: .touchUpInside)
        
        
        // 차트뷰에 제스처 추가
        
        let gotoExerciseView = UITapGestureRecognizer(target: self, action: #selector(recordViewButtonTapped))
        exerciseRecordView.addGestureRecognizer(gotoExerciseView)
        
        let gotoChartView = UITapGestureRecognizer(target: self, action: #selector(chartViewButtonTapped))
        chartRecordView.addGestureRecognizer(gotoChartView)
        
       
        // 로그인 됬을 때 환영 인사주기 위해 email 정보 얻어오기
        guard let name = Firebase.Auth.auth().currentUser?.email else {
            return
        }
        p_id = String(name.split(separator: "@")[0])
        
        
        
        // 닉네임 있을 때와 없을 때 별로 처리 ,, 
        
        
        db.child(p_id).child("PersonalInfo").child("Nick").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? String else {
                return
            }
            nick = value
        }
    
        if nick == "" {
            userLabel.text = p_id + "님 환영합니다!!!"
            
        } else {
            userLabel.text = nick + "님 환영합니다!!!"
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
       
        // 배너
        
        view.addSubview(bannerView)
        view.addSubview(bannerPageController)

        bannerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "bannerCell")
        bannerView.dataSource = self
        bannerView.delegate = self
        bannerPageController.numberOfPages = 5
        
        if logined {
            moveViewButton.isHidden = false
            personalInfoButton.isHidden = false
            exerciseRecordView.play()
            chartRecordView.play()
        } else {
            moveViewButton.isHidden = true
            personalInfoButton.isHidden = true
      
        }


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
            moveViewButton.isHidden = true 
            
            // 로그 아웃 하면 연결 끊어진 것 표시, 데이터 초기화
            logined = false
            cur_date = ""
            p_id = ""
            nick = ""
            age = 0
            height = 0.0
            weight = 0.0
            profileImage = defaultPersonImage

            
            exerciseRecordView.stop()
            chartRecordView.stop()
            
            // 저장 공간 초기화 
            let value: [String] = []
            UserDefaults.standard.setValue(value, forKey: "exerciseHistory")
            
            let emptyStorage = making()
            UserDefaults.standard.setValue(emptyStorage, forKey: "exerciseTypesDataStorage")


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
    
    @objc private func chartViewButtonTapped(){
        if !logined {
            let alert = UIAlertController(title: "", message: "로그인해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in
                
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChartView")
            vc?.modalPresentationStyle = .fullScreen
            vc?.modalTransitionStyle = .coverVertical
            self.present(vc!, animated: true, completion: nil)
        }
    }
    
    
    @objc private func questionButtonTapped() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuestionView")
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .coverVertical
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        backgroundAnimation.frame = view.bounds
        titleLabel.frame = CGRect(x: 50,
                                  y: 50,
                                  width: view.frame.size.width-100,
                                  height: 100)
        
        bannerView.frame = CGRect(x: 60, y: titleLabel.frame.origin.y + 120, width: 300, height: 130)
        
        bannerPageController.frame = CGRect(x: bannerView.frame.origin.x-20, y: bannerView.frame.origin.y+70 , width: 100, height: 100)
        
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
        
        personalInfoButton.frame = CGRect(x: view.frame.size.width-100,
                                          y: titleLabel.frame.origin.y+50,
                                          width: 100,
                                          height: 50)
        /*
        recordViewButton.frame = CGRect(x: 50,
                                  y: titleLabel.frame.origin.y+200,
                                  width: view.frame.size.width-100,
                                  height: 200)
 */
        
        exerciseRecordView.frame = CGRect(x: 50,
                                          y: bannerView.frame.origin.y+140,
                                          width: view.frame.size.width-100,
                                          height: 200)
        
        chartRecordView.frame = CGRect(x: 80,
                                  y: exerciseRecordView.frame.origin.y+200,
                                  width: view.frame.size.width-150,
                                  height: 200)
        
       // chartViewButton.frame = CGRect(x: 80,
        //                          y: recordViewButton.frame.origin.y+300,
        //                          width: view.frame.size.width-150,
        //                          height: 200)
        
        questionButton.frame = CGRect(x: view.frame.maxX-70,
                                      y: view.frame.maxY-70,
                                      width: 50,
                                      height: 50)
    }
    

}

extension HomeController: FSPagerViewDelegate, FSPagerViewDataSource {

    func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        return 5
        
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "bannerCell", at: index)
        
        cell.imageView?.kf.setImage(with: URL(string: viewDatas[index]))
        
        bannerPageController.currentPage = index
        return cell
    }
    
 
    
}
