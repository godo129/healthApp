//
//  ChartViewController.swift
//  healthApp
//
//  Created by hong on 2021/11/01.
//

import UIKit
import Charts
import FirebaseDatabase
import CircleMenu
import SideMenu
import Instructions



var lists: [Int] = []
var candi: [Int] = []

var fromChart = true

var tags = 0

class ChartViewController: UIViewController, ChartViewDelegate {
    
    var oneMore = true
    
    
    private var coachMarksController = CoachMarksController()

    private let instructionButton: UIButton = {
            
        let instructionButton = UIButton()
        instructionButton.setImage(UIImage(named: "what"), for: .normal)
        instructionButton.frame = CGRect(x: 200, y: 40, width: 30, height: 30)
            
        return instructionButton
            
    }()
        
    private var coachDatas = [instructionDatas]()
    
    let moveViewButton = CircleMenu(
      frame: CGRect(x: 380, y: 100, width: 50, height: 50),
      normalIcon:"bar",
      selectedIcon:"close",
      buttonsCount: 8,
      duration: 1,
      distance: 100)
    
    var candiDates: [String] = []
    
    var db = Database.database().reference()
    
    var selectedYear = 2021
    var selectedAct = "주간"
    var selectedType = exerciseTypes[0]
    var month:[String:Int] = [:]
    var week:[String:Int] = [:]
    var selectedWeek = "9-16" + " ~ " + "9-23"

    let months = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    let months2 = ["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"]
    
    
    
    let chart = LineChartView()
    
    private let backButton: UIButton = {
        let backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
        return backButton
    }()
    
    private let yearButton: UIButton = {
        let yearButton = UIButton()
        yearButton.setTitleColor(.black, for: .normal)
        return yearButton
    }()
    
    private let monthOrWeekButton: UIButton = {
        let monthOrWeekButton = UIButton()
        monthOrWeekButton.setTitleColor(.black, for: .normal)
        return monthOrWeekButton
    }()
    
    private let selectTypeButton: UIButton = {
        let selectTypeButton = UIButton()
        selectTypeButton.setTitleColor(.black, for: .normal)

        return selectTypeButton
    }()
    
    private let candiWeeksButton: UIButton = {
        let candiWeeksButton = UIButton()
        candiWeeksButton.setTitleColor(.black, for: .normal)
        return candiWeeksButton
    }()
    
    private let candiWeeksForward: UIButton = {
        let candiWeeksForward = UIButton()
        candiWeeksForward.backgroundColor = .clear
        candiWeeksForward.contentMode = .scaleAspectFit
        candiWeeksForward.setImage(UIImage(named: "rightArrow"), for: .normal)
        return candiWeeksForward
    }()
    
    private let candiWeeksBack: UIButton = {
        let candiWeeksBack = UIButton()
        candiWeeksBack.backgroundColor = .clear
        candiWeeksBack.contentMode = .scaleAspectFit
        candiWeeksBack.setImage(UIImage(named: "leftArrow"), for: .normal)
        return candiWeeksBack
    }()
    
    private let conformButton: UIButton = {
        let conformButton = UIButton()
        conformButton.setTitleColor(.white, for: .normal)
        conformButton.setTitle("확인", for: .normal)
        conformButton.setTitleColor(.black, for: .normal)
        conformButton.backgroundColor = .white
        conformButton.layer.borderColor = UIColor.orange.cgColor
        conformButton.layer.borderWidth = 2
        return conformButton
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backButton)
        view.addSubview(yearButton)
        view.addSubview(monthOrWeekButton)
        view.addSubview(selectTypeButton)
        view.addSubview(candiWeeksButton)
        view.addSubview(conformButton)
        view.addSubview(candiWeeksForward)
        view.addSubview(candiWeeksBack)
        
        moveViewButton.delegate = self
        view.addSubview(moveViewButton)
        
        chart.delegate = self
        chart.noDataText = "데이터가 없습니다"
        
        //사이드 메뉴 옵션
        sideBar.leftSide = true
        SideMenuManager.default.addPanGestureToPresent(toView: view.self)
        SideMenuManager.default.leftMenuNavigationController = sideBar
        sideBar.isNavigationBarHidden = true
        candiWeeksBack.isHidden = true
        candiWeeksForward.isHidden = true

