//
//  ExerciseListViewController.swift
//  healthApp
//
//  Created by hong on 2021/11/13.
//

import UIKit
import Instructions


class ExerciseListViewController: UIViewController {
    
    var exerciseCollectionView: UICollectionView?
    private var coachMarksController = CoachMarksController()

    private let instructionButton: UIButton = {
            
        let instructionButton = UIButton()
        instructionButton.setImage(UIImage(named: "what"), for: .normal)
        instructionButton.frame = CGRect(x: 60, y: 50, width: 30, height: 30)
            
        return instructionButton
            
    }()
        
    private var coachDatas = [instructionDatas]()
    
    
    
    private let backButton: UIButton = {
        let backbutton = UIButton()
        backbutton.setTitle("Back", for: .normal)
        backbutton.setTitleColor(.systemBlue, for: .normal)
        backbutton.frame = CGRect(x: 0, y: 50, width: 50, height: 30)
        return backbutton

    }()
    
    // 검색 타이틀 레이블 
    private let titleLabel: UILabel = {
        let titleLable = UILabel()
        titleLable.text = "운동검색"
        titleLable.textAlignment = .center
        titleLable.font = UIFont.systemFont(ofSize: 27, weight: .heavy)
        titleLable.frame = CGRect(x: 0, y: 50, width: 420, height: 40)
        return titleLable
    }()
    
    var exerciseList = [ExerciseData]()
    var searchedList = [ExerciseData]()
    var searched = false
    var scopeButtonTapped = true
    let searchController = UISearchController(searchResultsController: nil)
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
       
       
        
        let layout = UICollectionViewFlowLayout()
        // 움직이는 방향
        layout.scrollDirection = .vertical
        // 셀 크기 정하기
        layout.itemSize = CGSize(width: view.frame.size.width/2-2, height: view.frame.size.width/3-4)
        // 셀마다 공간 정하기
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        exerciseCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        
        guard let exerciseCollectionView = exerciseCollectionView else {
            return
        }
        exerciseCollectionView.register(ExerciseCollectionViewCell.self, forCellWithReuseIdentifier: ExerciseCollectionViewCell.identifier)
        exerciseCollectionView.dataSource = self
        exerciseCollectionView.delegate = self
        
