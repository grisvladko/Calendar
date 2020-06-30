//
//  FirstCollectionViewCell.swift
//  CollectionViewInCollectionViewCell
//
//  Created by Anish on 3/3/19.
//  Copyright © 2019 Anish Kodeboyina. All rights reserved.
//

import UIKit

class FirstCollectionViewCell: UICollectionViewCell {
    var innerYear = Int()
    
    @IBOutlet weak var showMonthButton: UIButton!
    
    @IBAction func monthTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "MonthTableViewController")
        var dateComponents = DateComponents()
        dateComponents.year = innerYear
        dateComponents.month = showMonthButton.tag + 1
        dateComponents.day = 28
        let date = Calendar.current.date(from: dateComponents)!
        (vc as? MonthTableViewController)?.date = date
        print(monthScrollDate)
        UIApplication.topViewController()?.navigationController?.show(vc, sender: nil)
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
        (dt as? InnerCellCollectionViewDelegateTwo)?.innerYear = self.innerYear
        
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
}
