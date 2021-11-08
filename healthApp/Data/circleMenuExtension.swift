//
//  circleMenuExtension.swift
//  healthApp
//
//  Created by hong on 2021/11/08.
//

import CircleMenu


// 원 메뉴 딜리게이트

extension HomeController: CircleMenuDelegate {
    

    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
       button.setImage(UIImage(named: viewItems[atIndex].icon), for: .normal)
       button.backgroundColor = viewItems[atIndex].color
    }
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: viewItems[atIndex].viewName)
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .coverVertical
        self.present(vc!, animated: true, completion: nil)
        
        print(atIndex)
    }

    
}


extension ExerciseRecordViewController: CircleMenuDelegate {
    

    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
       button.setImage(UIImage(named: viewItems[atIndex].icon), for: .normal)
       button.backgroundColor = viewItems[atIndex].color
    }
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: viewItems[atIndex].viewName)
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .coverVertical
        self.present(vc!, animated: true, completion: nil)
        
        print(atIndex)
    }

    
}


extension persnalInfoViewController: CircleMenuDelegate {
    

    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
       button.setImage(UIImage(named: viewItems[atIndex].icon), for: .normal)
       button.backgroundColor = viewItems[atIndex].color
    }
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: viewItems[atIndex].viewName)
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .coverVertical
        self.present(vc!, animated: true, completion: nil)
        
        print(atIndex)
    }

    
}

extension ChartViewController: CircleMenuDelegate {
    

    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
       button.setImage(UIImage(named: viewItems[atIndex].icon), for: .normal)
       button.backgroundColor = viewItems[atIndex].color
    }
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: viewItems[atIndex].viewName)
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .coverVertical
        self.present(vc!, animated: true, completion: nil)
        
        print(atIndex)
    }

    
}

extension RecordViewController: CircleMenuDelegate {
    

    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
       button.setImage(UIImage(named: viewItems[atIndex].icon), for: .normal)
       button.backgroundColor = viewItems[atIndex].color
    }
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: viewItems[atIndex].viewName)
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .coverVertical
        self.present(vc!, animated: true, completion: nil)
        
        print(atIndex)
    }

    
}
