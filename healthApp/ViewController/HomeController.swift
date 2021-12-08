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
import Instructions



class HomeController: UIViewController, UINavigationControllerDelegate {
    
    
    let storage = Storage.storage().reference()
    
    private var coachMarksController = CoachMarksController()
    
    private let instructionButton: UIButton = {
        
        let instructionButton = UIButton()
        instructionButton.setImage(UIImage(named: "what"), for: .normal)
        
        return instructionButton
        
    }()
    
    private var coachDatas = [instructionDatas]()
    
    private let bannerView: FSPagerView = {
        var bannerView = FSPagerView()
        bannerView.transformer = FSPagerViewTransformer(type: .zoomOut)
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
    
    private let dogWalkView: AnimationView = {
        var dogWalkView = AnimationView()
        dogWalkView = .init(name: "dogWalk")
        dogWalkView.loopMode = .loop
        dogWalkView.animationSpeed = 1.1
        dogWalkView.play()
        dogWalkView.backgroundBehavior = .pauseAndRestore
        return dogWalkView
    }()
    
    let moveViewButton = CircleMenu(
      frame: CGRect(x: 380, y: 650, width: 50, height: 50),
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
        backgroundAnimation.backgroundBehavior = .pauseAndRestore
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
        //view.addSubview(exerciseRecordView)
        //view.addSubview(chartRecordView)
        view.addSubview(dogWalkView)
        
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
        
        instructionButton.addTarget(self, action: #selector(instructionButtonTapped), for: .touchUpInside)
        
        
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

        //view.addSubview(bannerPageController)

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
        
        
        // 도움말
        view.addSubview(instructionButton)
        
        
    
        // 원형 메뉴
        moveViewButton.delegate = self
        view.addSubview(moveViewButton)
        
        // 도움말 데이터 넣어주기
        fillCoachDatas()
        coachMarksController.dataSource = self
        //배경 눌러도 자동으로 넘어가게
        coachMarksController.overlay.isUserInteractionEnabled = true
        
        //스킵 버튼
        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("skip", for: .normal)
        coachMarksController.skipView = skipView
        
        
        


    }
    
    private func fillCoachDatas() {
        
        let item1 = instructionDatas(View: bannerView, bodyText: "클릭을 통해 운동 기록할 수 있습니다", nextText: "다음")
        coachDatas.append(item1)
        let item2 = instructionDatas(View: bannerView, bodyText: "클릭을 통해 운동 기록을 볼 수 있습니다", nextText: "다음")
        coachDatas.append(item2)
        let item3 = instructionDatas(View: moveViewButton, bodyText: "다른 뷰로 움직일 수 있는 버튼입니다", nextText: "다음")
        coachDatas.append(item3)
        let item4 = instructionDatas(View: questionButton, bodyText: "운동 영상을 볼 수 있는 뷰로 가는 버튼입니다", nextText: "다음")
        coachDatas.append(item4)
        
        
    }
    
    @objc private func instructionButtonTapped() {
        
        coachMarksController.start(in: .window(over: self))
        
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
            profileImageView.image = defaultPersonImage

            
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
        
        instructionButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(instructionButton).offset(30)
            make.size.equalTo(CGSize(width: 70, height: 60))
        }
        
        
//        titleLabel.frame = CGRect(x: 50,
//                                  y: 50,
//                                  width: view.frame.size.width-100,
//                                  height: 100)
        
        userLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.top.equalTo(titleLabel).offset(55)
            make.size.equalTo(CGSize(width: view.frame.size.width, height: 40))
        }
        
//        userLabel.frame = CGRect(x: 20,
//                                 y: titleLabel.frame.origin.y+80,
//                                 width: view.frame.size.width,
//                                 height: 40)
        
        bannerView.snp.makeConstraints { (make) in
            make.left.equalTo(60)
            make.right.equalTo(-60)
            make.top.equalTo(userLabel).offset(100)
            make.bottom.equalTo(-view.frame.size.height/3)

        }
        
//        bannerView.frame = CGRect(x: 60, y: titleLabel.frame.origin.y + 140, width: view.frame.width-100, height: view.frame.height-500)
        
//        bannerView.itemSize = CGSize(width: view.frame.width-150, height: view.frame.height-600)
        
        dogWalkView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view).offset(view.frame.size.height/2)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSize(width: 250, height: 250))
        }
        
//        dogWalkView.frame = CGRect(x: 80,
//                                   y: bannerView.frame.origin.y+400,
//                                   width: view.frame.size.width-130,
//                                   height: 250)
        
        
//        bannerPageController.frame = CGRect(x: bannerView.frame.origin.x-20, y: bannerView.frame.origin.y+70 , width: 100, height: 100)
        
        
        logInButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.top.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: 100, height: 50))
        }
        
