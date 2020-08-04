//
//  MonthTableViewCell.swift
//  Calendar
//
//  Created by hyperactive on 26/05/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

class MonthTableViewCell: UITableViewCell {
 
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 12).isActive = true
        collectionView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
        
        collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        collectionView.reloadData()
    }
}
