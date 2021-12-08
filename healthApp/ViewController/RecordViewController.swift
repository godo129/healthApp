//
//  RecordViewController.swift
//  healthApp
//
//  Created by hong on 2021/10/26.
//

import UIKit
import FirebaseDatabase
import CircleMenu
import SideMenu
import Instructions
import SnapKit

class RecordViewController: UIViewController {
    
    private var coachMarksController = CoachMarksController()

    private let instructionButton: UIButton = {
            
            let instructionButton = UIButton()
            instructionButton.setImage(UIImage(named: "what"), for: .normal)
            return instructionButton
            
        }()
        
    private var coachDatas = [instructionDatas]()

    
    private let db = Database.database().reference()
    
    var moveViewButton = CircleMenu(
      frame: CGRect(x: 380, y: 400, width: 50, height: 50),
      normalIcon:"bar",
      selectedIcon:"close",
      buttonsCount: 8,
      duration: 1,
      distance: 100)

    
    let normalImage = UIImage(named: "bar")
    
    private let oneButton: UIButton = {
        let oneButton = UIButton()
        oneButton.setTitle("기록", for: .normal)
        oneButton.backgroundColor = .link

        return oneButton
    }()

    
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        return dateLabel
    } ()
    
    private let backButton: UIButton = {
        let backbutton = UIButton()
        backbutton.setTitle("Back", for: .normal)
        backbutton.setTitleColor(.systemBlue, for: .normal)
        return backbutton

    }()
    
    private let calendarButton: UIButton = {
        let calendarButton = UIButton()
        calendarButton.setTitle("달력", for: .normal)
        calendarButton.backgroundColor = .link

        return calendarButton
    }()
    
    private let recordButton: UIButton = {
        let recordButton = UIButton()
        recordButton.setTitle("기록", for: .normal)
        recordButton.setTitleColor(.black, for: .normal)
        recordButton.backgroundColor = .white
        recordButton.layer.borderColor = UIColor.link.cgColor
        recordButton.layer.borderWidth = 2

        return recordButton
    }()

    
    private let textView: UITextView = {
        let textView = UITextView()
        return textView
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 메모정보 가져오기
        db.child(p_id).child(cur_date).child("memo").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? String else {
                return
            }
            
            
            self.textView.text = value
        })
        
        view.addSubview(backButton)
        view.addSubview(dateLabel)
       // view.addSubview(calendarButton)
        view.addSubview(recordButton)
        view.addSubview(textView)
        
        moveViewButton.delegate = self
        view.addSubview(moveViewButton)
        moveViewButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
  
        
        //사이드 메뉴 옵션
        sideBar.leftSide = true
        SideMenuManager.default.addPanGestureToPresent(toView: view.self)
        SideMenuManager.default.leftMenuNavigationController = sideBar
        sideBar.isNavigationBarHidden = true

        sideBar.menuWidth = 300
        
        
        calendarButton.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        

    }
    
    @objc private func tapped() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        dateLabel.text = cur_date
        
        // 도움말
        view.addSubview(instructionButton)
                
        // 도움말 데이터 넣어주기
        fillCoachDatas()
        coachMarksController.dataSource = self
        //배경 눌러도 자동으로 넘어가게
        coachMarksController.overlay.isUserInteractionEnabled = true
        
        instructionButton.addTarget(self, action: #selector(instructionButtonTapped), for: .touchUpInside)
                
        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("skip", for: .normal)
        coachMarksController.skipView = skipView


    }
    
    private func fillCoachDatas() {
            
            let item1 = instructionDatas(View: dateLabel, bodyText: "현재 날짜입니다", nextText: "다음")
            coachDatas.append(item1)
            let item2 = instructionDatas(View: textView, bodyText: "여기에 메모를 기록할 수 있습니다", nextText: "다음")
            coachDatas.append(item2)
            let item3 = instructionDatas(View: recordButton, bodyText: "메모를 기록할 수 있습니다", nextText: "다음")
            coachDatas.append(item3)
            let item4 = instructionDatas(View: moveViewButton, bodyText: "다른 뷰로 갈 수 있는 버튼입니다", nextText: "다음")
            coachDatas.append(item4)
            
            
            
        }
        
    @objc private func instructionButtonTapped() {
            
        coachMarksController.start(in: .window(over: self))
            
    }

    
    
    
    @objc private func calendarButtonTapped() {
        

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalendarView")
        vc?.modalPresentationStyle = .overCurrentContext
        self.present(vc!, animated: false, completion: nil)
    
    }
    
    @objc private func recordButtonTapped() {
        

        guard let memo = textView.text, !memo.isEmpty else {
          //  let object: [String:String] = ["memo":""]
            db.child(p_id).child(cur_date).child("memo").setValue("")
            return
        }

        //let object: [String:String] = ["memo":memo]
        db.child(p_id).child(cur_date).child("memo").setValue(memo)

    }
    
    @objc private func backButtonTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExerciseRecordView")
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .coverVertical
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        
        backButton.snp.makeConstraints { (make) in
//            make.top.equalTo(30)
            make.top.equalTo(instructionButton)
//            make.left.equalTo(20)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.size.equalTo(CGSize(width: 50, height: 30))
        }
        
        instructionButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
//            make.top.equalTo(40)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(15)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
//        instructionButton.frame = CGRect(x: 200, y: 40, width: 30, height: 30)
        
//        backButton.frame = CGRect(x: 20, y: 40, width: 50, height: 30)
//        dateLabel.frame = CGRect(x: self.view.bounds.maxX/2-50, y: 100, width: 100, height: 100)
        
        dateLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(instructionButton).offset(50)
            make.size.equalTo(CGSize(width: 100, height: 30))
        }
        
        //calendarButton.frame = CGRect(x: 350, y: 100, width: 50, height: 30)
//        recordButton.frame = CGRect(x: 350, y: dateLabel.frame.origin.y+50, width: 50, height: 30)
        
        recordButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.top.equalTo(dateLabel)
            make.size.equalTo(CGSize(width: 50, height: 30))
        }
        
        moveViewButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.centerY.equalTo(self.view)
            make.size.equalTo(CGSize(width: 50, height: 50))
            
        }
//        textView.frame = CGRect(x: 50, y: recordButton.frame.origin.y+100, width: view.frame.size.width-100, height: view.frame.size.height-400)
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel).offset(50)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(60)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-60)
            make.bottom.equalTo(-100)
        }
    }
}


extension RecordViewController: CoachMarksControllerDelegate, CoachMarksControllerDataSource {
    
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


