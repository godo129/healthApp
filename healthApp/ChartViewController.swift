//
//  ChartViewController.swift
//  healthApp
//
//  Created by hong on 2021/11/01.
//

import UIKit
import Charts
import FirebaseDatabase

class ChartViewController: UIViewController, ChartViewDelegate {
    
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
            self.candiWeeksButton.setTitle(self.selectedWeek, for: .normal)
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
    
    @objc private func conformButtonTapped() {
        
        
        if self.selectedAct == "월간" {
            
            var lists: [Int] = []
            
            
            for i in 0..<months.count {
                db.child(p_id).child("chart").child("월간").child(selectedType).child(String(selectedYear)).child(months[i]).observeSingleEvent(of: .value) { snapshot in
    
                    guard let value = snapshot.value as? Int else {
                        lists.append(0)
                        return
                    }
                    lists.append(value)
                    if lists.count == self.months.count {
                        self.makingChart(datas: lists,x: self.months)
                    }
                    print(lists)
                }
                
                //왜 그런지 모르겠는 데 db 찾은 정보가 리스트에 넣어도 밖에선 싹다 사라진다... ??? 왜 그러지 ???
                
            }

        } else {
            
            
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
        chart.xAxis.setLabelCount(months.count, force: true)
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
