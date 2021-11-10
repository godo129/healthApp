//
//  HealthKitFunctions.swift
//  healthApp
//
//  Created by hong on 2021/11/10.
//
import UIKit
import HealthKit


var healthStore = HKHealthStore()


func healthAuth(Year:Int, Month: Int, Date: Int) {
        let share = Set([HKCategoryType.quantityType(forIdentifier: .stepCount)!])
        let read = Set([HKCategoryType.quantityType(forIdentifier: .stepCount)!])
        
        healthStore.requestAuthorization(toShare: share, read: read) { (check,error) in
            guard error == nil else {
                return
            }
            
            if check {
                getSteps(Year: Year, Month: Month, Date: Date)
                
                                    
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
    //let startDate = dateformatter.date(from: DateStirng1)!
 
    
    let startDate = Calendar.current.startOfDay(for: day)
        
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: day, options: .strictEndDate)
    var interval = DateComponents()
    interval.day = 1
        
    let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: interval)
        
    query.initialResultsHandler = {
            
        query, result , error in
            
        if let myresult = result {
            myresult.enumerateStatistics(from: startDate, to: day) { (statistics, value) in
                
                print(statistics)
                    
                if let count = statistics.sumQuantity() {
                    let val = count.doubleValue(for: HKUnit.count())
                        
                    UserDefaults.standard.setValue(Int(val), forKey: "steps")
                    
                    print(val)
                        
                } else {
                    UserDefaults.standard.setValue(0, forKey: "steps")
                    print(0)
                }
            }
        }
    }
    healthStore.execute(query)
        
        
}

