//
//  ExerciseListViewController.swift
//  healthApp
//
//  Created by hong on 2021/11/13.
//

import UIKit

class ExerciseListViewController: UIViewController {
    
    var exerciseCollectionView: UICollectionView?
    
    
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
    var scopeButtonTapped = false
    let searchController = UISearchController(searchResultsController: nil)
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = "Profile Settings"

        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
       
       
        
        let layout = UICollectionViewFlowLayout()
        // 움직이는 방향
        layout.scrollDirection = .vertical
        // 셀 크기 정하기
        layout.itemSize = CGSize(width: view.frame.size.width/2, height: view.frame.size.width/3-4)
        // 셀마다 공간 정하기
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
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
        configureSearchController()
        
        navigationItem.title = "운동 검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(exerciseCollectionView)
        view.addSubview(searchController.searchBar)
   
        
        
        
        
        // 위치 설정
        searchController.searchBar.frame.size.width = view.frame.size.width
        searchController.searchBar.frame.origin.y = 100
        exerciseCollectionView.frame = view.bounds
        exerciseCollectionView.frame.origin.y = searchController.searchBar.frame.origin.y+38

        // Do any additional setup after loading the view.
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
                let data = ExerciseData(eType: exercisePart, eName: type, eImage: "chart")
                exerciseList.append(data)
            }
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
                if exercise.ExerciseName.lowercased().contains(searchText.lowercased()) && (exercise.ExerciseType==scopeButton||scopeButton=="전체") {
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
                    if (exercise.ExerciseType==scopeButton||scopeButton=="전체") {
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
            if (exercise.ExerciseType == scopeButton||scopeButton=="전체") {
                searchedList.append(exercise)
            }
        }
        exerciseCollectionView?.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 운동 선택 
        
        if searched {
            nowExerciseType = searchedList[indexPath.row].ExerciseName
        } else {
            nowExerciseType = exerciseList[indexPath.row].ExerciseName
        }
        
        searched = false
        scopeButtonTapped = false
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExerciseRecordView")
        vc!.modalPresentationStyle = .fullScreen
        present(vc!, animated: true, completion: nil)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        titleLabel.isHidden = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        titleLabel.isHidden = false
    }
    
    
}
