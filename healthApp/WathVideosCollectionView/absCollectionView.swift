//
//  absCollectionView.swift
//  healthApp
//
//  Created by hong on 2021/11/18.
//

import UIKit

class absCollectionView: UICollectionViewController {

    private let abs = exerciseAll["복부"]!
    
    private var collectionViews: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.scrollDirection = .horizontal

        
        collectionViews = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionViews?.register(ExerciseTypesCollectionViewCell.self, forCellWithReuseIdentifier: "absCell")
        
        collectionViews?.backgroundColor = .white
        collectionViews?.delegate = self
        collectionViews?.dataSource = self
        
        guard let absCollectionView = collectionViews else {
            return
        }
        
        view.addSubview(absCollectionView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionViews?.frame = view.bounds
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        abs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViews?.dequeueReusableCell(withReuseIdentifier: "absCell", for: indexPath) as! ExerciseTypesCollectionViewCell
        cell.configure(name: abs[indexPath.row])
        return cell
    }
    

    
}
extension absCollectionView: UICollectionViewDelegateFlowLayout {
    
   
}
