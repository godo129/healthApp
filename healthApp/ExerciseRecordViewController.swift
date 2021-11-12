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

var history = ""
var setCount = 0
var nowExerciseType = "운동 종류"
var weightCount = 0
var exerciseHistory: [String] = []


class ExerciseRecordViewController: UIViewController {
    
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
        return nowDateLabel
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
        memoButton.backgroundColor = .orange
        
        return memoButton
    }()

    
    private let calendarButton: UIButton = {
        let calendarButton = UIButton()
        calendarButton.setTitle("달력", for: .normal)
        calendarButton.backgroundColor = .blue
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
        return setLabel
    }()
    
    private var weightLable : UILabel = {
        let weightLabel = UILabel()
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
        recordButton.backgroundColor = .orange
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
        view.addSubview(setLabel)
        view.addSubview(weightLable)
        view.addSubview(weightButton)
        view.addSubview(nowExTypeButton)
        view.addSubview(fiveKiloBarbellButton)
        view.addSubview(tenKiloBarbellButton)
        view.addSubview(twentyKiloBarbellButton)
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

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        intervalAlertButton.addTarget(self, action: #selector(intervalAlertButtonTapped), for: .touchUpInside)
        memoButton.addTarget(self, action: #selector(memoButtonTapped), for: .touchUpInside)
        calendarButton.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        weightButton.addTarget(self, action: #selector(weightButtonTapped), for: .touchUpInside)
        setButton.addTarget(self, action: #selector(setButtonTapped), for: .touchUpInside)
        nowExTypeButton.addTarget(self, action: #selector(nowExTypeButtonTapped), for: .touchUpInside)
        fiveKiloBarbellButton.addTarget(self, action: #selector(fiveKiloBarbellButtonTapped), for: .touchUpInside)
        tenKiloBarbellButton.addTarget(self, action: #selector(tenKiloBarbellButtonTapped), for: .touchUpInside)
        twentyKiloBarbellButton.addTarget(self, action: #selector(twentyKiloBarbellButtonTapped), for: .touchUpInside)
        
        counterResumeButton.addTarget(self, action: #selector(counterResumeButtonTapped), for: .touchUpInside)
        counterPauseButton.addTarget(self, action: #selector(counterPauseButtonTapped), for: .touchUpInside)
        counterResetButton.addTarget(self, action: #selector(counterResetButtonTapped), for: .touchUpInside)
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        nowDateLabel.text = cur_date
       // historyLabel.text = history
        weightLable.text = "\(weightCount) kg"
        //setLabel.text = "\(setCount) 세트"
        setButton.setTitle("\(setCount) 세트", for: .normal)
        setButton.setTitleColor(.black, for: .normal)
        
        intervalTimeField.text = String(intervalTime)
        
        
        
        exerciseHistory = []
        
        exerciseTypesDataStorage = making()
        
        
        
        let y = String(cur_date.split(separator: "-")[0])
        let m = String(cur_date.split(separator: "-")[1])
        let d = String(cur_date.split(separator: "-")[2])
        
        
        // 정보 가져오기
        for i in 0..<exerciseTypes.count {
            
            let exerciseType = exerciseTypes[i]
            
            db.child(p_id).child("chart").child(exerciseType).child("주간").child(y).child(m).child(d).observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? [Int] else {
                    return
                }
                
                exerciseTypesDataStorage[exerciseType] = value
                
                UserDefaults.standard.setValue(exerciseTypesDataStorage, forKey: "exerciseTypesDataStorage")
                exerciseTypesDataStorage = UserDefaults.standard.value(forKey: "exerciseTypesDataStorage") as! [String : [Int]]
            }
                
            
        }
        print(exerciseTypesDataStorage)
        
        
        
        
        // 시작할때 데이터 불러오기
        /*db.child(p_id).child(cur_date).child("history").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? String else {
                history = ""
                self.historyLabel.text = ""
                return
            }
            
            history = value
            print(value)
            self.historyLabel.text = value
        })
 */
        
        db.child(p_id).child(cur_date).child("history").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String] else {
                let value: [String] = []
                UserDefaults.standard.setValue(value, forKey: "exerciseHistory")
                print("역사부르기오류")
                return
            }
            
            UserDefaults.standard.setValue(value, forKey: "exerciseHistory")
            exerciseHistory = UserDefaults.standard.value(forKey: "exerciseHistory") as! [String]
            self.historyTable.reloadData()
        })
        
        
        print(exerciseHistory)
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
        if plus {
            setCount += 1
            setButton.setTitle("\(setCount) 세트", for: .normal)
        } else {
            if setCount <= 0 {
                setCount = 0
                setButton.setTitle("\(setCount) 세트", for: .normal)
            } else {
                setCount -= 1
                setButton.setTitle("\(setCount) 세트", for: .normal)
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
            let alert = UIAlertController(title: "", message: "세트를 설정해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        

        intervalTimeField.text = String(intervalTime)
        
        //history += "\n " + nowExerciseType + " \(weightCount)kg" + " \(setCount)set"
        print(exerciseHistory)
        exerciseHistory.append(nowExerciseType + " \(weightCount) kg" + " \(setCount) 회")
        
        UserDefaults.standard.setValue(exerciseHistory, forKey: "exerciseHistory")
        historyTable.reloadData()

        
        
        //db.child(p_id).child(cur_date).child("history").setValue(history)
        
        db.child(p_id).child(cur_date).child("history").setValue(exerciseHistory)
        
        // 새로운 리스트, 저장
        var newList = exerciseTypesDataStorage[nowExerciseType]
        newList?.append(weightCount)
        exerciseTypesDataStorage[nowExerciseType] = newList
        print(exerciseTypesDataStorage)
        
        UserDefaults.standard.setValue(exerciseTypesDataStorage, forKey: "exerciseTypesDataStorage")
        
        
        let y = String(cur_date.split(separator: "-")[0])
        let m = String(cur_date.split(separator: "-")[1])
        let d = String(cur_date.split(separator: "-")[2])
        
        
        // 주간, 월간 두 가지로 나눠서 이용3
        // 볼륨 저장
   
        
        // 최대 무게 저장
        // 주간
        
        db.child(p_id).child("chart").child(nowExerciseType).child("주간").child(y).child(m).child(d).setValue(newList)


        // 월간 .. nowExerciseType 이 3번째 자식으로 가면 이상하게 오류 나서 불가
        db.child(p_id).child("chart").child(nowExerciseType).child("월간").child(y).child(m).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? Int else {
                self.db.child(p_id).child("chart").child(nowExerciseType).child("월간").child(y).child(m).setValue(weightCount)
                return
            }
            if weightCount > value {
                self.db.child(p_id).child("chart").child(nowExerciseType).child("월간").child(y).child(m).setValue(weightCount)

            }
        }
        
        db.child(p_id).child("chart").child(nowExerciseType).child("월간").child(y).child(m).setValue(weightCount)
        
        
        
        
       // historyLabel.text = history
        
        setCount = 0
        weightCount = 0
        nowExerciseType = "운동 종류"
        
        setButton.setTitle("\(setCount)세트", for: .normal)
        weightLable.text = "\(weightCount)kg"
        nowExTypeButton.setTitle("\(nowExerciseType)", for: .normal)
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        backButton.frame = CGRect(x: 20, y: 40, width: 50, height: 30)
        
        
        nowDateLabel.frame = CGRect(x: self.view.bounds.maxX/2-50, y: 100, width: 200, height: 100)
        historyTable.frame = CGRect(x: 50 , y: nowDateLabel.frame.origin.y + 100, width: view.frame.size.width-100, height: 300)
        calendarButton.frame = CGRect(x: 350, y: 100, width: 50, height: 30)
        memoButton.frame = CGRect(x: calendarButton.frame.origin.x,
                                  y: calendarButton.frame.origin.y+50,
                                  width:  50,
                                  height: 30)
      /*  historyLabel.frame = CGRect(x: 50,
                                    y: nowDateLabel.frame.origin.y+50,
                                    width: view.frame.size.width-70,
                                    height: 350)
      */
        recordButton.frame = CGRect(x: self.view.bounds.maxX-70, y: nowDateLabel.frame.origin.y+400, width: 50, height: 50)
        nowExTypeButton.frame = CGRect(x: self.view.bounds.maxX/2-100, y: nowDateLabel.frame.origin.y+400, width: 200, height: 50)
        
        
        weightButton.frame = CGRect(x: self.view.bounds.maxX-40, y: nowExTypeButton.frame.origin.y+90, width: 20, height: 20)
        
        //setLabel.frame = CGRect(x: 50, y: nowExTypeButton.frame.origin.y+80, width: 60, height: 40)
        setButton.frame = CGRect(x: 50, y: nowExTypeButton.frame.origin.y+80, width: 60, height: 40)
        weightLable.frame = CGRect(x: self.view.bounds.maxX/2-15, y: nowExTypeButton.frame.origin.y+80, width: 100, height: 40)
        fiveKiloBarbellButton.frame = CGRect(x: 30, y: weightLable.frame.origin.y+60, width: 80, height: 80)
        tenKiloBarbellButton.frame = CGRect(x: fiveKiloBarbellButton.frame.origin.x+150, y: weightLable.frame.origin.y+60, width: 80, height: 80)
        twentyKiloBarbellButton.frame = CGRect(x: tenKiloBarbellButton.frame.origin.x+150, y: weightLable.frame.origin.y+60, width: 80, height: 80)
        counter.frame = CGRect(x: fiveKiloBarbellButton.frame.origin.x+45, y: tenKiloBarbellButton.frame.origin.y + 100, width: 110, height: 110)
        
        intervalTimeField.frame = CGRect(x: fiveKiloBarbellButton.frame.origin.x+60, y: tenKiloBarbellButton.frame.origin.y + 140, width: 80, height: 30)
        intervalAlertButton.frame = CGRect(x: intervalTimeField.frame.origin.x+100, y: tenKiloBarbellButton.frame.origin.y + 140, width: 50, height: 40)
        
        counterPauseButton.frame = CGRect(x: intervalTimeField.frame.origin.x+150, y: tenKiloBarbellButton.frame.origin.y + 140, width: 80, height: 40)
        counterResumeButton.frame = CGRect(x: intervalTimeField.frame.origin.x+150, y: tenKiloBarbellButton.frame.origin.y + 140, width: 80, height: 40)
        counterResetButton.frame = CGRect(x: intervalTimeField.frame.origin.x+200, y: tenKiloBarbellButton.frame.origin.y + 140, width: 100, height: 40)
        
    }
    
    func updateExerciseDataStorage(to: [Int], key: String) {
        exerciseTypesDataStorage[key] = to
    }
    
    private func breakEndPopup() {
        
        /*
        guard let time = intervalTimeField.text, !time.isEmpty else {
            return
        }
        
        intervalTime = Int(time)!
        
        // 0초의 알림은 불가
        if intervalTime <= 0 {
            return
        }
       */
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
            
            if String(exerciseHistory[indexPath.row].split(separator: " ")[0]) == "휴식" {
                
                exerciseHistory.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                db.child(p_id).child(cur_date).child("history").setValue(exerciseHistory)
                
            } else {
                let selectedWeight: Int = Int(exerciseHistory[indexPath.row].split(separator: " ")[1])!
                let selectedType: String = String(exerciseHistory[indexPath.row].split(separator: " ")[0])
                guard var newList = exerciseTypesDataStorage[selectedType] else {return}
                guard let idx = newList.firstIndex(of: selectedWeight) else {return}
                newList.remove(at: idx)
                exerciseTypesDataStorage[selectedType] = newList
                print(newList)
                
                let y = String(cur_date.split(separator: "-")[0])
                let m = String(cur_date.split(separator: "-")[1])
                let d = String(cur_date.split(separator: "-")[2])
                
                db.child(p_id).child("chart").child(selectedType).child("주간").child(y).child(m).child(d).setValue(newList)
            
                
                exerciseHistory.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                db.child(p_id).child(cur_date).child("history").setValue(exerciseHistory)
                
                
            }
            
            UserDefaults.standard.setValue(exerciseTypesDataStorage, forKey: "exerciseTypesDataStorage")
            UserDefaults.standard.setValue(exerciseHistory, forKey: "exerciseHistory")
            
            
            
            
  
            print(exerciseTypesDataStorage)
            
            tableView.endUpdates()
        }
    }
    
}

// 텍스트 필드에 숫자만 입력되게 함
extension ExerciseRecordViewController: UITextFieldDelegate, SRCountdownTimerDelegate {
    
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
}


