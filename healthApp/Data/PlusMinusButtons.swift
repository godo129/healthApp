//
//  bannerViewDatas.swift
//  healthApp
//
//  Created by hong on 2021/11/12.
//

import UIKit

let viewDatas = ["https://firebasestorage.googleapis.com/v0/b/healthapp-48bfa.appspot.com/o/banner%2F1.jpeg?alt=media&token=b8df1439-7f20-4f19-bd9c-8dd8bc006870", "https://firebasestorage.googleapis.com/v0/b/healthapp-48bfa.appspot.com/o/banner%2F2.jpeg?alt=media&token=afd61992-c0c7-4362-a56f-79ef93bed9e0","https://firebasestorage.googleapis.com/v0/b/healthapp-48bfa.appspot.com/o/banner%2F3.jpeg?alt=media&token=7c8a4684-53aa-4715-811d-d1f03e8dad25","https://firebasestorage.googleapis.com/v0/b/healthapp-48bfa.appspot.com/o/banner%2F4.jpeg?alt=media&token=3d3af61d-e22f-486a-a1f3-fa25941e4310","https://firebasestorage.googleapis.com/v0/b/healthapp-48bfa.appspot.com/o/banner%2F5.jpeg?alt=media&token=e91890f6-d360-4b0f-a717-28316ba05134"]




let plusOneButton: UIButton = {
    let plusOneButton = UIButton()
    plusOneButton.setTitle("+1", for: .normal)
    
    plusOneButton.layer.borderWidth = 2
    plusOneButton.layer.borderColor = UIColor.black.cgColor
    plusOneButton.layer.shadowColor = UIColor.black.cgColor
    plusOneButton.layer.shadowOpacity = 0.7
    plusOneButton.layer.shadowOffset = CGSize(width: 3, height: 3)
    plusOneButton.backgroundColor = .white
    plusOneButton.layer.shadowRadius = 4
    
    plusOneButton.clipsToBounds = false
    plusOneButton.setTitleColor(.black, for: .normal)
    //plusOneButton.backgroundColor = .darkGray
    return plusOneButton
}()

let plusFiveButton: UIButton = {
    let plusFiveButton = UIButton()
    plusFiveButton.setTitle("+5", for: .normal)
    plusFiveButton.setTitleColor(.black, for: .normal)
    
    plusFiveButton.layer.borderWidth = 2
    plusFiveButton.layer.borderColor = UIColor.black.cgColor
    plusFiveButton.layer.shadowColor = UIColor.black.cgColor
    plusFiveButton.layer.shadowOpacity = 0.7
    plusFiveButton.layer.shadowOffset = CGSize(width: 3, height: 3)
    plusFiveButton.backgroundColor = .white
    plusFiveButton.layer.shadowRadius = 4
    
    return plusFiveButton
}()

let plusTenButton: UIButton = {
    let plusTenButton = UIButton()
    plusTenButton.setTitle("+10", for: .normal)
    plusTenButton.setTitleColor(.black, for: .normal)
    
    plusTenButton.layer.borderWidth = 2
    plusTenButton.layer.borderColor = UIColor.black.cgColor
    plusTenButton.layer.shadowColor = UIColor.black.cgColor
    plusTenButton.layer.shadowOpacity = 0.7
    plusTenButton.layer.shadowOffset = CGSize(width: 3, height: 3)
    plusTenButton.backgroundColor = .white
    plusTenButton.layer.shadowRadius = 4
    
//    plusTenButton.backgroundColor = .darkGray
    return plusTenButton
}()

let minusOneButton: UIButton = {
    let minusOneButton = UIButton()
    minusOneButton.setTitle("-1", for: .normal)
    minusOneButton.setTitleColor(.black, for: .normal)
    
    minusOneButton.layer.borderWidth = 2
    minusOneButton.layer.borderColor = UIColor.gray.cgColor
    minusOneButton.layer.shadowColor = UIColor.black.cgColor
    minusOneButton.layer.shadowOpacity = 0.7
    minusOneButton.layer.shadowOffset = CGSize(width: 3, height: 3)
    minusOneButton.backgroundColor = .white
    minusOneButton.layer.shadowRadius = 4
    
    
    return minusOneButton
}()

let minusFiveButton: UIButton = {
    let minusFiveButton = UIButton()
    minusFiveButton.setTitle("-5", for: .normal)
    minusFiveButton.setTitleColor(.black, for: .normal)
    
    minusFiveButton.layer.borderWidth = 2
    minusFiveButton.layer.borderColor = UIColor.gray.cgColor
    minusFiveButton.layer.shadowColor = UIColor.black.cgColor
    minusFiveButton.layer.shadowOpacity = 0.7
    minusFiveButton.layer.shadowOffset = CGSize(width: 3, height: 3)
    minusFiveButton.backgroundColor = .white
    minusFiveButton.layer.shadowRadius = 4
    
    return minusFiveButton
}()