        sideBar.menuWidth = 300
        
        yearButton.setTitle("\(selectedYear)년", for: .normal)
        monthOrWeekButton.setTitle(selectedAct, for: .normal)
        selectTypeButton.setTitle(selectedType, for: .normal)
        
        
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
        

        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        yearButton.addTarget(self, action: #selector(yearButtonTapped), for: .touchUpInside)
        monthOrWeekButton.addTarget(self, action: #selector(monthOrWeekButtonTapped), for: .touchUpInside)
        selectTypeButton.addTarget(self, action: #selector(selectTypeButtonTapped), for: .touchUpInside)
        conformButton.addTarget(self, action: #selector(conformButtonTapped), for: .touchUpInside)
        candiWeeksButton.addTarget(self, action: #selector(candiWeeksButtonTapped), for: .touchUpInside)
        candiWeeksForward.addTarget(self, action: #selector(candiWeeksForwardTapped), for: .touchUpInside)
        candiWeeksBack.addTarget(self, action: #selector(candiWeeksBackTapped), for: .touchUpInside)
        
        // 워킹 관련된 
        fromChart = true
        
        if selectedAct == "주간" {
            
            // 주간 날짜들 만들기
            if isCommon(year: self.selectedYear) {
                self.candiDates = generateWeeks(commonOrLeap: commonYear, selectedYear: self.selectedYear)
            } else {
                self.candiDates = generateWeeks(commonOrLeap: leapYear, selectedYear: self.selectedYear)
            }
            
            self.candiWeeksButton.setTitle(self.candiDates[tags], for: .normal)
            self.conformButton.tag = tags
            
            candiWeeksButton.isHidden = false
            candiWeeksForward.isHidden = false
            candiWeeksBack.isHidden = false
            
        } else {
            
            candiWeeksButton.isHidden = true
            candiWeeksForward.isHidden = true
            candiWeeksBack.isHidden = true
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
      
        selectedType = nowExerciseType
        
        selectTypeButton.setTitle("\(selectedType)", for: .normal)
        
        
        
    }
    
    private func fillCoachDatas() {
            
            let item1 = instructionDatas(View: yearButton, bodyText: "년도를 고를 수 있습니다", nextText: "다음")
            coachDatas.append(item1)
            let item2 = instructionDatas(View: selectTypeButton, bodyText: "운동 종류를 고르는 버튼입니다", nextText: "다음")
            coachDatas.append(item2)
            let item3 = instructionDatas(View: monthOrWeekButton, bodyText: "월간이나 주간 기록을 볼 범위를 고르는 버튼입니다", nextText: "다음")
            coachDatas.append(item3)
            let item4 = instructionDatas(View: candiWeeksButton, bodyText: "주간을 고를 수 있습니다", nextText: "다음")
            coachDatas.append(item4)
            let item5 = instructionDatas(View: candiWeeksBack, bodyText: "저번주로 갈 수 있습니다", nextText: "다음")
            coachDatas.append(item5)
        
            let item6 = instructionDatas(View: candiWeeksForward, bodyText: "다음주로 갈 수 있습니다", nextText: "다음")
            coachDatas.append(item6)
            let item7 = instructionDatas(View: conformButton, bodyText: "이 버튼을 누르면 선택한 기간의 기록을 볼 수 있습니다", nextText: "다음")
            coachDatas.append(item7)
            let item8 = instructionDatas(View: chart, bodyText: "이곳에 기록에 관한 차트가 나옵니다", nextText: "다음")
            coachDatas.append(item8)
            let item9 = instructionDatas(View: moveViewButton, bodyText: "다른 뷰로 갈 수 있는 버튼입니다", nextText: "다음")
            coachDatas.append(item9)
            
            
        }
        
    @objc private func instructionButtonTapped() {
            
        coachMarksController.start(in: .window(over: self))
            
    }

    
    
    
    @objc private func backButtonTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeView")
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .coverVertical
        present(vc!, animated: true, completion: nil)
    }
    
    @objc private func yearButtonTapped() {
        
        let alert = UIAlertController(title: "", message: "년도를 선택해주세요", preferredStyle: .alert)
        for n in 2018...2021 {
            alert.addAction(UIAlertAction(title: "\(n)년", style: .default, handler: { _ in
                self.selectedYear = n
                self.yearButton.setTitle("\(self.selectedYear)년", for: .normal)
            }))
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc private func monthOrWeekButtonTapped() {
        
        let alert = UIAlertController(title: "", message: "주기를 선택해주세요", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "월간", style: .default, handler: { _ in
            self.selectedAct = "월간"
            self.monthOrWeekButton.setTitle("월간", for: .normal)
            self.candiWeeksButton.isHidden = true
            self.candiWeeksForward.isHidden = true
            self.candiWeeksBack.isHidden = true
        }))
        alert.addAction(UIAlertAction(title: "주간", style: .default, handler: { _ in
            self.selectedAct = "주간"
            self.monthOrWeekButton.setTitle("주간", for: .normal)
            self.candiWeeksButton.isHidden = false
            self.candiWeeksForward.isHidden = false
            self.candiWeeksBack.isHidden = false
            
            
            self.candiDates = []
            
            
            // 주간 날짜들 만들기
            if isCommon(year: self.selectedYear) {
                self.candiDates = generateWeeks(commonOrLeap: commonYear, selectedYear: self.selectedYear)
            } else {
                self.candiDates = generateWeeks(commonOrLeap: leapYear, selectedYear: self.selectedYear)
            }
            
            
        
            let alert = UIAlertController(title: "", message: "기간을 선택해주세요", preferredStyle: .alert)
            
            for i in 0..<self.candiDates.count {
                alert.addAction(UIAlertAction(title: self.candiDates[i], style: .default, handler: { _ in
                    self.candiWeeksButton.setTitle(self.candiDates[i], for: .normal)
                    self.conformButton.tag = i
                }))
            }
            self.present(alert, animated: true, completion: nil)
            
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc private func candiWeeksButtonTapped() {
        
        // 주간 날짜들 만들기
        if isCommon(year: self.selectedYear) {
            self.candiDates = generateWeeks(commonOrLeap: commonYear, selectedYear: self.selectedYear)
        } else {
            self.candiDates = generateWeeks(commonOrLeap: leapYear, selectedYear: self.selectedYear)
        }
        

        let alert = UIAlertController(title: "", message: "기간을 선택해주세요", preferredStyle: .alert)
        
        for i in 0..<self.candiDates.count {
            alert.addAction(UIAlertAction(title: self.candiDates[i], style: .default, handler: { _ in
                self.candiWeeksButton.setTitle(self.candiDates[i], for: .normal)
                self.conformButton.tag = i
            }))
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @objc private func candiWeeksForwardTapped() {
        var idx = self.conformButton.tag
        idx = (idx+1) % self.candiDates.count
        self.candiWeeksButton.setTitle(self.candiDates[idx], for: .normal)
        self.conformButton.tag = idx
    }
    
    @objc private func candiWeeksBackTapped() {
        var idx = self.conformButton.tag
        if idx-1 < 0 {
            idx = self.candiDates.count-1
        } else {
            idx = (idx-1) % self.candiDates.count
        }
        self.candiWeeksButton.setTitle(self.candiDates[idx], for: .normal)
        self.conformButton.tag = idx
    }
    
    
    @objc private func selectTypeButtonTapped() {
        
        /*
        let alert = UIAlertController(title: "", message: "운동 선택해주세요", preferredStyle: .alert)
        for i in 0..<exerciseTypes.count {
            alert.addAction(UIAlertAction(title: "\(exerciseTypes[i])", style: .default, handler: { _ in
                self.selectedType = exerciseTypes[i]
                self.selectTypeButton.setTitle("\(self.selectedType)", for: .normal)
                
            }))
        }
        self.present(alert, animated: true, completion: nil)
 */
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExerciseListView")
        vc!.modalPresentationStyle = .fullScreen
        present(vc!, animated: true, completion: nil)
        
        
    }
    
    @objc private func conformButtonTapped(sender: UIButton) {
        
        if selectedType == "운동 종류" {
            
            let alert = UIAlertController(title: "주의", message: "운동 종류를 선택해 주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        
        var Lists: [Int] = []
        
        
        // 워킹은 저장하고 불러와서 두번 선택해야 하니 그냥 아무거나 선택했을 때 다 만들어주고 하면 그런 두번 클릭할게 처음 한번으로 다 설정 되어서
        // 그런식으로 함
     
            
            
            // 월간 가장 큰 데이터 저장
            
            if isCommon(year: selectedYear) {
                for i in 0..<12 {
           
                    for v in 1...commonYear[i] {
                        
                        db.child(p_id).child("chart").child(selectedType).child("주간").child(String(selectedYear)).child(months[i]).child("\(String(format: "%02d", Int(v)))").observeSingleEvent(of: .value) { snapshot in
                            guard let value = snapshot.value as? [Int] else {
                              
                                self.db.child(p_id).child("chart").child(self.selectedType).child("주간").child(String(self.selectedYear)).child(self.months[i]).child("\(String(format: "%02d", Int(v)))").setValue([0])
                                
                                return
                            }

                            
                        }
                        
                    }
   
                }
                
            } else {
                
                for i in 0..<12 {
                   
                    for v in 1...leapYear[i] {
                        
                        db.child(p_id).child("chart").child(selectedType).child("주간").child(String(selectedYear)).child(months[i]).child("\(String(format: "%02d", Int(v)))").observeSingleEvent(of: .value) { snapshot in
                            guard let value = snapshot.value as? [Int] else {
                              
                                self.db.child(p_id).child("chart").child(self.selectedType).child("주간").child(String(self.selectedYear)).child(self.months[i]).child("\(String(format: "%02d", Int(v)))").setValue([0])
                                return
                            }
                           
                        }
                        
                    }
   
                }
                
            }
            

        
        

        if self.selectedAct == "월간" {
            
            
            lists = []
            
     
            // 월간 가장 큰 데이터 저장
            
            if isCommon(year: selectedYear) {
                for i in 0..<12 {
                    
                    var num: Int = 0

                    for v in 1...commonYear[i] {
                        
                        db.child(p_id).child("chart").child(selectedType).child("주간").child(String(selectedYear)).child(months[i]).child("\(String(format: "%02d", Int(v)))").observeSingleEvent(of: .value) { snapshot in
                            if let value = snapshot.value as? [Int] {
                                if value.count == 0 {
                          
                                } else {
                                    if onlyCount.contains(self.selectedType) || onlyTime.contains(self.selectedType) {
                                        let number = value.reduce(0,+)
                                        
                                        num = max(num,number)
                                        
                                    }
                                    else {
  
                                        num = max(num, value.max()!)
                                    }
                                }
                            } else {
                                
                                if self.selectedType == "워킹" {
                                    healthAuth(Year: self.selectedYear, Month: Int(self.months[i])!, Date: v)
                                }
   
                            }
                            
                            if v == commonYear[i] {
                                self.db.child(p_id).child("chart").child(self.selectedType).child("월간").child(String(self.selectedYear)).child(self.months[i]).setValue(num)
                           
                            }
                        }
                        
                    }
   
                }
                
            } else {
                
                for i in 0..<12 {
                    
                    var num: Int = 0

                    for v in 1...leapYear[i] {
                        
                        db.child(p_id).child("chart").child(selectedType).child("주간").child(String(selectedYear)).child(months[i]).child("\(String(format: "%02d", Int(v)))").observeSingleEvent(of: .value) { snapshot in
                            if let value = snapshot.value as? [Int] {
                                if value.count == 0 {
                                    
                                } else {
                                    
                                    if onlyCount.contains(self.selectedType) || onlyTime.contains(self.selectedType) {
                                        
                                        let number = value.reduce(0,+)
                                        
                                        num = max(num,number)
                                    }
                                    else {
  
                                        num = max(num, value.max()!)
                                    }
  
                                }
                            } else {
                              
                                if self.selectedType == "워킹" {
                                    healthAuth(Year: self.selectedYear, Month: Int(self.months[i])!, Date: v)
                                }
                               
                                
                            }
             
                            if v == leapYear[i] {
                                self.db.child(p_id).child("chart").child(self.selectedType).child("월간").child(String(self.selectedYear)).child(self.months[i]).setValue(num)
                           
                            }
                        }
                        
                    }
   
                }
                
            }
            
            /*
            if isCommon(year: selectedYear) {
                for i in 0..<12 {
                        
                    var num: Int = 0

                    for v in 1...commonYear[i] {
                            
                        db.child(p_id).child("chart").child(selectedType).child("주간").child(String(selectedYear)).child(months[i]).child("\(String(format: "%02d", Int(v)))").observeSingleEvent(of: .value) { snapshot in
                                if let value = snapshot.value as? [Int] {
                                    
                                }
                                else {
                                    self.db.child(p_id).child("chart").child(self.selectedType).child("주간").child(String(self.selectedYear)).child(self.months[i]).child("\(String(format: "%02d", Int(v)))").setValue([0])
                                    
                                }
           
                            }
                            
                        }
       
                    }
                    
                } else {
                    
                    for i in 0..<12 {
                        
                        var num: Int = 0

                        for v in 1...leapYear[i] {
                            
                            db.child(p_id).child("chart").child(selectedType).child("주간").child(String(selectedYear)).child(months[i]).child("\(String(format: "%02d", Int(v)))").observeSingleEvent(of: .value) { snapshot in
                                if let value = snapshot.value as? [Int] {

                                } else {
                                    self.db.child(p_id).child("chart").child(self.selectedType).child("주간").child(String(self.selectedYear)).child(self.months[i]).child("\(String(format: "%02d", Int(v)))").setValue([0])
                                    
                                }
       
                    }
                    
                }
                 
            }
        }
 
 */
     
            //makingChart(datas: lists, x: months)
            
            
            
            
            for i in 0..<months.count {
                db.child(p_id).child("chart").child(selectedType).child("월간").child(String(selectedYear)).child(months[i]).observeSingleEvent(of: .value) { snapshot in
    
                    guard let value = snapshot.value as? Int else {
                        Lists.append(0)
                        return
                    }
                    Lists.append(value)
                    if i == self.months.count-1 {
                        self.makingChart(datas: Lists,x: self.months2)
                    }
                }
                
                //왜 그런지 모르겠는 데 db 찾은 정보가 리스트에 넣어도 밖에선 싹다 사라진다... ??? 왜 그러지 ??? ... 보안 이유로 database 메서드 안에서만 값이 존재
                print(lists)
            }
            

        } else {  // 주간
            
            var dataLists: [Int] = []
            var xLists: [String] = []
            
            let range = self.candiDates[conformButton.tag].split(separator: "~")

            let first = range[0]
            var firstMonth = "\(first.split(separator: "-")[0])"
            if firstMonth.count == 1 {
                firstMonth = "0"+firstMonth
            }
            let firstDate = "\(first.split(separator: "-")[1])"
            
            
            let last = range[1]
            var lastMonth = "\(last.split(separator: "-")[0])"
            if lastMonth.count == 1 {
                lastMonth = "0"+lastMonth
            }
            let lastDate = "\(last.split(separator: "-")[1])"
       
            
            //데이터 모아주기
            if firstMonth == lastMonth {
                for date in Int(firstDate)!...Int(lastDate)! {
                    xLists.append("\(firstMonth)-\(String(format: "%02d", date))")
                }
            } else {
                if firstMonth == "12" {
                    
                    for date in Int(firstDate)!...31 {
                        xLists.append("\(firstMonth)-\(String(format: "%02d", date))")
                    }
                    for date in 1...Int(lastDate)! {
                        xLists.append("01-\(String(format: "%02d", date))")
                    }
                }
                
                else {
                    
                    if isCommon(year: selectedYear) {
                        
                        for date in Int(firstDate)!...commonYear[Int(firstMonth)!-1] {
                            xLists.append("\(firstMonth)-\(String(format: "%02d", date))")
                        }
                        for date in 1...Int(lastDate)! {
                            xLists.append("\(lastMonth)-\(String(format: "%02d", date))")
                        }
                        
                    } else {
                        for date in Int(firstDate)!...leapYear[Int(firstDate)!-1] {
                            xLists.append("\(firstMonth)-\(String(format: "%02d", date))")
                        }
                        for date in 1...Int(lastDate)! {
                            xLists.append("\(lastMonth)-\(String(format: "%02d", date))")
                            
                        }

                    }
                    
                }
                
            }
            print(xLists)
            
            // 주간 차트 만들기 !!
            for idx in 0..<xLists.count {
                
                let md = xLists[idx].split(separator: "-")
                let month = "\(md[0])"
                let date = "\(md[1])"
               
                db.child(p_id).child("chart").child(selectedType).child("주간").child(String(selectedYear)).child(month).child(date).observeSingleEvent(of: .value) { snapshot in
                    
                    if let value = snapshot.value as? [Int] {
                        
                        print(value)
                        if value.count == 0 {
                            dataLists.append(0)
                        } else {
                            
                            if onlyCount.contains(self.selectedType) || onlyTime.contains(self.selectedType) {
                                
                                let num = value.reduce(0,+)
                                
                                dataLists.append(num)
                            }
                            else {

                                dataLists.append(value.max()!)
                            }
                            
                            //dataLists.append(value.max()!)
                        }
                    } else {
                      
                        if self.selectedType == "워킹" {
                            healthAuth(Year: self.selectedYear, Month: Int(month)!, Date: Int(date)!)
                           
                            
                        }
                        
                        else {
                            
                            dataLists.append(0)
                        }
                    }
                    
                    if dataLists.count == xLists.count {
                       
                        self.makingChart(datas: dataLists, x: xLists)
                    }
                }
                
            }
            
            
        }
        
        
    }
    
    
    /*
    func pr(lists: [String]) {
        // 주간 차트 만들기 !!
        for idx in 0..<lists.count {
            let md = lists[idx].split(separator: "-")
            let month = "\(md[0])"
            let date = "\(md[1])"
            healthAuth(Year: self.selectedYear, Month: Int(month)!, Date: Int(date)!)

        }
    }
 */
    

    
    
    func makingChart(datas: [Int],x: [String]) {
        
        var entries = [ChartDataEntry]()
        view.addSubview(chart)
        for i in 0..<datas.count {
            let entry = ChartDataEntry(x: Double(i), y: Double(datas[i]))
 
            entries.append(entry)
        }
        

                
        let set = LineChartDataSet(entries: entries, label: "")
        
        // 차트 디자인
        set.colors = ChartColorTemplates.joyful()
        set.drawCirclesEnabled = false
        set.valueFont = .systemFont(ofSize: 10, weight: .bold)
        set.valueTextColor = .orange
        set.setColor(.black)
        set.fill = Fill(color: .gray)
        set.fillAlpha = 0.7
        set.drawFilledEnabled = true
        

        let data = LineChartData(dataSet: set)
        chart.data = data
        
        
        // 범주 포메팅 해주기
        class ChartsFormatterKiloGram: IAxisValueFormatter {
            func stringForValue(_ value: Double, axis: AxisBase?) -> String {
                return "\(String(format: "%.1f", value))kg"
            }
            
        }
        
        class ChartsFormatterMinute: IAxisValueFormatter {
            func stringForValue(_ value: Double, axis: AxisBase?) -> String {
                return "\(String(format: "%.1f", value))분"
            }
            
        }
        
        class ChartsFormatterSteps: IAxisValueFormatter {
            func stringForValue(_ value: Double, axis: AxisBase?) -> String {
                return "\(String(format: "%.1f", value))걸음"
            }
            
        }
        
        class ChartsFormatterCounts: IAxisValueFormatter {
            func stringForValue(_ value: Double, axis: AxisBase?) -> String {
                return "\(String(format: "%.1f", value))회"
            }
            
        }
        
        
        // 좌측 차트 .. 레이블
        if nowExerciseType == "워킹" {
            chart.leftAxis.valueFormatter = ChartsFormatterSteps()
            
        }
        else if onlyTime.contains(nowExerciseType) {
            chart.leftAxis.valueFormatter = ChartsFormatterMinute()
        } else if onlyCount.contains(nowExerciseType) {
            chart.leftAxis.valueFormatter = ChartsFormatterCounts()
        }
        else {
            chart.leftAxis.valueFormatter = ChartsFormatterKiloGram()
        }
        
     
        chart.legend.enabled = false

        
        chart.xAxis.labelPosition = .bottom
        chart.rightAxis.enabled = false
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: x)
        chart.xAxis.setLabelCount(datas.count, force: true)
        chart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        chart.doubleTapToZoomEnabled = false
        
    }

    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        chart.noDataText = "데이터가 없습니다"
        chart.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width)
        chart.center = view.center
        view.addSubview(chart)
        
        
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
        
        
        
        yearButton.snp.makeConstraints { (make) in
            make.top.equalTo(instructionButton).offset(30)
            make.left.equalTo(backButton).offset(10)
            make.size.equalTo(CGSize(width: 80, height: 40))
        }
        
//        yearButton.frame = CGRect(x: 50,
//                                  y: 70,
//                                  width: 100,
//                                  height: 50)
        
        monthOrWeekButton.snp.makeConstraints { (make) in
            make.top.equalTo(instructionButton).offset(30)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSize(width: 80, height: 40))
        }
        
//        monthOrWeekButton.frame = CGRect(x: yearButton.frame.origin.x+120,
//                                         y: yearButton.frame.origin.y,
//                                         width: 100,
//                                         height: 50)
        
        selectTypeButton.snp.makeConstraints { (make) in
            make.top.equalTo(instructionButton).offset(30)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-50)
            make.size.equalTo(CGSize(width: 80, height: 40))
        }
        
//        selectTypeButton.frame = CGRect(x: monthOrWeekButton.frame.origin.x+80,
//                                        y: yearButton.frame.origin.y,
//                                        width: 200,
//                                        height: 50)
        candiWeeksBack.snp.makeConstraints { (make) in
            make.left.equalTo(backButton)
            make.top.equalTo(yearButton).offset(50)
            make.size.equalTo(CGSize(width: 30, height: 50))
        }
        
        candiWeeksButton.snp.makeConstraints { (make) in
            make.left.equalTo(candiWeeksBack).offset(30)
            make.size.equalTo(CGSize(width: 140, height: 50))
            make.top.equalTo(candiWeeksBack)
        }
        
        candiWeeksForward.snp.makeConstraints { (make) in
            make.left.equalTo(candiWeeksButton).offset(140)
            make.size.equalTo(CGSize(width: 30, height: 50))
            make.top.equalTo(candiWeeksBack)
        }
        
//        candiWeeksButton.frame = CGRect(x: yearButton.frame.origin.x,
//                                        y: yearButton.frame.origin.y+80,
//                                        width: 150,
//                                        height: 50)
        
//        candiWeeksBack.frame = CGRect(x: 20, y: candiWeeksButton.frame.origin.y, width: 30, height: 50)
//        candiWeeksForward.frame = CGRect(x: candiWeeksButton.frame.origin.x + 150, y: candiWeeksButton.frame.origin.y, width: 30, height: 50)
        
        conformButton.snp.makeConstraints { (make) in
            make.top.equalTo(candiWeeksButton)
            make.right.equalTo(selectTypeButton)
            make.size.equalTo(CGSize(width: 100, height: 50))
        }
//        conformButton.frame = CGRect(x: candiWeeksButton.frame.origin.x+240,
//                                     y: candiWeeksButton.frame.origin.y,
//                                     width: 100,
//                                     height: 50)
        
        moveViewButton.snp.makeConstraints { (make) in
            make.top.equalTo(selectTypeButton).offset(25)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
        
    }
    
    

}

extension ChartViewController: CoachMarksControllerDelegate, CoachMarksControllerDataSource {
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return coachDatas.count
    }
        
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        return coachMarksController.helper.makeCoachMark(for: coachDatas[index].View)
    }
        
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
            
        let coachView = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        switch index {
        case 3:
            candiWeeksButton.isHidden = false
            candiWeeksBack.isHidden = false
            candiWeeksForward.isHidden = false
            coachView.bodyView.hintLabel.text = coachDatas[index].bodyText
            coachView.bodyView.nextLabel.text = coachDatas[index].nextText
        case coachDatas.count-1 :
            candiWeeksButton.isHidden = true
            candiWeeksBack.isHidden = true
            candiWeeksForward.isHidden = true
            coachView.bodyView.hintLabel.text = coachDatas[index].bodyText
            coachView.bodyView.nextLabel.text = coachDatas[index].nextText
        default:
            coachView.bodyView.hintLabel.text = coachDatas[index].bodyText
            coachView.bodyView.nextLabel.text = coachDatas[index].nextText
        }
            
        return (bodyView: coachView.bodyView, arrowView: coachView.arrowView)
            
    }

    
}
