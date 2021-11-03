//
//  ChartViewController.swift
//  healthApp
//
//  Created by hong on 2021/11/01.
//

import UIKit
import Charts
import FirebaseDatabase


var lists: [Int] = []
var candi: [Int] = []

class ChartViewController: UIViewController, ChartViewDelegate {
    
    var candiDates: [String] = []
    
    let db = Database.database().reference()
    
    var selectedYear = 2021
    var selectedAct = "월간"
    var selectedType = exerciseTypes[0]
    var month:[String:Int] = [:]
    var week:[String:Int] = [:]
    var selectedWeek = "9-16" + " ~ " + "9-23"
    
    let test = [["1월","100"],["2월","100"],["3월","100"],["4월","113"],["5월","90.6"],["6월","100"],["7월","100"],["8월","100"],["9월","100"],["10월","100"],["11월","100"],["12월","100"]]
    
    let months = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    
    
    
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
    
    private let conformButton: UIButton = {
        let conformButton = UIButton()
        conformButton.setTitleColor(.white, for: .normal)
        conformButton.setTitle("확인", for: .normal)
        conformButton.backgroundColor = .orange
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
        
        chart.delegate = self
        chart.noDataText = "데이터가 없습니다"
        
        yearButton.setTitle("\(selectedYear)년", for: .normal)
        monthOrWeekButton.setTitle(selectedAct, for: .normal)
        selectTypeButton.setTitle(selectedType, for: .normal)

        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        yearButton.addTarget(self, action: #selector(yearButtonTapped), for: .touchUpInside)
        monthOrWeekButton.addTarget(self, action: #selector(monthOrWeekButtonTapped), for: .touchUpInside)
        selectTypeButton.addTarget(self, action: #selector(selectTypeButtonTapped), for: .touchUpInside)
        conformButton.addTarget(self, action: #selector(conformButtonTapped), for: .touchUpInside)
        
       
        
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
        }))
        alert.addAction(UIAlertAction(title: "주간", style: .default, handler: { _ in
            self.selectedAct = "주간"
            self.monthOrWeekButton.setTitle("주간", for: .normal)
            self.candiWeeksButton.isHidden = false
            
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
    
    @objc private func selectTypeButtonTapped() {
        
        let alert = UIAlertController(title: "", message: "운동 선택해주세요", preferredStyle: .alert)
        for i in 0..<exerciseTypes.count {
            alert.addAction(UIAlertAction(title: "\(exerciseTypes[i])", style: .default, handler: { _ in
                self.selectedType = exerciseTypes[i]
                self.selectTypeButton.setTitle("\(self.selectedType)", for: .normal)
                
            }))
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc private func conformButtonTapped(sender: UIButton) {

        if self.selectedAct == "월간" {
            
            var temp: [Int] = []
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
                                    num = max(num, value.max()!)
                                }
                            } else {
                                
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
                                    num = max(num, value.max()!)
                                }
                            } else {
                                
                            }
                            
                            if v == leapYear[i] {
                                self.db.child(p_id).child("chart").child(self.selectedType).child("월간").child(String(self.selectedYear)).child(self.months[i]).setValue(num)
                           
                            }
                        }
                        
                    }
   
                }
                
            }
     
            //makingChart(datas: lists, x: months)
            
            
            
            for i in 0..<months.count {
                db.child(p_id).child("chart").child(selectedType).child("월간").child(String(selectedYear)).child(months[i]).observeSingleEvent(of: .value) { snapshot in
    
                    guard let value = snapshot.value as? Int else {
                        lists.append(0)
                        return
                    }
                    lists.append(value)
                    if lists.count == self.months.count {
                        self.makingChart(datas: lists,x: self.months)
                    }
                }
                
                //왜 그런지 모르겠는 데 db 찾은 정보가 리스트에 넣어도 밖에선 싹다 사라진다... ??? 왜 그러지 ???
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
                        
                        for date in Int(firstDate)!...commonYear[Int(firstDate)!-1] {
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
                        if value.count == 0 {
                            dataLists.append(0)
                        } else {
                            dataLists.append(value.max()!)
                        }
                    } else {
                        dataLists.append(0)
                    }
        
            
                    if dataLists.count == 7 {
                        self.makingChart(datas: dataLists, x: xLists)
                    }

                }
            }
            
        }
        
    }
    

    
    func makingChart(datas: [Int],x: [String]) {
        
        var entries = [ChartDataEntry]()
        view.addSubview(chart)
        for i in 0..<datas.count {
            let entry = ChartDataEntry(x: Double(i), y: Double(datas[i]))
 
            entries.append(entry)
        }
        
        let set = LineChartDataSet(entries: entries, label: "")
        set.colors = ChartColorTemplates.material()
        let data = LineChartData(dataSet: set)
        chart.data = data
        
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
        
        
        backButton.frame = CGRect(x: 0,
                                  y: 35,
                                  width: view.frame.size.width-300,
                                  height: 20)
        
        yearButton.frame = CGRect(x: 50,
                                  y: 70,
                                  width: 100,
                                  height: 50)
        
        monthOrWeekButton.frame = CGRect(x: yearButton.frame.origin.x+120,
                                         y: yearButton.frame.origin.y,
                                         width: 100,
                                         height: 50)
        
        selectTypeButton.frame = CGRect(x: monthOrWeekButton.frame.origin.x+120,
                                        y: yearButton.frame.origin.y,
                                        width: 100,
                                        height: 50)
        
        candiWeeksButton.frame = CGRect(x: yearButton.frame.origin.x,
                                        y: yearButton.frame.origin.y+120,
                                        width: 100,
                                        height: 50)
        
        conformButton.frame = CGRect(x: candiWeeksButton.frame.origin.x+120,
                                     y: candiWeeksButton.frame.origin.y,
                                     width: 100,
                                     height: 50)
    }

}
