//
//  YearCollectionViewCell.swift
//  Calendar
//
//  Created by hyperactive on 19/05/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

class YearCollectionViewCell: UICollectionViewCell {

    override var isSelected: Bool {
        willSet {
            if newValue && selectedBackgroundView == nil {
                selectedBackgroundView = CircleView()
            }
        }
    }

    var title: String = "???" {
        didSet {
            label.text = title
        }
    }
    
    @IBOutlet weak var label: UILabel!
    var year: Int?
}
