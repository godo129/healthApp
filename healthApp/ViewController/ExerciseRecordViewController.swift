//
//  ExerciseRecordViewController.swift
//  healthApp
//
//  Created by hong on 2021/10/27.
//

import UIKit
import FirebaseDatabase
import SRCountdownTimer
import CircleMenu
import SideMenu
import Instructions

var history = ""
var setCount = 0
var nowExerciseType = "운동 종류"
var weightCount = 0
var exerciseHistory: [String] = []
var calories = 0.0
var volumes = 0


class ExerciseRecordViewController: UIViewController {
    
    private var coachMarksController = CoachMarksController()
    
    private let instructionButton: UIButton = {
        
        let instructionButton = UIButton()
        instructionButton.setImage(UIImage(named: "what"), for: .normal)

        
        return instructionButton
        
    }()
    
    private var coachDatas = [instructionDatas]()
    
    
    var tappedReset = false
    
    let moveViewButton = CircleMenu(
      frame: CGRect(x: 380, y: 400, width: 50, height: 50),
      normalIcon:"bar",
      selectedIcon:"close",
      buttonsCount: 8,
      duration: 1,
      distance: 100)

    private let counter: SRCountdownTimer = {
        let counter = SRCountdownTimer()
        counter.labelTextColor = .black
        counter.trailLineColor = .white
        counter.lineWidth = 10.0
        counter.lineColor = .orange
        counter.backgroundColor = .white
        return counter
    }()
    
    private let counterResumeButton : UIButton = {
        let counterResumeButton = UIButton()
        counterResumeButton.setTitle("resume", for: .normal)
        counterResumeButton.setTitleColor(.black, for: .normal)
        return counterResumeButton
    }()
    
    private let counterPauseButton : UIButton = {
        let counterPauseButton = UIButton()
        counterPauseButton.setTitle("pause", for: .normal)
        counterPauseButton.setTitleColor(.black, for: .normal)
        return counterPauseButton
    }()
    
    private let counterResetButton : UIButton = {
        let counterResetButton = UIButton()
        counterResetButton.setTitle("reset", for: .normal)
        counterResetButton.setTitleColor(.black, for: .normal)
        return counterResetButton
    }()
    
    
    
    // 추가 빼기 제어
    var plus = true
    
    var intervalTime = 0
    
    var historyTable = UITableView()
    
    let noti = UNUserNotificationCenter.current()
    
        
    private let db = Database.database().reference()

    private let backButton: UIButton = {
        let backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
        
        return backButton
    }()
    
    private let nowDateLabel: UILabel = {
        let nowDateLabel = UILabel()
        nowDateLabel.text = cur_date
        nowDateLabel.textAlignment = .center
        nowDateLabel.font = .systemFont(ofSize: 20)
        return nowDateLabel
    }()
    
    private let calorieLabel: UILabel = {
        let calorieLabel = UILabel()
        calorieLabel.textAlignment = .center
        calorieLabel.textColor = .systemRed
        return calorieLabel
    }()
    
    private let intervalTimeField: UITextField = {
        let intervalTimeField = UITextField()
        intervalTimeField.textColor = .black
        intervalTimeField.borderStyle = .roundedRect
        intervalTimeField.textAlignment = .center
        
        return intervalTimeField
    }()
    
    private let intervalAlertButton: UIButton = {
        let intervalAlertButton = UIButton()
        intervalAlertButton.setImage(UIImage(named: "interval"), for: .normal)
        return intervalAlertButton
    }()
    
    private let memoButton: UIButton = {
        
        let memoButton = UIButton()
        memoButton.setTitle("메모", for: .normal)
        memoButton.setTitleColor(.black, for: .normal)
        memoButton.backgroundColor = .white
        memoButton.layer.borderColor = UIColor.orange.cgColor
        memoButton.layer.borderWidth = 2
        
        return memoButton
    }()

    
    private let calendarButton: UIButton = {
        let calendarButton = UIButton()
        calendarButton.setTitle("달력", for: .normal)
        calendarButton.setTitleColor(.black, for: .normal)
        calendarButton.backgroundColor = .white
        calendarButton.layer.borderColor = UIColor.blue.cgColor
        calendarButton.layer.borderWidth = 2
        return calendarButton
    }()
    
  /*
    private let historyLabel: UILabel = {
        var historyLabel = UILabel()
        historyLabel.textColor = .black
        historyLabel.numberOfLines = 0
        historyLabel.textAlignment = .natural
        return historyLabel
    }()
    */
    private let setLabel : UILabel = {
        let setLabel = UILabel()
        setLabel.textAlignment = .center
        setLabel.layer.borderColor = UIColor.systemBlue.cgColor
        setLabel.layer.borderWidth = 2
        setLabel.layer.cornerRadius = 10
        return setLabel
    }()
    
    private var weightLable : UILabel = {
        let weightLabel = UILabel()
        weightLabel.textAlignment = .center
        weightLabel.layer.borderWidth = 2
        weightLabel.layer.borderColor = UIColor.systemBlue.cgColor
        weightLabel.layer.cornerRadius = 10
        return weightLabel
    }()
    
    
    private let weightButton : UIButton = {
        let weightButton = UIButton()
        weightButton.backgroundColor = .blue
        return weightButton
    }()
    
    private let setButton : UIButton = {
        let setButton = UIButton()
        return setButton
    }()
    
    private let nowExTypeButton : UIButton = {
        let nowExTypeButton = UIButton()
        nowExTypeButton.setTitleColor(.black, for: .normal)
        nowExTypeButton.setTitle(nowExerciseType, for: .normal)
        nowExTypeButton.layer.borderWidth = 3
        nowExTypeButton.layer.borderColor = UIColor.black.cgColor
        nowExTypeButton.layer.cornerRadius = 10
        return nowExTypeButton
    }()
    
    private let fiveKiloBarbellButton: UIButton = {
        let fiveKiloBabelButton = UIButton()
        fiveKiloBabelButton.setImage(UIImage.init(named: "FiveBar"), for: .normal)
        
        return fiveKiloBabelButton
    }()
    
