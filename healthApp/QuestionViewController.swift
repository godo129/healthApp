//
//  QuestionViewController.swift
//  healthApp
//
//  Created by hong on 2021/10/29.
//

import UIKit
import WebKit

class QuestionViewController: UIViewController {
    
    let ExerciseView = WKWebView()
    
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
            
            //태그 값 주기
            ExerciseButton.tag = i
            ExerciseButton.addTarget(self, action: #selector(ExerciseButtonTapped1(sender: )), for: .touchUpInside)


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
    
    @objc func ExerciseButtonTapped1(sender: UIButton){
        
        // 버튼 마다 태그 값 받아서 유투브 검색창에 쿼리 값 넣어 줘서 버튼 마다 다른 뷰 주기
        let idx = sender.tag

        
        //back, forward , 원래 화면으로 돌아가는 버튼 만들어서 넣어주기
        let goBackButton = UIButton(frame: CGRect(x: 0, y: view.frame.maxY-90, width: view.frame.width/3, height: 100))
        goBackButton.setTitle("Back", for: .normal)
        goBackButton.setTitleColor(.black, for: .normal)
        goBackButton.backgroundColor = .systemPink
        goBackButton.addTarget(self, action: #selector(goBackButtonTapped), for: .touchUpInside)
        
        let goForwardButton = UIButton(frame: CGRect(x: view.frame.width/3, y: view.frame.maxY-90, width: view.frame.width/3, height: 100))
        goForwardButton.setTitle("Forward", for: .normal)
        goForwardButton.setTitleColor(.black, for: .normal)
        goForwardButton.backgroundColor = .systemBlue
        goForwardButton.addTarget(self, action: #selector(goForwardButtonTapped), for: .touchUpInside)
        
        let returnButton = UIButton(frame: CGRect(x: view.frame.width/3*2, y: view.frame.maxY-90, width: view.frame.width/3, height: 100))
        returnButton.setTitle("return", for: .normal)
        returnButton.setTitleColor(.black, for: .normal)
        returnButton.backgroundColor = .gray
        returnButton.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        
        ExerciseView.addSubview(goBackButton)
        ExerciseView.addSubview(goForwardButton)
        ExerciseView.addSubview(returnButton)
        
        
        // 웹뷰 url 연결
        ExerciseView.frame = view.bounds
        let url = "https://www.youtube.com/results?search_query="+exerciseTypes[idx]
        // 한글 가능
        let encodingUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        ExerciseView.load(URLRequest(url: URL(string: encodingUrl)!))
                          
        view.addSubview(ExerciseView)
    
    }
    
    @objc private func goBackButtonTapped(){
        ExerciseView.goBack()
    }
    
    @objc private func goForwardButtonTapped() {
        ExerciseView.goForward()
    }
    
    @objc private func returnButtonTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuestionView")
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .coverVertical
        self.present(vc!, animated: true, completion: nil)
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


