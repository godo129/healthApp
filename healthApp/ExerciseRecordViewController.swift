//
//  ExerciseRecordViewController.swift
//  healthApp
//
//  Created by hong on 2021/10/27.
//

import UIKit
import FirebaseDatabase

var history = ""
var setCount = 0
var nowExerciseType = "운동 종류"
var weightCount = 0

class ExerciseRecordViewController: UIViewController {
    
    // 추가 빼기 제어
    var plus = true
        
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
     
    private let historyLabel: UILabel = {
        var historyLabel = UILabel()
        historyLabel.textColor = .black
        historyLabel.numberOfLines = 0
        historyLabel.textAlignment = .natural
        return historyLabel
    }()
    
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
        
        
        
        view.addSubview(backButton)
        view.addSubview(memoButton)
        view.addSubview(calendarButton)
        view.addSubview(historyLabel)
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
        

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        memoButton.addTarget(self, action: #selector(memoButtonTapped), for: .touchUpInside)
        calendarButton.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        weightButton.addTarget(self, action: #selector(weightButtonTapped), for: .touchUpInside)
        setButton.addTarget(self, action: #selector(setButtonTapped), for: .touchUpInside)
        nowExTypeButton.addTarget(self, action: #selector(nowExTypeButtonTapped), for: .touchUpInside)
        fiveKiloBarbellButton.addTarget(self, action: #selector(fiveKiloBarbellButtonTapped), for: .touchUpInside)
        tenKiloBarbellButton.addTarget(self, action: #selector(tenKiloBarbellButtonTapped), for: .touchUpInside)
        twentyKiloBarbellButton.addTarget(self, action: #selector(twentyKiloBarbellButtonTapped), for: .touchUpInside)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        nowDateLabel.text = cur_date
        historyLabel.text = history
        weightLable.text = "\(weightCount) kg"
        //setLabel.text = "\(setCount) 세트"
        setButton.setTitle("\(setCount) 세트", for: .normal)
        setButton.setTitleColor(.black, for: .normal)
        
        // 시작할때 데이터 불러오기
        db.child(p_id).child(cur_date).child("history").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? String else {
                history = ""
                self.historyLabel.text = ""
                return
            }
            
            history = value
            print(value)
            self.historyLabel.text = value
        })
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
        let alert = UIAlertController(title: "운동 종류", message: "어떤 운동을 했는지 선택해주세요", preferredStyle: .alert)
        
        for i in 0..<exerciseTypes.count {
            let exType = exerciseTypes[i]
            alert.addAction(UIAlertAction(title: exType, style: .default, handler: { _ in
                nowExerciseType = exType
                self.nowExTypeButton.setTitle(exType, for: .normal)
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
        
        
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
        
        history += "\n " + "\(setCount)set " + nowExerciseType + " \(weightCount)kg"
        
        print(history)
        //let object: [String: String] = ["history" : history]
        db.child(p_id).child(cur_date).child("history").setValue(history)
        
        let y = String(cur_date.split(separator: "-")[0])
        let m = String(cur_date.split(separator: "-")[1])
        let d = String(cur_date.split(separator: "-")[2])
        
        
        // 주간, 월간 두 가지로 나눠서 이용
        // 볼륨 저장
   
        
        // 최대 무게 저장
        // 주간 3
        db.child(p_id).child("chart").child(nowExerciseType).child("주간").child(y).child(m).child(d).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? Int else {
                self.db.child(p_id).child("chart").child(nowExerciseType).child("주간").child(y).child(m).child(d).setValue(weightCount)
                return
            }
            
            if weightCount > value {
                self.db.child(p_id).child("chart").child(nowExerciseType).child("주간").child(y).child(m).child(d).setValue(weightCount)
            }
        }
        
        self.db.child(p_id).child("chart").child(nowExerciseType).child("주간").child(y).child(m).child(d).setValue(weightCount)
        
        
        
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
        
        
        historyLabel.text = history
        
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
        calendarButton.frame = CGRect(x: 350, y: 100, width: 50, height: 30)
        memoButton.frame = CGRect(x: calendarButton.frame.origin.x,
                                  y: calendarButton.frame.origin.y+50,
                                  width:  50,
                                  height: 30)
        historyLabel.frame = CGRect(x: 50,
                                    y: nowDateLabel.frame.origin.y+50,
                                    width: view.frame.size.width-70,
                                    height: 350)
        
        recordButton.frame = CGRect(x: self.view.bounds.maxX-70, y: historyLabel.frame.origin.y+350, width: 50, height: 50)
        nowExTypeButton.frame = CGRect(x: self.view.bounds.maxX/2-50, y: historyLabel.frame.origin.y+350, width: 100, height: 50)
        
        
        weightButton.frame = CGRect(x: self.view.bounds.maxX-40, y: nowExTypeButton.frame.origin.y+90, width: 20, height: 20)
        
        //setLabel.frame = CGRect(x: 50, y: nowExTypeButton.frame.origin.y+80, width: 60, height: 40)
        setButton.frame = CGRect(x: 50, y: nowExTypeButton.frame.origin.y+80, width: 60, height: 40)
        weightLable.frame = CGRect(x: self.view.bounds.maxX/2-15, y: nowExTypeButton.frame.origin.y+80, width: 100, height: 40)
        fiveKiloBarbellButton.frame = CGRect(x: 30, y: weightLable.frame.origin.y+100, width: 80, height: 80)
        tenKiloBarbellButton.frame = CGRect(x: fiveKiloBarbellButton.frame.origin.x+150, y: weightLable.frame.origin.y+100, width: 80, height: 80)
        twentyKiloBarbellButton.frame = CGRect(x: tenKiloBarbellButton.frame.origin.x+150, y: weightLable.frame.origin.y+100, width: 80, height: 80)
        
        
        
    }

}

