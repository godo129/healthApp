//
//  QuestionViewController.swift
//  healthApp
//
//  Created by hong on 2021/10/29.
//

import UIKit
import WebKit

class QuestionViewController: UIViewController {
    
    private var CollectionView: UICollectionView?

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
        
        
        // 스크롤뷰
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 1700)
        view.addSubview(scrollView)
        
        scrollView.addSubview(TitleLabel)
        scrollView.addSubview(backButton)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
     
       
        
        for i in 0..<exerciseParts.count {
            
            let type = exerciseParts[i]
            
            let typeText = UILabel(frame: CGRect(x: 0, y: 100+200*i, width: Int(view.frame.size.width), height: 50))
            typeText.textAlignment = .center
            typeText.text = type
            typeText.font = .systemFont(ofSize: 20, weight: .semibold)
            typeText.textColor = .orange
            
            scrollView.addSubview(typeText)

                
            CollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
                
            CollectionView?.register(ExerciseTypesCollectionViewCell.self, forCellWithReuseIdentifier: type)
            CollectionView?.backgroundColor = .white
            CollectionView?.delegate = self
            CollectionView?.dataSource = self
            CollectionView?.restorationIdentifier = type
            CollectionView?.showsHorizontalScrollIndicator = false
                    
                    
            guard let collections = CollectionView else {
                    return
            }
                
            scrollView.addSubview(collections)
            collections.frame = CGRect(x: 0, y: 150+200*i, width: Int(view.frame.size.width), height: 150)
     
        }
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
   
    
    
    @objc private func backButtonTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeView")
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .coverVertical
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    // 유부브로 가기
    private func ExerciseButtonTapped(name: String){
        
        let top = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        top.backgroundColor = .white
        view.addSubview(top)
        
        //back, forward , 원래 화면으로 돌아가는 버튼 만들어서 넣어주기
        let goBackButton = UIButton(frame: CGRect(x: 0, y: view.frame.maxY-120, width: view.frame.width/3, height: 80))
        goBackButton.setTitle("Back", for: .normal)
        goBackButton.setTitleColor(.black, for: .normal)
        goBackButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        goBackButton.backgroundColor = .systemPink
        goBackButton.addTarget(self, action: #selector(goBackButtonTapped), for: .touchUpInside)
        goBackButton.layer.borderColor = UIColor.lightGray.cgColor
        goBackButton.layer.borderWidth = 1
        
        let goForwardButton = UIButton(frame: CGRect(x: view.frame.width/3, y: view.frame.maxY-120, width: view.frame.width/3, height: 80))
        goForwardButton.setTitle("Forward", for: .normal)
        goForwardButton.setTitleColor(.black, for: .normal)
        goForwardButton.setImage(UIImage(named: "rightArrow"), for: .normal)
        goForwardButton.backgroundColor = .systemBlue
        goForwardButton.addTarget(self, action: #selector(goForwardButtonTapped), for: .touchUpInside)
        goForwardButton.layer.borderColor = UIColor.lightGray.cgColor
        goForwardButton.layer.borderWidth = 1
        
        let returnButton = UIButton(frame: CGRect(x: view.frame.width/3*2, y: view.frame.maxY-120, width: view.frame.width/3, height: 80))
        returnButton.setTitle("return", for: .normal)
        returnButton.setTitleColor(.black, for: .normal)
        returnButton.backgroundColor = .gray
        returnButton.setImage(UIImage(named: "home"), for: .normal)
        returnButton.contentMode = .scaleAspectFit
        returnButton.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        returnButton.layer.borderColor = UIColor.lightGray.cgColor
        returnButton.layer.borderWidth = 1
        
        ExerciseView.addSubview(goBackButton)
        ExerciseView.addSubview(goForwardButton)
        ExerciseView.addSubview(returnButton)
        
        
        // 웹뷰 url 연결
        ExerciseView.frame = view.bounds
        let url = "https://www.youtube.com/results?search_query="+name
        // 한글 가능
        let encodingUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        ExerciseView.load(URLRequest(url: URL(string: encodingUrl)!))
                          
        ExerciseView.frame = CGRect(x: 0, y: 40, width: view.frame.size.width, height: view.frame.size.height)
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
        
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(15)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.size.equalTo(CGSize(width: 50, height: 30))
        }
        
        TitleLabel.frame = CGRect(x: view.frame.maxX/3,
                                  y: 50,
                                  width: view.frame.size.width,
                                  height: 50)
        
    }
    


}

extension QuestionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //let ExType = collectionView.restorationIdentifier!
  
        // 무한 스크롤
        return Int.max
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let ExType = collectionView.restorationIdentifier!
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExType, for: indexPath) as! ExerciseTypesCollectionViewCell
        
        let typeLists = exerciseAll[ExType]!

        let itemToShow = typeLists[indexPath.row % typeLists.count]// setup cell with your item and return
        cell.configure(name: itemToShow)

        return cell
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let ExType = collectionView.restorationIdentifier!
        let typeLists = exerciseAll[ExType]!
        
        
        let itemToShow = typeLists[indexPath.row % typeLists.count]

        ExerciseButtonTapped(name: itemToShow)
        
        
    }
    
}
