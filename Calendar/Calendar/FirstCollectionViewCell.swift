//
//  FirstCollectionViewCell.swift
//  CollectionViewInCollectionViewCell
//
//  Created by Anish on 3/3/19.
//  Copyright © 2019 Anish Kodeboyina. All rights reserved.
//

import UIKit

class FirstCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var showMonthButton: UIButton!
    
    @IBAction func monthTapped(_ sender: Any) {
        switch showMonthButton.tag {
        case 0:
            monthToShow = 0
        case 1:
            monthToShow = 1
        case 2:
            monthToShow = 2
        case 3:
            monthToShow = 3
        case 4:
            monthToShow = 4
        case 5:
            monthToShow = 5
        case 6:
            monthToShow = 6
        case 7:
            monthToShow = 7
        case 8:
            monthToShow = 8
        case 9:
            monthToShow = 9
        case 10:
            monthToShow = 10
        case 11:
            monthToShow = 11
        default:
            0
        }
        print("moved to ViewController")
    }
    
    @IBOutlet weak var yearViewMonthLabel: UILabel!
    let secondCellIdentifier = "secondCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    func configureCollectionView(dt: UICollectionViewDataSource & UICollectionViewDelegate, withNibName: String, isInteractionEnabled: Bool) {
        addSubview(collectionView)
        collectionView.dataSource = dt
        collectionView.delegate = dt
        
        collectionView.isUserInteractionEnabled = isInteractionEnabled 
        collectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    
        collectionView.register(UINib(nibName: withNibName, bundle: .main), forCellWithReuseIdentifier: secondCellIdentifier)
        collectionView.reloadData()
    }
    
    //change function
//    func somt(dt: UICollectionViewDataSource & UICollectionViewDelegate, withNibName: String, isInteractionEnabled: Bool) {
//        addSubview(collectionView)
//        collectionView.dataSource = dt
//        collectionView.delegate = dt
//        collectionView.register(UINib(nibName: withNibName, bundle: .main), forCellWithReuseIdentifier: secondCellIdentifier)
//        collectionView.reloadData()
//    }
    
}
