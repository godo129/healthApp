//
//  Functions.swift
//  healthApp
//
//  Created by hong on 2021/11/02.
//


let days = ["일","월","화","수","목","금","토"]
let mons = ["01","02","03","04","05","06","07","08","09","10","11","12"]
let commonYear = [31,28,31,30,31,30,31,31,30,31,30,31,31] // 4,100 으로 나뉘는 것은 평년, 윤년 아닌 것은 평년
let leapYear = [31,29,31,30,31,30,31,31,30,31,30,31,31] // 4,100,400 으로 나뉘는 것은 윤년   4 로 나뉘는 것은 윤년
//var candiWeek: [String:String] = [:]

// 0년 1월1일 은 월요일인 것을 이용해서 계산하는 함수를 만들기

// yyyy-mm-dd 상태로 받기, /// 여기선 1월 1일 기준으로 할 꺼기 때문에 그냥 받아도 될듯 ??
func whatIsDay(yyyy: Int) -> Int {
    
    let year = yyyy - 1
    var dateCount = year * 365
    dateCount += year / 4
    dateCount -= year / 100
    dateCount += year / 400
    
    let idx = dateCount % 7 + 1
    
    return idx
}

// 윤년 평년 구하기
func isCommon(year: Int) -> Bool {
    if year % 4 != 0 {
        return true
    } else if year % 100 == 0 && year % 400 != 0 {
        return true
    } else {
        return false
    }
}


// 주간 확인 
func generateWeeks(commonOrLeap: [Int], selectedYear: Int) -> [String] {
    
    var candiDates: [String] = []
    
    let todayDay = today.split(separator: "-")
    let todayYear = Int(todayDay[0])!
    let todayMonth = Int(todayDay[1])!
    let todayDate = Int(todayDay[2])!

    
    // 맨 처음 기준
    let First = whatIsDay(yyyy: selectedYear)
    
    if First == 0 {
        
        candiDates.append("12-26~1-1")
        
        
        if selectedYear == todayYear {
            
            if todayMonth == 1 && todayDate == 1 {
                tags = 0
            }

        }
        

        
        var m_idx = 0
        // 1월 2일 부터 시작
        var date = 2
        
        while (m_idx < 12) {
            let firstMonth = m_idx + 1
            let firstDate = date
            
            var secondMonth = m_idx + 1
            var secondDate = date
            
            if firstDate + 6 > commonOrLeap[m_idx] {
                secondDate = firstDate + 6 - commonOrLeap[m_idx]
                secondMonth = firstMonth + 1
                
                m_idx += 1
                date = secondDate + 1
            }
            else {
                secondDate = firstDate + 6
                
                if secondDate + 1 > commonOrLeap[m_idx] {
                    m_idx += 1
                    date = 1
                }
                else {
                    date = secondDate + 1
                }
                
            }
            
            if selectedYear == todayYear {
                
                if firstMonth <= todayMonth && todayMonth <= secondMonth {
                    if firstMonth != secondMonth {
                        
                        if firstDate <= todayDate && secondDate+commonOrLeap[firstMonth-1] >= todayDate {
                            tags = candiDates.count
                           
                        } else if firstDate >= todayDate && secondDate >= todayDate {
                            tags = candiDates.count
                        }
                     
                } else {
                    if firstDate <= todayDate && secondDate >= todayDate {
                        tags = candiDates.count
                        print(firstMonth,firstDate,secondMonth,secondDate,"왕",todayDate)
                    }
                }
                }
            }
            
            
            // 13월 나오는 걸 1월로
            if secondMonth == 13 {
                secondMonth = 1
                
            }
            
            
            
            candiDates.append("\(String(format: "%02d", firstMonth))-\(String(format: "%02d", firstDate))~\(String(format: "%02d", secondMonth))-\(String(format: "%02d", secondDate))")
            
        }
        
    } else {
        
        var m_idx = 0
        var date = 0
        
        // 월요일부터 시작
        if First == 1 {
            m_idx = 0
            date = 0
        } else {
            let twelveDate = 31 - (First - 2)
            m_idx = 0
            date = 1 + (7 - First)
            
            
            
            // 처음
            if selectedYear == todayYear {
                
                if todayMonth == 1  {
                    if todayDate <= date {
                        tags = 0
                    }
                }
                
            }
            
            
            candiDates.append("12-\(twelveDate)~01-\(String(format: "%02d", date))")
            
        }
        
        date += 1

        while (m_idx < 12) {
            let firstMonth = m_idx + 1
            let firstDate = date
            
            var secondMonth = m_idx + 1
            var secondDate = date
            
            if firstDate + 6 > commonOrLeap[m_idx] {
                secondDate = firstDate + 6 - commonOrLeap[m_idx]
                secondMonth = firstMonth + 1
                
                m_idx += 1
                date = secondDate + 1
            }
            else {
                secondDate = firstDate + 6
                
                if secondDate + 1 > commonOrLeap[m_idx] {
                    m_idx += 1
                    date = 1
                }
                else {
                    date = secondDate + 1
                }
                
            }
            
            
            if selectedYear == todayYear {
                
                if firstMonth <= todayMonth && todayMonth <= secondMonth {
                    if firstMonth != secondMonth {
                        
                        if firstDate <= todayDate && secondDate+commonOrLeap[firstMonth-1] >= todayDate {
                            tags = candiDates.count
                           
                        } else if firstDate >= todayDate && secondDate >= todayDate {
                            tags = candiDates.count
                        }
                     
                } else {
                    if firstDate <= todayDate && secondDate >= todayDate {
                        tags = candiDates.count
                        print(firstMonth,firstDate,secondMonth,secondDate,"왕",todayDate)
                    }
                }
                }
            }
            

            
            // 13월 나오는 걸 1월로
            if secondMonth == 13 {
                secondMonth = 1
                
            }
            

            
            candiDates.append("\(String(format: "%02d", firstMonth))-\(String(format: "%02d", firstDate))~\(String(format: "%02d", secondMonth))-\(String(format: "%02d", secondDate))")
        
        }

    }
    return candiDates
}



// 분을 >> 시간분초 형태로 리턴 
func timeToString(time: Int) -> String {
    
    var h:String = ""
    var m:String = ""
    var s:String = ""
    
    var convertedTime: String = ""
    
    var times = time
    
    if times >= 3600 {
        h = "\(times/60)"
        times %= 60
        m = "\(times/60)"
        times %= 60
        s = "\(times)"
        convertedTime = "\(h)시간 \(m)분 \(s)초"
    } else if times >= 60 {
        m = "\(times/60)"
        times %= 60
        s = "\(times)"
        convertedTime = "\(m)분 \(s)초"
    } else {
        s = "\(times)"
        convertedTime = "\(s)초"
    }
    
    return convertedTime
}



func doubleConvertToString(number: Double) -> String {
    
    return String(format: "%.2f", number)
}



func isAerovic(type: String) -> Bool {
    
    if exerciseAll["유산소"]!.contains(type) {
        return true
    } else {
        return false
    }
    
}





func dayToNum(day: String) -> Int {
    
    let dateData = day.split(separator: "-")
    let year = Int(dateData[0])!
    let month = Int(dateData[1])!
    let date = Int(dateData[2])!
    
    var dates = year * 365
    dates += year/4
    dates -= year/100
    
    if isCommon(year: year) {
        if month == 1 {
            dates += date
        } else {
            for i in 0..<month {
                dates += commonYear[i]
            }
        }
    } else {
        if month == 1 {
            dates += date
        } else {
            for i in 0..<month {
                dates += leapYear[i]
            }
        }
    }
    return dates
    
}