        // 콜렉션뷰 배경 투명하지 않게
        exerciseCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)

        
        fillData()
        
        searchedList = exerciseList
        
        configureSearchController()
        
        navigationItem.title = "운동 검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(exerciseCollectionView)
        view.addSubview(searchController.searchBar)
   
        
        
        
        
        // 위치 설정
        searchController.searchBar.frame.size.width = view.frame.size.width
        searchController.searchBar.frame.origin.y = titleLabel.frame.origin.y+40

        
        //직접 지정해준 이유 그냥 놔두면 끝이 안 보여서 그걸 직접 조정해줘야 끝까지 잘 보임
        exerciseCollectionView.frame = CGRect(x: 0, y: searchController.searchBar.frame.origin.y+50, width: view.frame.size.width, height: view.frame.size.height-searchController.searchBar.frame.size.height-90)
       // exerciseCollectionView.frame.origin.y = searchController.searchBar.frame.origin.y+38
        
        
        // 도움말
        view.addSubview(instructionButton)
                
        // 도움말 데이터 넣어주기
        fillCoachDatas()
        coachMarksController.dataSource = self
        //배경 눌러도 자동으로 넘어가게
        coachMarksController.overlay.isUserInteractionEnabled = true
                
        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("skip", for: .normal)
        coachMarksController.skipView = skipView

        instructionButton.addTarget(self, action: #selector(instructionButtonTapped), for: .touchUpInside)


        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fromChart = false
        
        
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    

    private func fillCoachDatas() {
        
        let item1 = instructionDatas(View: searchController.searchBar, bodyText: "검색어를 입력해서 검색할 수 있습니다", nextText: "다음")
            coachDatas.append(item1)
        
            
            
    }
        
    @objc private func instructionButtonTapped() {
            
        coachMarksController.start(in: .window(over: self))
            
    }

    
    private func configureSearchController() {
        
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.scopeButtonTitles = ["전체","하체","복부","가슴","등","어깨","팔","유산소","기타"]
        definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "찾으실 운동을 검색해주세요"
        
        searchController.hidesNavigationBarDuringPresentation = true

        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    
    private func fillData() {
        
        for exercisePart in exerciseParts {
            let types = exerciseAll[exercisePart]!
            for type in types {
                let data = ExerciseData(eType: exercisePart, eName: type, eImage: type)
                exerciseList.append(data)
            }
        }
        
        if fromChart {
            let walkingData = ExerciseData(eType: "유산소", eName: "워킹", eImage: "워킹")
            exerciseList.append(walkingData)
        }
        
    }
    

}

extension ExerciseListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searched || scopeButtonTapped {
            return searchedList.count
        } else {
            return exerciseList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExerciseCollectionViewCell.identifier, for: indexPath) as! ExerciseCollectionViewCell

        if searched || scopeButtonTapped {
            cell.ExerciseImage.image = UIImage(named: searchedList[indexPath.row].ExerciseImage)
            cell.ExerciseLabel.text = searchedList[indexPath.row].ExerciseName
        } else {
            cell.ExerciseImage.image = UIImage(named: exerciseList[indexPath.row].ExerciseImage)
            cell.ExerciseLabel.text = exerciseList[indexPath.row].ExerciseName
        }
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let scopeButton = searchController.searchBar.scopeButtonTitles![searchController.searchBar.selectedScopeButtonIndex]
        let searchText = searchController.searchBar.text!
        
        if !searchText.isEmpty {
            titleLabel.isHidden = true
            
            searched = true
            searchedList.removeAll()
            
            for exercise in exerciseList {
                if exercise.ExerciseName.lowercased().contains(searchText.lowercased()) && (exercise.ExerciseType == scopeButton || scopeButton == "전체") {
                    searchedList.append(exercise)
                }
                
            }
            searched = false
            exerciseCollectionView?.reloadData()
        }
        else {
            if scopeButtonTapped {
                searchedList.removeAll()
                let scopeButton = searchController.searchBar.scopeButtonTitles![searchController.searchBar.selectedScopeButtonIndex]
                for exercise in exerciseList {
                    if (exercise.ExerciseType == scopeButton || scopeButton == "전체") {
                        searchedList.append(exercise)
                    }
                }
            } else {
                searched = false
                searchedList.removeAll()
                searchedList = exerciseList
            }
            
        }
        exerciseCollectionView?.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searched = false
        searchedList.removeAll()
        exerciseCollectionView?.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchController.searchBar.text = ""
        scopeButtonTapped = true
        let scopeButton = searchController.searchBar.scopeButtonTitles![searchController.searchBar.selectedScopeButtonIndex]
        searchedList.removeAll()
        
        for exercise in exerciseList {
            if (exercise.ExerciseType == scopeButton || scopeButton == "전체") {
                searchedList.append(exercise)
            }
        }
        searched = true
        exerciseCollectionView?.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 운동 선택 
        
       
        nowExerciseType = searchedList[indexPath.row].ExerciseName
        
        
        searched = false
   
        
        dismiss(animated: false, completion: nil)
        dismiss(animated: false, completion: nil)
     
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        backButton.isHidden = true
        titleLabel.isHidden = true
        instructionButton.isHidden = true
        
        //exerciseCollectionView?.frame = CGRect(x: 0, y: searchController.searchBar.frame.origin.y+100, width: view.frame.size.width, height: view.frame.size.height-120)
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        
        backButton.isHidden = false
        titleLabel.isHidden = false
        instructionButton.isHidden = false
        //exerciseCollectionView?.frame = CGRect(x: 0, y: searchController.searchBar.frame.origin.y+50, width: view.frame.size.width, height: view.frame.size.height-searchController.searchBar.frame.size.height)
        
    }
    
    
}

extension ExerciseListViewController: CoachMarksControllerDelegate, CoachMarksControllerDataSource {
    
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
            return coachDatas.count
        }
        
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
            return coachMarksController.helper.makeCoachMark(for: coachDatas[index].View)
        }
        
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
            
        let coachView = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        switch index {
        case 0:
            coachView.bodyView.hintLabel.text = coachDatas[index].bodyText
            coachView.bodyView.nextLabel.text = coachDatas[index].nextText
        default:
            coachView.bodyView.hintLabel.text = coachDatas[index].bodyText
            coachView.bodyView.nextLabel.text = coachDatas[index].nextText
        }
            
        return (bodyView: coachView.bodyView, arrowView: coachView.arrowView)
            
    }

}
