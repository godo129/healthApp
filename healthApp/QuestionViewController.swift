//
//  QuestionViewController.swift
//  healthApp
//
//  Created by hong on 2021/10/29.
//

import UIKit
import WebKit

class QuestionViewController: UIViewController {
    
    private let backButton: UIButton = {
        let backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
        
        return backButton
    }()
    
    private let TitleLabel: UILabel = {
        let TitleLabel = UILabel()
        TitleLabel.text = "운동 영상"
        TitleLabel.font = .systemFont(ofSize: 40, weight: .medium)
        return TitleLabel
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(TitleLabel)
        view.addSubview(backButton)
        
        for i in 0..<exerciseTypes.count {
            let ExerciseLabel = UILabel(frame: CGRect(x: 50,
                                                      y: Int(view.frame.maxY)/3 + 60*i,
                                                      width: 100,
                                                      height: 40))
            ExerciseLabel.text = exerciseTypes[i]
            
            let ExerciseButton = UIButton(frame: CGRect(x: ExerciseLabel.frame.origin.x+120,
                                                        y: CGFloat(Int(view.frame.maxY)/3+60*i),
                                                        width: 50,
                                                        height: 40))
            ExerciseButton.setImage(UIImage(named: "video"), for: .normal)

            ExerciseButton.addTarget(self, action: #selector(ExerciseButtonTapped1), for: .touchUpInside)
            

            
            

            view.addSubview(ExerciseLabel)
            view.addSubview(ExerciseButton)
        }

        

        
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeView")
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .coverVertical
        self.present(vc!, animated: true, completion: nil)
    }
    
    @objc func ExerciseButtonTapped1(){
        
        let ExerciseView = WKWebView()
        ExerciseView.frame = CGRect(x: 0, y: 40, width: view.frame.size.width, height: view.frame.size.height)
        let url = "https://www.youtube.com/results?search_query="+"데드리프트"
        let encodingUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        ExerciseView.load(URLRequest(url: URL(string: encodingUrl)!))
                          
        view.addSubview(ExerciseView)
        
        
        
    }
    
   
    
    override func viewDidLayoutSubviews() {
        
        backButton.frame = CGRect(x: -10,
                                  y: 35,
                                  width: view.frame.size.width-300,
                                  height: 20)
        
        TitleLabel.frame = CGRect(x: view.frame.maxX/3,
                                  y: 100,
                                  width: view.frame.size.width,
                                  height: 50)
    }
    
    
    


}