let minusTenButton: UIButton = {
    let minusTenButton = UIButton()
    minusTenButton.setTitle("-10", for: .normal)
    minusTenButton.setTitleColor(.black, for: .normal)

    minusTenButton.layer.borderWidth = 2
    minusTenButton.layer.borderColor = UIColor.gray.cgColor
    minusTenButton.layer.shadowColor = UIColor.black.cgColor
    minusTenButton.layer.shadowOpacity = 0.7
    minusTenButton.layer.shadowOffset = CGSize(width: 3, height: 3)
    minusTenButton.backgroundColor = .white
    minusTenButton.layer.shadowRadius = 4

    return minusTenButton
}()


let plusOneButtons: UIButton = {
    let plusOneButton = UIButton()
    plusOneButton.setTitle("+1", for: .normal)
    plusOneButton.setTitleColor(.black, for: .normal)
    
    plusOneButton.layer.borderWidth = 2
    plusOneButton.layer.borderColor = UIColor.black.cgColor
    plusOneButton.layer.shadowColor = UIColor.black.cgColor
    plusOneButton.layer.shadowOpacity = 0.7
    plusOneButton.layer.shadowOffset = CGSize(width: 3, height: 3)
    plusOneButton.backgroundColor = .white
    plusOneButton.layer.shadowRadius = 4
    
//    plusOneButton.backgroundColor = .darkGray
    return plusOneButton
}()

let plusFiveButtons: UIButton = {
    let plusFiveButton = UIButton()
    plusFiveButton.setTitle("+5", for: .normal)
    plusFiveButton.setTitleColor(.black, for: .normal)
    
    plusFiveButton.layer.borderWidth = 2
    plusFiveButton.layer.borderColor = UIColor.black.cgColor
    plusFiveButton.layer.shadowColor = UIColor.black.cgColor
    plusFiveButton.layer.shadowOpacity = 0.7
    plusFiveButton.layer.shadowOffset = CGSize(width: 3, height: 3)
    plusFiveButton.backgroundColor = .white
    plusFiveButton.layer.shadowRadius = 4
    
  //  plusFiveButtonh.backgroundColor = .darkGray
    return plusFiveButton
}()

let plusTenButtons: UIButton = {
    let plusTenButton = UIButton()
    plusTenButton.setTitle("+10", for: .normal)
    plusTenButton.setTitleColor(.black, for: .normal)
//    plusTenButton.backgroundColor = .darkGray
    
    plusTenButton.layer.borderWidth = 2
    plusTenButton.layer.borderColor = UIColor.black.cgColor
    plusTenButton.layer.shadowColor = UIColor.black.cgColor
    plusTenButton.layer.shadowOpacity = 0.7
    plusTenButton.layer.shadowOffset = CGSize(width: 3, height: 3)
    plusTenButton.backgroundColor = .white
    plusTenButton.layer.shadowRadius = 4
    
    return plusTenButton
}()

let minusOneButtons: UIButton = {
    let minusOneButton = UIButton()
    minusOneButton.setTitle("-1", for: .normal)
    minusOneButton.setTitleColor(.black, for: .normal)
    
    minusOneButton.layer.borderWidth = 2
    minusOneButton.layer.borderColor = UIColor.gray.cgColor
    minusOneButton.layer.shadowColor = UIColor.black.cgColor
    minusOneButton.layer.shadowOpacity = 0.7
    minusOneButton.layer.shadowOffset = CGSize(width: 3, height: 3)
    minusOneButton.backgroundColor = .white
    minusOneButton.layer.shadowRadius = 4
    
    return minusOneButton
}()

let minusFiveButtons: UIButton = {
    let minusFiveButton = UIButton()
    minusFiveButton.setTitle("-5", for: .normal)
    minusFiveButton.setTitleColor(.black, for: .normal)
    
    minusFiveButton.layer.borderWidth = 2
    minusFiveButton.layer.borderColor = UIColor.gray.cgColor
    minusFiveButton.layer.shadowColor = UIColor.black.cgColor
    minusFiveButton.layer.shadowOpacity = 0.7
    minusFiveButton.layer.shadowOffset = CGSize(width: 3, height: 3)
    minusFiveButton.backgroundColor = .white
    minusFiveButton.layer.shadowRadius = 4
    
    return minusFiveButton
}()

let minusTenButtons: UIButton = {
    let minusTenButton = UIButton()
    minusTenButton.setTitle("-10", for: .normal)
    minusTenButton.setTitleColor(.black, for: .normal)
    
    minusTenButton.layer.borderWidth = 2
    minusTenButton.layer.borderColor = UIColor.gray.cgColor
    minusTenButton.layer.shadowColor = UIColor.black.cgColor
    minusTenButton.layer.shadowOpacity = 0.7
    minusTenButton.layer.shadowOffset = CGSize(width: 3, height: 3)
    minusTenButton.backgroundColor = .white
    minusTenButton.layer.shadowRadius = 4
    
    return minusTenButton
}()
