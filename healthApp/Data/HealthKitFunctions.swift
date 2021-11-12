//
//  HealthKitFunctions.swift
//  healthApp
//
//  Created by hong on 2021/11/10.
//
import UIKit
import HealthKit
import FirebaseDatabase


var healthStore = HKHealthStore()

private let db = Database.database().reference()


func healthAuth(Year:Int, Month: Int, Date: Int) {
        let share = Set([HKCategoryType.quantityType(forIdentifier: .stepCount)!])
        let read = Set([HKCategoryType.quantityType(forIdentifier: .stepCount)!])
        
        healthStore.requestAuthorization(toShare: share, read: read) { (check,error) in
            guard error == nil else {
                return
            }
            
            if check {
                getSteps(Year: Year, Month: Month, Date: Date)
                
                                    
            } else {
   
            }
        }
    }
    
func getSteps(Year: Int, Month: Int, Date: Int) {
        
    guard let sampleType = HKCategoryType.quantityType(forIdentifier: .stepCount) else {return }
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    let DateStirng1 = "\(Year)-\(Month)-\(Date) 00:00:00"
    let DateStirng2 = "\(Year)-\(Month)-\(Date) 23:59:59"
    let endDate = dateformatter.date(from: DateStirng2)!
    let startDate = dateformatter.date(from: DateStirng1)!
 
    
  //  let startDate = Calendar.current.startOfDay(for: day)
        
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
                   
                    if logined {
                        db.child(p_id).child("chart").child("워킹").child("주간").child(String(Year)).child(String(format: "%02d", Month)).child((String(format: "%02d", Date))).setValue([Int(val)])
                    }

                        
                } else {
                    UserDefaults.standard.setValue(0, forKey: "steps")
                    
                    if logined{
                        db.child(p_id).child("chart").child("워킹").child("주간").child(String(Year)).child(String(format: "%02d", Month)).child((String(format: "%02d", Date))).setValue([0])
                        
                    }

 
                }
            }
        }
    }
    healthStore.execute(query)
        
        
}

