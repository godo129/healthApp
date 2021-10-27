//
//  RecordViewController.swift
//  healthApp
//
//  Created by hong on 2021/10/26.
//

import UIKit
import FirebaseDatabase
var big: [[String: [String:String]]] = []

class RecordViewController: UIViewController {
    
    private let db = Database.database().reference()
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        return dateLabel
    } ()
    
    private let backButton: UIButton = {
        let backbutton = UIButton()
        backbutton.setTitle("Back", for: .normal)
        backbutton.backgroundColor = .orange
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
        recordButton.backgroundColor = .link

        return recordButton
    }()

    
    private let textView: UITextView = {
        let textView = UITextView()
        return textView
    }()
    
    //선택날짜
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // 메모정보 가져오기
        db.child(p_id).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String:[String:String]] else {
                return
            }
            // 정보 가져오기
            guard let date = value[cur_date] else {
                self.textView.text = ""

                return
            }
            guard let info = date["memo"] else {
                self.textView.text = ""
                return
            }
            
            self.textView.text = info
        })
        
        view.addSubview(backButton)
        view.addSubview(dateLabel)
        view.addSubview(calendarButton)
        view.addSubview(recordButton)
        view.addSubview(textView)
        
        
        calendarButton.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        dateLabel.text = cur_date
    }
    
    @objc private func calendarButtonTapped() {
        
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalendarView")
        vc?.modalPresentationStyle = .overCurrentContext
        self.present(vc!, animated: false, completion: nil)
    
    }
    
    @objc private func recordButtonTapped() {
        

        guard let memo = textView.text, !memo.isEmpty else {
            let object: [String:String] = ["memo":""]
            db.child(p_id).child(cur_date).setValue(object)
            return
        }
        
        print(db.child(p_id).child(cur_date))
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
        backButton.frame = CGRect(x: 20, y: 40, width: 50, height: 30)
        dateLabel.frame = CGRect(x: self.view.bounds.maxX/2-50, y: 100, width: 200, height: 100)
        //calendarButton.frame = CGRect(x: 350, y: 100, width: 50, height: 30)
        recordButton.frame = CGRect(x: 350, y: dateLabel.frame.origin.y+50, width: 50, height: 30)
        textView.frame = CGRect(x: 50, y: recordButton.frame.origin.y+100, width: view.frame.size.width-100, height: view.frame.size.height-400)
        
    }
}
