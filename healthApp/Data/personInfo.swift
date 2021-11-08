//
//  personInfo.swift
//  healthApp
//
//  Created by hong on 2021/10/26.
//

import  UIKit
import CircleMenu
import SideMenu



var p_id: String = ""
var cur_date: String = ""
var today : String = ""

var nick = p_id
var height = 0.0
var age = 0
var weight = 0.0

let defaultPersonImage = UIImage(named: "defaultPerson")


var profileImage: UIImage!

// 버튼 초기화 
let moveViewButton = CircleMenu(
  frame: CGRect(x: 380, y: 400, width: 50, height: 50),
  normalIcon:"bar",
  selectedIcon:"close",
  buttonsCount: 8,
  duration: 1,
  distance: 100)

// 뷰 아이템

let viewItems: [(icon: String, color: UIColor, viewName: String)] = [
    ("homeIcon", UIColor(ciColor: .clear), "HomeView"),
    ("", UIColor(ciColor: .clear), "ChartView"),
    ("", UIColor(ciColor: .clear), "ChartView"),
    ("", UIColor(ciColor: .clear), "ChartView"),
    ("chartIcon", UIColor(ciColor: .clear), "ChartView"),
    ("memoIcon", UIColor(ciColor: .clear), "RecordView"),
    ("exerciseIcon", UIColor(ciColor: .clear), "ExerciseRecordView"),
    ("personInfoIcon", UIColor(ciColor: .clear), "PersonalInfoView")
    ]
 

var sideBar = SideMenuNavigationController(rootViewController: SideMenuViewController())

