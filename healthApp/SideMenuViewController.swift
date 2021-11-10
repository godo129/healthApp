//
//  SideMenuViewController.swift
//  healthApp
//
//  Created by hong on 2021/11/08.
//

import UIKit
import FirebaseStorage
import Lottie
import HealthKit


class SideMenuViewController: UIViewController {
    
    var stepsLabel: UILabel = {
        var stepsLabel = UILabel()
        stepsLabel.textColor = .white
        stepsLabel.textAlignment = .center
        return stepsLabel
    }()

    
    var healthStore = HKHealthStore()
    
    /*
    private var profileImageView: UIButton = {
        let profileImageView = UIButton()

        //버튼 형태 변환
        profileImageView.layer.cornerRadius = 95
        profileImageView.clipsToBounds = true
        return profileImageView
    }()
 */
    
    private let dogAnimation: AnimationView = {
        var dogAnimation = AnimationView()
        dogAnimation = .init(name: "runDog")
        dogAnimation.loopMode = .loop
        dogAnimation.animationSpeed = 0.7
        return dogAnimation
    }()
    
    
    let storage = Storage.storage().reference()
    
    
    private let nickLabel: UILabel = {
        let nickLabel = UILabel()
        nickLabel.textColor = .white
        nickLabel.textAlignment = .center
        return nickLabel
    }()
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.addSubview(profileImageView)
        view.addSubview(nickLabel)
        nickLabel.text = nick
        
        view.addSubview(stepsLabel)
        
        stepsLabel.text = "\(UserDefaults.standard.value(forKey: "steps")!) 걸음"
        
        

        

        
/*
        storage.child("\(p_id)/images/profileImage\(p_id).png").downloadURL { url, error in
            guard let url = url, error == nil else {
                
                profileImage = defaultPersonImage!
                
                guard let image = defaultPersonImage else {
                    return
                }
                
                guard let data = image.pngData() else {
                    return
                }
                
                self.storage.child("\(p_id)/images/profileImage\(p_id).png").putData(data)
                self.profileImageView.setImage(image, for: .normal)
                
                return
            }
            
            
            let urls = URL(string: url.absoluteString)!
            
            let task = URLSession.shared.dataTask(with: urls) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                let image = UIImage(data: data)
                
                
                
                DispatchQueue.main.sync {
                    self.profileImageView.setImage(image, for: .normal)
                    profileImage = image!
                }
            }
            task.resume()
        }
        
        */
        
        view.backgroundColor = .systemGray

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        view.addSubview(profileImageView)
        // 화면 동그랗게 


        
     //   profileImageView.setImage(profileImage, for: .normal)
        nickLabel.text = nick
        
   //     profileImageView.addTarget(self, action: #selector(profileImageViewTapped), for: .touchUpInside)
        
        
        view.addSubview(dogAnimation)
        dogAnimation.play()
        
        
        healthAuth(Year: 2021, Month: 11, Date: 10)

        }
    
    
        
        /*
        
        storage.child("\(p_id)/images/profileImage\(p_id).png").downloadURL { url, error in
            guard let url = url, error == nil else {
                
                profileImage = defaultPersonImage!
                
                guard let image = defaultPersonImage else {
                    return
                }
                
                guard let data = image.pngData() else {
                    return
                }
                
                self.storage.child("\(p_id)/images/profileImage\(p_id).png").putData(data)
                self.profileImageView.setImage(image, for: .normal)
                
                return
            }
            
            
            let urls = URL(string: url.absoluteString)!
            
            let task = URLSession.shared.dataTask(with: urls) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                let image = UIImage(data: data)
                
                
                
                DispatchQueue.main.sync {
                    self.profileImageView.setImage(image, for: .normal)
                    profileImage = image!
                }
            }
            task.resume()
        }
 */
    
    
    @objc private func profileImageViewTapped() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImageView.frame = CGRect(x: 20, y: 200, width: 260, height: 200)
        
       // profileImageView.frame = CGRect(x: 20, y: 200, width: 260, height: 200)
        nickLabel.frame = CGRect(x: 100, y: profileImageView.frame.origin.y+200, width: 100, height: 50)
        
        stepsLabel.frame = CGRect(x: 100, y: nickLabel.frame.origin.y+60, width: 100, height: 50)
        
        dogAnimation.frame = CGRect(x: 0, y: nickLabel.frame.origin.y + 70, width: view.frame.size.width, height: view.frame.size.width)
    }
    
    
    
    func healthAuth(Year:Int, Month: Int, Date: Int) {
            let share = Set([HKCategoryType.quantityType(forIdentifier: .stepCount)!])
            let read = Set([HKCategoryType.quantityType(forIdentifier: .stepCount)!])
            
            healthStore.requestAuthorization(toShare: share, read: read) { (check,error) in
                guard error == nil else {
                    return
                }
                
                if check {
                    self.getSteps(Year: Year, Month: Month, Date: Date)
                    
                                        
                }
            }
        }
        
        func getSteps(Year: Int, Month: Int, Date: Int){
            
            guard let sampleType = HKCategoryType.quantityType(forIdentifier: .stepCount) else {return }
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy년MM월dd일 HH시mm분ss초 ZZZ"
            let DateStirng1 = "\(Year)년\(Month)월\(Date)일 00시00분00초 +0000"
            let DateStirng2 = "\(Year)년\(Month)월\(Date)일 23시59분59초 +0000"
            let endDate = dateformatter.date(from: DateStirng2)!
            let startDate = dateformatter.date(from: DateStirng1)!
            //let startDate = Calendar.current.startOfDay(for: endDate)
            
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
            var interval = DateComponents()
            interval.day = 1
            
            let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: interval)
            
            query.initialResultsHandler = {
                
                query, result , error in
                
                if let myresult = result {
                    myresult.enumerateStatistics(from: startDate, to: endDate) { (statistics, value) in
                        
                        if let count = statistics.sumQuantity() {
                            let val = count.doubleValue(for: HKUnit.count())
                            
                            UserDefaults.standard.setValue(Int(val), forKey: "steps")
                            
                        } else {
                            UserDefaults.standard.setValue(0, forKey: "steps")
                        }
                    }
                }
            }
            healthStore.execute(query)
            
            
        }

    

}