    private let tenKiloBarbellButton: UIButton = {
        let tenKiloBarbellButton = UIButton()
        tenKiloBarbellButton.setImage(UIImage.init(named: "TenBar"), for: .normal)
        return tenKiloBarbellButton
    }()
    
    private let twentyKiloBarbellButton: UIButton = {
        let twentyKiloBarbellButton = UIButton()
        twentyKiloBarbellButton.setImage(UIImage.init(named: "TwentyBar"), for: .normal)
        return twentyKiloBarbellButton
    }()
    
    
    
    
    
    private let recordButton : UIButton = {
        let recordButton = UIButton()
        recordButton.setTitle("저장", for: .normal)
        recordButton.setTitleColor(.black, for: .normal)
        recordButton.backgroundColor = .white
        recordButton.layer.borderColor = UIColor.orange.cgColor
        recordButton.layer.borderWidth = 2
        return recordButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // 날짜 정보 없을 시 처리
        if cur_date == "" {
            let c_date = DateFormatter()
            c_date.dateFormat = "yyyy-MM-dd"
            let c_date_string = c_date.string(from: Date())
            cur_date = c_date_string
            today = c_date_string
        }
        
        
        historyTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        historyTable.delegate = self
        historyTable.dataSource = self
        
        
        
        
        view.addSubview(backButton)
        view.addSubview(memoButton)
        view.addSubview(calendarButton)
       // view.addSubview(historyLabel)
        
        
        
        view.addSubview(intervalAlertButton)
        
        view.addSubview(historyTable)
        
        view.addSubview(nowDateLabel)
        view.addSubview(calorieLabel)
        
        //view.addSubview(setLabel)
        view.addSubview(weightLable)
        //view.addSubview(weightButton)
        view.addSubview(nowExTypeButton)
        //view.addSubview(fiveKiloBarbellButton)
        //view.addSubview(tenKiloBarbellButton)
        //view.addSubview(twentyKiloBarbellButton)
        view.addSubview(recordButton)
        view.addSubview(setButton)
        
        
        view.addSubview(counter)
        counter.delegate = self
        
        view.addSubview(counterResumeButton)
        view.addSubview(counterPauseButton)
        view.addSubview(counterResetButton)
        
        counterResetButton.isHidden = true
        counterResumeButton.isHidden = true
        counterPauseButton.isHidden = true

        view.addSubview(intervalTimeField)
        // 텍스트 필드 숫자만입력 되게 권한 부여
        intervalTimeField.delegate = self
        
        moveViewButton.delegate = self
        view.addSubview(moveViewButton)
        
        
        //사이드 메뉴 옵션
        sideBar.leftSide = true
        SideMenuManager.default.addPanGestureToPresent(toView: view.self)
        SideMenuManager.default.leftMenuNavigationController = sideBar
        sideBar.isNavigationBarHidden = true

        sideBar.menuWidth = 300
        
        notiAuth()

        
    
        // 도움말
        view.addSubview(instructionButton)
        
        // 도움말 데이터 넣어주기
        fillCoachDatas()
        coachMarksController.dataSource = self
        //배경 눌러도 자동으로 넘어가게
        coachMarksController.overlay.isUserInteractionEnabled = true
        
        //스킵 버튼
        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("skip", for: .normal)
        coachMarksController.skipView = skipView
        
        instructionButton.addTarget(self, action: #selector(instructionButtonTapped), for: .touchUpInside)
        
        
    
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        intervalAlertButton.addTarget(self, action: #selector(intervalAlertButtonTapped), for: .touchUpInside)
        memoButton.addTarget(self, action: #selector(memoButtonTapped), for: .touchUpInside)
        calendarButton.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        weightButton.addTarget(self, action: #selector(weightButtonTapped), for: .touchUpInside)
        //setButton.addTarget(self, action: #selector(setButtonTapped), for: .touchUpInside)
        nowExTypeButton.addTarget(self, action: #selector(nowExTypeButtonTapped), for: .touchUpInside)
        
        counterResumeButton.addTarget(self, action: #selector(counterResumeButtonTapped), for: .touchUpInside)
        counterPauseButton.addTarget(self, action: #selector(counterPauseButtonTapped), for: .touchUpInside)
        counterResetButton.addTarget(self, action: #selector(counterResetButtonTapped), for: .touchUpInside)

        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        view.addSubview(setLabel)
        
        nowDateLabel.text = cur_date
   
        
        setCount = 0
        weightCount = 0
   
        
        // 운동별 변화
        settingWeightCount()
        
        
        setButton.setTitleColor(.black, for: .normal)
        
        intervalTimeField.text = String(intervalTime)
        nowExTypeButton.setTitle(nowExerciseType, for: .normal)

        
        exerciseHistory = []
        
        exerciseTypesDataStorage = making()
        
        calories = 0.0
        volumes = 0
   
        
        fromChart = false
        
   
        // 칼로리 보여줌
        db.child("\(p_id)/\(cur_date)/calories").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? Double else {
                self.calorieLabel.text = "소비된 칼로리 : 0.0Kcal"
                calories = 0.0
                return
            }
            self.calorieLabel.text = "소비된 칼로리 : \(doubleConvertToString(number: value))Kcal"
            calories = value
        }
        
        db.child("\(p_id)/\(cur_date)/volumes").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? Int else {
                volumes = 0
                return
            }
            volumes = value
        }
        
        
        
        db.child(p_id).child(cur_date).child("history").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String] else {
                let value: [String] = []
                UserDefaults.standard.setValue(value, forKey: "exerciseHistory")
                return
            }
            
            UserDefaults.standard.setValue(value, forKey: "exerciseHistory")
            exerciseHistory = UserDefaults.standard.value(forKey: "exerciseHistory") as! [String]
            self.historyTable.reloadData()
            
            
            for compo in exerciseHistory {
                
                if compo.contains("휴식") {
   
                } else {
                    let type = compo.split(separator: ":")[0]
                    let explain = compo.split(separator: ":")[1]
                      
                    guard let selectedWeight: Int = Int(explain.split(separator: " ")[0]) else {return}
                        
                    var newList = exerciseTypesDataStorage[String(type)]!
                        
                    newList.append(selectedWeight)
                    exerciseTypesDataStorage[String(type)] = newList

                }
                
            }
            
        })
        
        
        // 운동 변하거나, 그럴 때 무게, 횟수 초기화
        setCount = 0
        weightCount = 0
        
        if nowExerciseType == "워킹" {
            nowExerciseType = "종목 선택"
            
            nowExTypeButton.setTitle(nowExerciseType, for: .normal)
            setButton.setTitle("\(setCount) 회", for: .normal)
        } else if isAerovic(type: nowExerciseType) {
            
            setButton.setTitle("\(setCount) 분", for: .normal)
        } else {
            setButton.setTitle("\(setCount) 회", for: .normal)
        }
        
        weightLable.text = "\(weightCount) kg"
        
        
    }
    
    
    func notiAuth() {
        
        let AuthOption = UNAuthorizationOptions(arrayLiteral: [.badge, .sound, .alert])
        noti.requestAuthorization(options: AuthOption) { success, error in
            guard error == nil else {

                print("권한 부여 오류")
                return
            }
            
            if !success {
                let alert = UIAlertController(title: "주의", message: "선택을 취소하셔서 휴식 종료 알림을 사용할 수 없습니다", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    private func fillCoachDatas() {
            
        
            let item = instructionDatas(View: nowDateLabel, bodyText: "선택된 날짜입니다", nextText: "다음")
        coachDatas.append(item)
            let itemA = instructionDatas(View: calorieLabel, bodyText: "소비한 칼로리를 알 수 있습니다", nextText: "다음")
            coachDatas.append(itemA)
            let item1 = instructionDatas(View: calendarButton, bodyText: "날짜를 선택할 수 있습니다", nextText: "다음")
            coachDatas.append(item1)
            let item2 = instructionDatas(View: memoButton, bodyText: "메모를 기록할 수 있습니다", nextText: "다음")
            coachDatas.append(item2)
            let item3 = instructionDatas(View: historyTable, bodyText: "운동이 기록되는 부분입니다", nextText: "다음")
            coachDatas.append(item3)
            let item4 = instructionDatas(View: moveViewButton, bodyText: "다른 뷰로 갈 수 있는 버튼입니다", nextText: "다음")
            coachDatas.append(item4)
            let item5 = instructionDatas(View: nowExTypeButton, bodyText: "운동 종류를 선택할 수 있는 버튼입니다", nextText: "다음")
            coachDatas.append(item5)
            let item6 = instructionDatas(View: setLabel, bodyText: "횟수나 분을 나타내는 부분입니다", nextText: "다음")
            coachDatas.append(item6)
            let item6_1 = instructionDatas(View: weightLable, bodyText: "무게를 나타내는 부분입니다", nextText: "다음")
            coachDatas.append(item6_1)
            let item7 = instructionDatas(View: recordButton, bodyText: "운동을 기록할 수 있는 부분입니다", nextText: "다음")
            coachDatas.append(item7)
            let item11 = instructionDatas(View: counter, bodyText: "휴식을 기록할 수 있는 부분입니다", nextText: "다음")
            coachDatas.append(item11)
            let item12 = instructionDatas(View: intervalTimeField, bodyText: "휴식 기간을 적는 부분입니다", nextText: "다음")
            coachDatas.append(item12)
            let item13 = instructionDatas(View: intervalAlertButton, bodyText: "이 버튼으로 휴식이 시작합니다.", nextText: "다음")
            coachDatas.append(item13)
        
        
        let item16 = instructionDatas(View: counterPauseButton, bodyText: "휴식 시간을 일시정지 할 수 있습니다", nextText: "다음")
        coachDatas.append(item16)
        let item17 = instructionDatas(View: counterResumeButton, bodyText: "휴식을 재시작 합니다", nextText: "다음")
        coachDatas.append(item17)
        
        coachDatas.append(instructionDatas(View: counterResetButton, bodyText: "휴식 시간을 초기화합니다", nextText: "다음"))
            
        }
    
    
    private func settingWeightCount() {
        
        if onlyTime.contains(nowExerciseType) {
            
            plusOneButtons.isHidden = true
            plusFiveButtons.isHidden = true
            plusTenButtons.isHidden = true
            minusOneButtons.isHidden = true
            minusFiveButtons.isHidden = true
            minusTenButtons.isHidden = true
            
            setLabel.text = "\(setCount) 분"
           
            let plusOneButton1 = plusOneButton
            let plusFiveButton1 = plusFiveButton
            let plusTenButton1 = plusTenButton
            let minusOneButton1 = minusOneButton
            let minusFiveButton1 = minusFiveButton
            let minusTenButton1 = minusTenButton
            
            
            setLabel.frame = CGRect(x: view.frame.width/2-40, y: instructionButton.frame.origin.y+550, width: 80, height: 40)
            minusOneButton1.frame =  CGRect(x: setLabel.frame.origin.x-160, y: setLabel.frame.origin.y, width: 40, height: setLabel.frame.height)
            minusFiveButton1.frame =  CGRect(x: setLabel.frame.origin.x-110, y: setLabel.frame.origin.y, width: 40, height: setLabel.frame.height)
            minusTenButton1.frame =  CGRect(x: setLabel.frame.origin.x-60, y: setLabel.frame.origin.y, width: 40, height: setLabel.frame.height)
            plusOneButton1.frame =  CGRect(x: setLabel.frame.origin.x+200, y: setLabel.frame.origin.y, width: 40, height: setLabel.frame.height)
            plusFiveButton1.frame =  CGRect(x: setLabel.frame.origin.x+150, y: setLabel.frame.origin.y, width: 40, height: setLabel.frame.height)
            plusTenButton1.frame =  CGRect(x: setLabel.frame.origin.x+100, y: setLabel.frame.origin.y, width: 40, height: setLabel.frame.height)
            
            
            view.addSubview(plusOneButton1)
            view.addSubview(plusFiveButton1)
            view.addSubview(plusTenButton1)
            view.addSubview(minusOneButton1)
            view.addSubview(minusFiveButton1)
            view.addSubview(minusTenButton1)
            
            minusOneButton1.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            minusFiveButton1.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            minusTenButton1.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            plusOneButton1.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            plusFiveButton1.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            plusTenButton1.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            
            weightLable.isHidden = true

            
        } else if onlyCount.contains(nowExerciseType) {
            
            plusOneButtons.isHidden = true
            plusFiveButtons.isHidden = true
            plusTenButtons.isHidden = true
            minusOneButtons.isHidden = true
            minusFiveButtons.isHidden = true
            minusTenButtons.isHidden = true

            
            setLabel.text = "\(setCount) 회"
            
            let plusOneButton1 = plusOneButton
            let plusFiveButton1 = plusFiveButton
            let plusTenButton1 = plusTenButton
            let minusOneButton1 = minusOneButton
            let minusFiveButton1 = minusFiveButton
            let minusTenButton1 = minusTenButton
            
            
            
            setLabel.frame = CGRect(x: view.frame.width/2-40, y: instructionButton.frame.origin.y+550, width: 80, height: 40)
            minusOneButton1.frame =  CGRect(x: setLabel.frame.origin.x-160, y: setLabel.frame.origin.y, width: 40, height: setLabel.frame.height)
            minusFiveButton1.frame =  CGRect(x: setLabel.frame.origin.x-110, y: setLabel.frame.origin.y, width: 40, height: setLabel.frame.height)
            minusTenButton1.frame =  CGRect(x: setLabel.frame.origin.x-60, y: setLabel.frame.origin.y, width: 40, height: setLabel.frame.height)
            plusOneButton1.frame =  CGRect(x: setLabel.frame.origin.x+200, y: setLabel.frame.origin.y, width: 40, height: setLabel.frame.height)
            plusFiveButton1.frame =  CGRect(x: setLabel.frame.origin.x+150, y: setLabel.frame.origin.y, width: 40, height: setLabel.frame.height)
            plusTenButton1.frame =  CGRect(x: setLabel.frame.origin.x+100, y: setLabel.frame.origin.y, width: 40, height: setLabel.frame.height)
            
            view.addSubview(plusOneButton1)
            view.addSubview(plusFiveButton1)
            view.addSubview(plusTenButton1)
            view.addSubview(minusOneButton1)
            view.addSubview(minusFiveButton1)
            view.addSubview(minusTenButton1)
            
            minusOneButton1.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            minusFiveButton1.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            minusTenButton1.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            plusOneButton1.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            plusFiveButton1.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            plusTenButton1.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            
            weightLable.isHidden = true
            
        } else {
            
            setLabel.text = "\(setCount) 회"
            weightLable.isHidden = false
            
            plusOneButtons.isHidden = false
            plusFiveButtons.isHidden = false
            plusTenButtons.isHidden = false
            minusOneButtons.isHidden = false
            minusFiveButtons.isHidden = false
            minusTenButtons.isHidden = false
            
            
            setLabel.frame = CGRect(x: view.frame.width/2-40, y: instructionButton.frame.origin.y+550, width: 80, height: 40)
            weightLable.frame = CGRect(x: setLabel.frame.origin.x, y: setLabel.frame.origin.y+70, width: 80, height: 40)
            
            let plusOneButton1 = plusOneButton
            let plusFiveButton1 = plusFiveButton
            let plusTenButton1 = plusTenButton
            let minusOneButton1 = minusOneButton
            let minusFiveButton1 = minusFiveButton
            let minusTenButton1 = minusTenButton
            
            let plusOneButton2 = plusOneButtons
            let plusFiveButton2 = plusFiveButtons
            let plusTenButton2 = plusTenButtons
            let minusOneButton2 = minusOneButtons
            let minusFiveButton2 = minusFiveButtons
            let minusTenButton2 = minusTenButtons
            
            
            minusOneButton1.frame =  CGRect(x: setLabel.frame.origin.x-160, y: setLabel.frame.origin.y, width: 40, height: setLabel.frame.height)
            minusFiveButton1.frame =  CGRect(x: setLabel.frame.origin.x-110, y: setLabel.frame.origin.y, width: 40, height: setLabel.frame.height)
            minusTenButton1.frame =  CGRect(x: setLabel.frame.origin.x-60, y: setLabel.frame.origin.y, width: 40, height: setLabel.frame.height)
            plusOneButton1.frame =  CGRect(x: setLabel.frame.origin.x+200, y: setLabel.frame.origin.y, width: 40, height: setLabel.frame.height)
            plusFiveButton1.frame =  CGRect(x: setLabel.frame.origin.x+150, y: setLabel.frame.origin.y, width: 40, height: setLabel.frame.height)
            plusTenButton1.frame =  CGRect(x: setLabel.frame.origin.x+100, y: setLabel.frame.origin.y, width: 40, height: setLabel.frame.height)
            
            minusOneButton2.frame =  CGRect(x: weightLable.frame.origin.x-160, y: weightLable.frame.origin.y, width: 40, height: weightLable.frame.height)
            minusFiveButton2.frame =  CGRect(x: weightLable.frame.origin.x-110, y: weightLable.frame.origin.y, width: 40, height: weightLable.frame.height)
            minusTenButton2.frame =  CGRect(x: weightLable.frame.origin.x-60, y: weightLable.frame.origin.y, width: 40, height: weightLable.frame.height)
            plusOneButton2.frame =  CGRect(x: weightLable.frame.origin.x+200, y: weightLable.frame.origin.y, width: 40, height: weightLable.frame.height)
            plusFiveButton2.frame =  CGRect(x: weightLable.frame.origin.x+150, y: weightLable.frame.origin.y, width: 40, height: weightLable.frame.height)
            plusTenButton2.frame =  CGRect(x: weightLable.frame.origin.x+100, y: weightLable.frame.origin.y, width: 40, height: weightLable.frame.height)
            
            minusOneButton1.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            minusFiveButton1.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            minusTenButton1.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            plusOneButton1.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            plusFiveButton1.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            plusTenButton1.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            
            minusOneButton2.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            minusFiveButton2.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            minusTenButton2.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            plusOneButton2.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            plusFiveButton2.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            plusTenButton2.layer.cornerRadius = plusOneButton1.bounds.size.width / 2
            
            
            
            view.addSubview(plusOneButton1)
            view.addSubview(plusFiveButton1)
            view.addSubview(plusTenButton1)
            view.addSubview(minusOneButton1)
            view.addSubview(minusFiveButton1)
            view.addSubview(minusTenButton1)
            
            view.addSubview(plusOneButton2)
            view.addSubview(plusFiveButton2)
            view.addSubview(plusTenButton2)
            view.addSubview(minusOneButton2)
            view.addSubview(minusFiveButton2)
            view.addSubview(minusTenButton2)
        
        }
        
        plusOneButton.addTarget(self, action: #selector(plusOneSet), for: .touchUpInside)
        plusFiveButton.addTarget(self, action: #selector(plusFiveSet), for: .touchUpInside)
        plusTenButton.addTarget(self, action: #selector(plusTenSet), for: .touchUpInside)
        minusOneButton.addTarget(self, action: #selector(minusOneSet), for: .touchUpInside)
        minusFiveButton.addTarget(self, action: #selector(minusFiveSet), for: .touchUpInside)
        minusTenButton.addTarget(self, action: #selector(minusTenSet), for: .touchUpInside)
        
        plusOneButtons.addTarget(self, action: #selector(plusOneWeight), for: .touchUpInside)
        plusFiveButtons.addTarget(self, action: #selector(plusFiveWeight), for: .touchUpInside)
        plusTenButtons.addTarget(self, action: #selector(plusTenWeight), for: .touchUpInside)
        minusOneButtons.addTarget(self, action: #selector(minusOneWeight), for: .touchUpInside)
        minusFiveButtons.addTarget(self, action: #selector(minusFiveWeight), for: .touchUpInside)
        minusTenButtons.addTarget(self, action: #selector(minusTenWeight), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        plusOneButton.removeTarget(self, action: #selector(plusOneSet), for: .touchUpInside)
        plusFiveButton.removeTarget(self, action: #selector(plusFiveSet), for: .touchUpInside)
        plusTenButton.removeTarget(self, action: #selector(plusTenSet), for: .touchUpInside)
        minusOneButton.removeTarget(self, action: #selector(minusOneSet), for: .touchUpInside)
        minusFiveButton.removeTarget(self, action: #selector(minusFiveSet), for: .touchUpInside)
        minusTenButton.removeTarget(self, action: #selector(minusTenSet), for: .touchUpInside)
        
        plusOneButtons.removeTarget(self, action: #selector(plusOneWeight), for: .touchUpInside)
        plusFiveButtons.removeTarget(self, action: #selector(plusFiveWeight), for: .touchUpInside)
        plusTenButtons.removeTarget(self, action: #selector(plusTenWeight), for: .touchUpInside)
        minusOneButtons.removeTarget(self, action: #selector(minusOneWeight), for: .touchUpInside)
        minusFiveButtons.removeTarget(self, action: #selector(minusFiveWeight), for: .touchUpInside)
        minusTenButtons.removeTarget(self, action: #selector(minusTenWeight), for: .touchUpInside)
    }
        
    @objc private func instructionButtonTapped() {
            
        coachMarksController.start(in: .window(over: self))
            
    }

    
    @objc private func plusOneSet() {
        setCount += 1
        
        if onlyTime.contains(nowExerciseType) {
            
            setLabel.text = "\(setCount) 분"
            
        } else {
            
            setLabel.text = "\(setCount) 회"
        }
    }
    
    @objc private func plusFiveSet() {
        setCount += 5
        
        if onlyTime.contains(nowExerciseType) {
            
            setLabel.text = "\(setCount) 분"
            
        } else {
            
            setLabel.text = "\(setCount) 회"
        }
    }
    
    @objc private func plusTenSet() {
        setCount += 10
        
        if onlyTime.contains(nowExerciseType) {
            
            setLabel.text = "\(setCount) 분"
            
        } else {
            
            setLabel.text = "\(setCount) 회"
        }
    }
    
    
    @objc private func minusOneSet() {
        
        if setCount - 1 < 0 {
            setCount = 0
            if onlyTime.contains(nowExerciseType) {
                
                setLabel.text = "\(setCount) 분"
                
            } else {
                
                setLabel.text = "\(setCount) 회"
            }
            return
        }
        
        setCount -= 1
        
        if onlyTime.contains(nowExerciseType) {
            
            setLabel.text = "\(setCount) 분"
            
        } else {
            
            setLabel.text = "\(setCount) 회"
        }
    }
    
    
    @objc private func minusFiveSet() {
        
        if setCount - 5 < 0 {
            setCount = 0
            if onlyTime.contains(nowExerciseType) {
                
                setLabel.text = "\(setCount) 분"
                
            } else {
                
                setLabel.text = "\(setCount) 회"
            }
            return
        }
        
        setCount -= 5
        
        if onlyTime.contains(nowExerciseType) {
            
            setLabel.text = "\(setCount) 분"
            
        } else {
            
            setLabel.text = "\(setCount) 회"
        }
    }
    
    
    @objc private func minusTenSet() {
        
        if setCount - 10 < 0 {
            setCount = 0
            if onlyTime.contains(nowExerciseType) {
                
                setLabel.text = "\(setCount) 분"
                
            } else {
                
                setLabel.text = "\(setCount) 회"
            }
            return
        }
        
        setCount -= 10
        
        if onlyTime.contains(nowExerciseType) {
            
            setLabel.text = "\(setCount) 분"
            
        } else {
            
            setLabel.text = "\(setCount) 회"
        }
    }
    
    @objc private func plusOneWeight() {
        weightCount += 1
        
        if !onlyTime.contains(nowExerciseType) && !onlyCount.contains(nowExerciseType) {
            weightLable.text = "\(weightCount) kg"
        }
    }
    
    @objc private func plusFiveWeight() {
        weightCount += 5
        
        if !onlyTime.contains(nowExerciseType) && !onlyCount.contains(nowExerciseType) {
            weightLable.text = "\(weightCount) kg"
        }
    }
    
    @objc private func plusTenWeight() {
        weightCount += 10
        
        if !onlyTime.contains(nowExerciseType) && !onlyCount.contains(nowExerciseType) {
            weightLable.text = "\(weightCount) kg"
        }
    }
    
    @objc private func minusOneWeight() {
        
        
        if weightCount-1 < 0 {
            weightCount = 0
            weightLable.text = "\(weightCount) kg"
            return
        }
        
        weightCount -= 1
        
        if !onlyTime.contains(nowExerciseType) && !onlyCount.contains(nowExerciseType) {
            weightLable.text = "\(weightCount) kg"
        }
    }
    
    @objc private func minusFiveWeight() {
        
        if weightCount - 5 < 0 {
            weightCount = 0
            weightLable.text = "\(weightCount) kg"
            return
        }
        
        weightCount -= 5
        
        if !onlyTime.contains(nowExerciseType) && !onlyCount.contains(nowExerciseType) {
            weightLable.text = "\(weightCount) kg"
        }
    }
    
    @objc private func minusTenWeight() {
        
        if weightCount - 10 < 0 {
            weightCount = 0
            weightLable.text = "\(weightCount) kg"
            return
        }
        
        weightCount -= 10
        
        if !onlyTime.contains(nowExerciseType) && !onlyCount.contains(nowExerciseType) {
            weightLable.text = "\(weightCount) kg"
        }
    }
    
    

    @objc private func  counterResetButtonTapped() {
        tappedReset = true
        counter.end()
    }
    
    
    @objc private func counterResumeButtonTapped() {
        counterPauseButton.isHidden = false
        counterResumeButton.isHidden = true
        counter.resume()
    }
    
    @objc private func counterPauseButtonTapped() {
        counterPauseButton.isHidden = true
        counterResumeButton.isHidden = false
        counter.pause()
    }
    
    @objc private func intervalAlertButtonTapped() {
        
        
        guard let time = intervalTimeField.text, !time.isEmpty else {
            return
        }
        
        intervalTime = Int(time)!
        
        // 0초의 알림은 불가
        if intervalTime <= 0 {
            return
        }
        
        counter.start(beginingValue: intervalTime, interval: 1)
        
        intervalTimeField.isHidden = true
        intervalAlertButton.isHidden = true
        
        counterPauseButton.isHidden = false
        counterResumeButton.isHidden = true
        counterResetButton.isHidden = false
        
        
        
       /*
        
        if intervalTime <= 0 {
            return
        }
       
        let content = UNMutableNotificationContent()
        content.title = "쉬는 시간 끝!!"
        content.body = "운동을 다시 시작해주세요!!"
        content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 10.0)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(time)!, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content3, trigger: trigger)
        noti.add(request) {error in
            guard error == nil else {
                
                return
            }
        }
 */
        
    }
    
    
    
    @objc private func backButtonTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeView")
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .coverVertical
        self.present(vc!, animated: true, completion: nil)
    }
    
    @objc private func memoButtonTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RecordView")
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .coverVertical
        self.present(vc!, animated: true, completion: nil)
    }
    
    @objc private func calendarButtonTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalendarView")
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .coverVertical
        self.present(vc!, animated: true, completion: nil)
    }
    
    @objc private func weightButtonTapped() {
        if plus {
            weightButton.backgroundColor = .red
            plus = false
        } else {
            weightButton.backgroundColor = .blue
            plus = true
        }
    }
    
    @objc private func setButtonTapped() {
        
        if exerciseAll["유산소"]!.contains(nowExerciseType) {
            if plus {
                setCount += 1
                setButton.setTitle("\(setCount) 분", for: .normal)
            } else {
                if setCount <= 0 {
                    setCount = 0
                    setButton.setTitle("\(setCount) 분", for: .normal)
                } else {
                    setCount -= 1
                    setButton.setTitle("\(setCount) 분", for: .normal)
                }
                
            }
            
        } else {
            if plus {
                setCount += 1
                setButton.setTitle("\(setCount) 회", for: .normal)
            } else {
                if setCount <= 0 {
                    setCount = 0
                    setButton.setTitle("\(setCount) 회", for: .normal)
                } else {
                    setCount -= 1
                    setButton.setTitle("\(setCount) 회", for: .normal)
                }
                
            }

        }
        
    }
    
    @objc private func nowExTypeButtonTapped() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExerciseListView")
        vc!.modalPresentationStyle = .fullScreen
        present(vc!, animated: true, completion: nil)
        
        /*
        let alert = UIAlertController(title: "운동 종류", message: "어떤 운동을 했는지 선택해주세요", preferredStyle: .alert)
        
        for i in 0..<exerciseTypes.count {
            let exType = exerciseTypes[i]
            alert.addAction(UIAlertAction(title: exType, style: .default, handler: { _ in
                nowExerciseType = exType
                self.nowExTypeButton.setTitle(exType, for: .normal)
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
        */
        
    }
    
    @objc private func fiveKiloBarbellButtonTapped() {
        if plus {
            weightCount += 5
            weightLable.text = "\(weightCount) kg"
        } else {
            if weightCount - 5 < 0 {
                weightCount = 0
                weightLable.text = "\(weightCount) kg"
            } else {
                weightCount -= 5
                weightLable.text = "\(weightCount) kg"
            }
        }
    }
    
    @objc private func tenKiloBarbellButtonTapped() {
        if plus {
            weightCount += 10
            weightLable.text = "\(weightCount) kg"
        } else {
            if weightCount - 10 < 0 {
                weightCount = 0
                weightLable.text = "\(weightCount) kg"
            } else {
                weightCount -= 10
                weightLable.text = "\(weightCount) kg"
            }
        }
    }
    
    @objc private func twentyKiloBarbellButtonTapped() {
        if plus {
            weightCount += 20
            weightLable.text = "\(weightCount) kg"
        } else {
            if weightCount - 20 < 0 {
                weightCount = 0
                weightLable.text = "\(weightCount) kg"
            } else {
                weightCount -= 20
                weightLable.text = "\(weightCount) kg"
            }
        }
    }
    
    
    @objc private func recordButtonTapped () {
        
        if nowExerciseType == "운동 종류" {
            let alert = UIAlertController(title: "", message: "운동 종류를 선택해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in
                
            }))
            self.present(alert, animated: true, completion: nil)
            return
            
        } else if setCount == 0 {
            let alert = UIAlertController(title: "", message: "횟수를 설정해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        

        intervalTimeField.text = String(intervalTime)
        
        
        print(exerciseHistory)
        
    
        
        // 주간

        let y = String(cur_date.split(separator: "-")[0])
        let m = String(cur_date.split(separator: "-")[1])
        let d = String(cur_date.split(separator: "-")[2])
        
        var newList = exerciseTypesDataStorage[nowExerciseType]
        
        
        
        if onlyTime.contains(nowExerciseType){
            newList?.append(setCount)
            calories += Double(setCount) * Double(5)
            calorieLabel.text = "소비된 칼로리 : \(doubleConvertToString(number: calories))Kcal"
            exerciseHistory.append(nowExerciseType + ":\(setCount) 분")
        } else if onlyCount.contains(nowExerciseType) {
            newList?.append(setCount)
            calories += Double(setCount) * 0.4
            calorieLabel.text = "소비된 칼로리 : \(doubleConvertToString(number: calories))Kcal"
            exerciseHistory.append(nowExerciseType + ":\(setCount) 회")
        }
        else {
            newList?.append(weightCount)
            calories += Double(setCount) * 0.4
            volumes += setCount * weightCount
            calorieLabel.text = "소비된 칼로리: \(doubleConvertToString(number: calories))Kcal"
            exerciseHistory.append(nowExerciseType + ":\(weightCount) kg" + " \(setCount) 회")
        }
        
        db.child(p_id).child(cur_date).child("history").setValue(exerciseHistory)
        
        exerciseTypesDataStorage[nowExerciseType] = newList!
        db.child(p_id).child("chart").child(nowExerciseType).child("주간").child(y).child(m).child(d).setValue(newList!)
       
        
        // 볼륨 , 칼로리 저장
        db.child(p_id).child(cur_date).child("volumes").setValue(volumes)
        db.child(p_id).child(cur_date).child("calories").setValue(calories)
        
 
        historyTable.reloadData()

        
        setButton.setTitle("\(setCount) 회", for: .normal)
        weightLable.text = "\(weightCount) kg"

        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        
        instructionButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(instructionButton)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.size.equalTo(CGSize(width: 50, height: 30))
        }
        
        nowDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(instructionButton).offset(35)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSize(width: 150, height: 40))
        }
        
        calorieLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nowDateLabel).offset(35)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSize(width: 200, height: 40))
        }
        
//        nowDateLabel.frame = CGRect(x: self.view.bounds.maxX/2-70, y: instructionButton.frame.origin.y+50, width: 150, height: 50)
//        calorieLabel.frame = CGRect(x: self.view.bounds.maxX/2-100, y: nowDateLabel.frame.origin.y+50, width: 200, height: 50)
        
        calendarButton.snp.makeConstraints { (make) in
            make.top.equalTo(nowDateLabel)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-30)
            make.size.equalTo(CGSize(width: 50, height: 30))
        }
        
        memoButton.snp.makeConstraints { (make) in
            make.top.equalTo(calorieLabel)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-30)
            make.size.equalTo(CGSize(width: 50, height: 30))
        }
        
        historyTable.snp.makeConstraints { (make) in
            make.top.equalTo(calorieLabel).offset(60)
            make.height.equalTo(250)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(50)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-50)
        }
        
        
//        historyTable.frame = CGRect(x: 50 , y: calorieLabel.frame.origin.y + 70, width: view.frame.size.width-100, height: 250 )
//        calendarButton.frame = CGRect(x: 350, y: 100, width: 50, height: 30)
//        memoButton.frame = CGRect(x: calendarButton.frame.origin.x,
//                                  y: calendarButton.frame.origin.y+50,
//                                  width:  50,
//                                  height: 30)
        
        moveViewButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view)
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(0)
        }
    
        recordButton.frame = CGRect(x: self.view.bounds.maxX-70, y: nowDateLabel.frame.origin.y+390, width: 50, height: 50)
        nowExTypeButton.frame = CGRect(x: self.view.bounds.maxX/2-100, y: nowDateLabel.frame.origin.y+390, width: 200, height: 50)
        
        
        weightButton.frame = CGRect(x: self.view.bounds.maxX-40, y: nowExTypeButton.frame.origin.y+90, width: 20, height: 20)
        
        
        fiveKiloBarbellButton.frame = CGRect(x: 30, y: nowExTypeButton.frame.origin.y+140, width: 80, height: 80)
        tenKiloBarbellButton.frame = CGRect(x: fiveKiloBarbellButton.frame.origin.x+150, y: nowExTypeButton.frame.origin.y+140, width: 80, height: 80)
        twentyKiloBarbellButton.frame = CGRect(x: tenKiloBarbellButton.frame.origin.x+150, y: weightLable.frame.origin.y+60, width: 80, height: 80)
        counter.frame = CGRect(x: fiveKiloBarbellButton.frame.origin.x+45, y: tenKiloBarbellButton.frame.origin.y + 100, width: 110, height: 110)
        
        intervalTimeField.frame = CGRect(x: fiveKiloBarbellButton.frame.origin.x+60, y: tenKiloBarbellButton.frame.origin.y + 140, width: 80, height: 30)
        intervalAlertButton.frame = CGRect(x: intervalTimeField.frame.origin.x+100, y: tenKiloBarbellButton.frame.origin.y + 140, width: 50, height: 40)
        
        counterPauseButton.frame = CGRect(x: intervalTimeField.frame.origin.x+150, y: tenKiloBarbellButton.frame.origin.y + 140, width: 60, height: 40)
        counterResumeButton.frame = CGRect(x: intervalTimeField.frame.origin.x+150, y: tenKiloBarbellButton.frame.origin.y + 140, width: 60, height: 40)
        counterResetButton.frame = CGRect(x: intervalTimeField.frame.origin.x+220, y: tenKiloBarbellButton.frame.origin.y + 140, width: 50, height: 40)
        
        
    }
    
    func updateExerciseDataStorage(to: [Int], key: String) {
        exerciseTypesDataStorage[key] = to
    }
    
    private func breakEndPopup() {
        
        
        let content = UNMutableNotificationContent()
        content.title = "쉬는 시간 끝!!"
        content.body = "운동을 다시 시작해주세요!!"
        content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 10.0)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(1), repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        noti.add(request) {error in
            guard error == nil else {
                
                return
            }
        }
        
    }

}

extension ExerciseRecordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return exerciseHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = exerciseHistory[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
   
            if exerciseHistory[indexPath.row].contains("휴식") {
                
                exerciseHistory.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                db.child(p_id).child(cur_date).child("history").setValue(exerciseHistory)
                
            } else {
                
                let type = String(exerciseHistory[indexPath.row].split(separator: ":")[0])
                let explain = exerciseHistory[indexPath.row].split(separator: ":")[1]
                
                let selectedWeight: Int = Int(explain.split(separator: " ")[0])!
                
                
                if onlyTime.contains(type) {
                    
                    calories -= Double(selectedWeight) * Double(5)
                    calorieLabel.text = "소비된 칼로리 : \(doubleConvertToString(number: calories))Kcal"
                } else if onlyCount.contains(type) {
                    calories -= Double(selectedWeight) * 0.4
                    calorieLabel.text = "소비된 칼로리 : \(doubleConvertToString(number: calories))Kcal"
  
                }
                else {
                    let selectedSetCounts: Int = Int(explain.split(separator: " ")[2])!
                    calories -= Double(selectedSetCounts) * 0.4
                    volumes -= selectedWeight * selectedSetCounts
                    calorieLabel.text = "소비된 칼로리 : \(doubleConvertToString(number: calories))Kcal"
                }
                
                var newList = exerciseTypesDataStorage[type]!
                let idx = newList.firstIndex(of: selectedWeight)!

                newList.remove(at: idx)
                exerciseTypesDataStorage[type] = newList
                
                let y = String(cur_date.split(separator: "-")[0])
                let m = String(cur_date.split(separator: "-")[1])
                let d = String(cur_date.split(separator: "-")[2])
                
                db.child(p_id).child("chart").child(type).child("주간").child(y).child(m).child(d).setValue(newList)
                
                
                exerciseHistory.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                db.child(p_id).child(cur_date).child("history").setValue(exerciseHistory)
                
                db.child("\(p_id)/\(cur_date)/calories").setValue(calories)
                db.child("\(p_id)/\(cur_date)/volumes").setValue(volumes)
                
                
            }
 
            
            tableView.endUpdates()
        }
    }
    
}

// 텍스트 필드에 숫자만 입력되게 함
extension ExerciseRecordViewController: UITextFieldDelegate, SRCountdownTimerDelegate, CoachMarksControllerDelegate, CoachMarksControllerDataSource {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 백스페이스 감지
        guard !string.isEmpty else {

               return true
           }
        // 숫자만 가능하게
        if let _ = string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) {
            return true
        } else {
            return false
        }
    }
    
    func timerDidEnd(sender: SRCountdownTimer, elapsedTime: TimeInterval) {
        
        if !tappedReset {
            breakEndPopup()
            
            exerciseHistory.append( "휴식" + " \(timeToString(time: intervalTime))")
            historyTable.reloadData()
            db.child(p_id).child(cur_date).child("history").setValue(exerciseHistory)
        }
        tappedReset = false
        intervalTimeField.isHidden = false
        intervalAlertButton.isHidden = false
        counter.reset()
        counterPauseButton.isHidden = true
        counterResumeButton.isHidden = true
        counterResetButton.isHidden = true
        
    }
    
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return coachDatas.count
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        return coachMarksController.helper.makeCoachMark(for: coachDatas[index].View)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        
        let coachView = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        switch index {
        case 13:
            intervalAlertButton.isHidden = true
            counterPauseButton.isHidden = false
            counterResetButton.isHidden = false
            coachView.bodyView.hintLabel.text = coachDatas[index].bodyText
            coachView.bodyView.nextLabel.text = coachDatas[index].nextText
            
        case 14:
            intervalAlertButton.isHidden = true
            counterPauseButton.isHidden = true
            counterResumeButton.isHidden = false
            coachView.bodyView.hintLabel.text = coachDatas[index].bodyText
            coachView.bodyView.nextLabel.text = coachDatas[index].nextText
        case 15:
            intervalAlertButton.isHidden = true
            counterPauseButton.isHidden = false
            counterResumeButton.isHidden = true
            coachView.bodyView.hintLabel.text = coachDatas[index].bodyText
            coachView.bodyView.nextLabel.text = coachDatas[index].nextText
        case 16:
            intervalAlertButton.isHidden = false
            counterResetButton.isHidden = true
            counterResumeButton.isHidden = true
            counterPauseButton.isHidden = true
            
            
        default:
            coachView.bodyView.hintLabel.text = coachDatas[index].bodyText
            coachView.bodyView.nextLabel.text = coachDatas[index].nextText
        }
        
        return (bodyView: coachView.bodyView, arrowView: coachView.arrowView)
        
    }
    
}