//        logInButton.frame = CGRect(x: view.frame.size.width-100,
//                                   y: titleLabel.frame.origin.y,
//                                   width: 100,
//                                   height: 50)
        
        logOutButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.top.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: 100, height: 50))
        }
        
//        logOutButton.frame = CGRect(x: view.frame.size.width-100,
//                                    y: titleLabel.frame.origin.y,
//                                    width: 100,
//                                    height: 50)
        
        SignUpButton.snp.makeConstraints { (make) in
            make.right.equalTo(logInButton)
            make.top.equalTo(logInButton).offset(50)
            make.size.equalTo(CGSize(width: 100, height: 50))
        }
        
//        SignUpButton.frame = CGRect(x: view.frame.size.width-100,
//                                    y: titleLabel.frame.origin.y+50,
//                                    width: 100,
//                                    height: 50)
        
        personalInfoButton.snp.makeConstraints { (make) in
            make.right.equalTo(logInButton)
            make.top.equalTo(logInButton).offset(50)
            make.size.equalTo(CGSize(width: 100, height: 50))
        }
        
//        personalInfoButton.frame = CGRect(x: view.frame.size.width-100,
//                                          y: titleLabel.frame.origin.y+50,
//                                          width: 100,
//                                          height: 50)
        /*
        recordViewButton.frame = CGRect(x: 50,
                                  y: titleLabel.frame.origin.y+200,
                                  width: view.frame.size.width-100,
                                  height: 200)
 */
        
//        exerciseRecordView.frame = CGRect(x: 50,
//                                          y: bannerView.frame.origin.y+140,
//                                          width: view.frame.size.width-100,
//                                          height: 200)
//
//        chartRecordView.frame = CGRect(x: 80,
//                                  y: exerciseRecordView.frame.origin.y+200,
//                                  width: view.frame.size.width-150,
//                                  height: 200)
//
        
        
       // chartViewButton.frame = CGRect(x: 80,
        //                          y: recordViewButton.frame.origin.y+300,
        //                          width: view.frame.size.width-150,
        //                          height: 200)
        
        questionButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
//        questionButton.frame = CGRect(x: view.frame.maxX-70,
//                                      y: view.frame.maxY-70,
//                                      width: 50,
//                                      height: 50)
        
        moveViewButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.bottom.equalTo(-150)
        }
    }
    

}

extension HomeController: FSPagerViewDelegate, FSPagerViewDataSource, CoachMarksControllerDelegate, CoachMarksControllerDataSource {

    func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        return 2
        
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "bannerCell", at: index)
        
        //cell.imageView?.kf.setImage(with: URL(string: viewDatas[index]))
        
        cell.imageView?.contentMode = .scaleToFill
        cell.imageView?.layer.cornerRadius = 50
        cell.imageView?.layer.shadowColor = UIColor.darkGray.cgColor
        cell.imageView?.layer.shadowOpacity = 1
        cell.imageView?.layer.shadowRadius = 30
        cell.imageView?.clipsToBounds = true
        
        
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = .systemFont(ofSize: 25)
        
        switch index {
        case 0:
            cell.textLabel?.text = "기록 하기"
            cell.imageView?.image = UIImage(named: "Exercise")
        case 1:
            cell.textLabel?.text = "기록 보기"
            cell.imageView?.image = UIImage(named: "Graph")
        default:
            cell.textLabel?.text = ""
        }
     
        
        bannerPageController.currentPage = index
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
        
        switch index {
        case 0:
            recordViewButtonTapped()
        case 1:
            chartViewButtonTapped()
        
        default:
            print("11")
        }
        
    }
    
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return coachDatas.count
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        return coachMarksController.helper.makeCoachMark(for: coachDatas[index].View)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        
        let coachView = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation, hintText: coachDatas[index].bodyText, nextText: coachDatas[index].nextText)

        
        switch index {
        case 0:
            bannerView.scrollToItem(at: index, animated: true)
        case 1:
            bannerView.scrollToItem(at: index, animated: true)
        case 2:
            if !logined {
                moveViewButton.isHidden = false
            }
        case 3:
            if !logined {
                moveViewButton.isHidden = true
            }
        default:
            bannerView.scrollToItem(at: 0, animated: true)
        }
        
        
        return (bodyView: coachView.bodyView, arrowView: coachView.arrowView)
        
    }
    
 
    
}
