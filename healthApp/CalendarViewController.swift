//
//  CalendarViewController.swift
//  healthApp
//
//  Created by hong on 2021/10/26.
//

import UIKit
import FSCalendar
import Foundation
import Firebase


class CalendarViewController: UIViewController,FSCalendarDataSource, FSCalendarDelegate {
 
    var t_date = ""
    
    var db = Database.database().reference()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        t_date = today
        
        // 처음 클릭 안했을 때 오류 처리 
        if t_date != cur_date {
            t_date = cur_date
        }

        
        let conformButton = UIButton(frame: CGRect(x: 370, y: 50, width: 50, height: 50))
        conformButton.setTitle("확인", for: .normal)
        conformButton.setTitleColor(.black, for: .normal)
        conformButton.backgroundColor = .yellow
        view.addSubview(conformButton)
        
        
        let calendar = FSCalendar(frame: CGRect(x: 0,
                                                y: conformButton.frame.origin.y+50 ,
                                                width: view.frame.size.width,
                                                height: view.frame.size.height-100))
        
        calendar.delegate = self
        calendar.dataSource = self
        
        
        // 선택 날짜 기준으로 나오게
        let calPosition = Calendar.current
        let year = Int(cur_date.split(separator: "-")[0])
        let month = Int(cur_date.split(separator: "-")[1])
        let date = Int(cur_date.split(separator: "-")[2])
        let selectDay = calPosition.date(from: DateComponents(year: year,month: month, day: date ))
        calendar.select(selectDay)
        
        
        // 달력 커스터 마이징
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 28)
        calendar.locale = Locale(identifier: "ko_KR")
        
        view.addSubview(calendar)
        
   
        conformButton.addTarget(self, action: #selector(conformButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if cur_date != t_date {
            setCount = 0
            weightCount = 0
        }
        cur_date = t_date
        
        let value: [String] = []
        UserDefaults.standard.setValue(value, forKey: "exerciseHistory")
        
        let emptyStorage = making()
        UserDefaults.standard.setValue(emptyStorage, forKey: "exerciseTypesDataStorage")
        
    }
    
    
    @objc private func conformButtonTapped() {
       let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExerciseRecordView")
       vc?.modalPresentationStyle = .fullScreen
       vc?.modalTransitionStyle = .coverVertical
       self.present(vc!, animated: true, completion: nil)
        //self.dismiss(animated: false, completion: nil)
        
        
    }
    
    
    // 달력에서 선택한 날짜 저장해 놓기
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            t_date = dateFormatter.string(from: date)
            print(t_date)
        }




}


