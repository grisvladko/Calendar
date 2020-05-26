//
//  YearTableViewCell.swift
//  Calendar
//
//  Created by hyperactive on 19/05/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

let innerDelegateTwo = InnerCellCollectionViewDelegateTwo()

class YearTableViewCell: UITableViewCell {
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
}

class TableViewInnerCellDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    var monthTapped = UIButton()
    let firstCell = "yearCell"

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: firstCell, for: indexPath) as! FirstCollectionViewCell
        cell.configureCollectionView(dt: innerDelegateTwo, withNibName: "YearCollectionViewCell", isInteractionEnabled: false)
        cell.showMonthButton.tag = indexPath.item
        cell.yearViewMonthLabel.text = shortMonths[indexPath.item] //works fine
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 155)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0 , right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

class InnerCellCollectionViewDelegateTwo: NSObject,UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    var i = 12
    var innerWeekDay = Int()
    let secondCellIdentifier = "secondCell"
    
    //this is realy strange how it works, i myself dont know but it does
    //change count of days in month, play with it to set
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tuple = dateComponentsInit(month: i, day: 1, year: 2020)
        innerWeekDay = tuple.weekDay
        i = i == 0 ? 11 : i - 1
        return 2020 % 4 == 0 && i == 1 ? DaysInMonth[(tuple.month - 1)] + 7 + innerWeekDay : DaysInMonth[(tuple.month - 1)] + 7 + innerWeekDay
    }
    
    //change the arrangement of the days,  play with it to set 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  secondCellIdentifier, for: indexPath) as! YearCollectionViewCell
        cell.label.text = indexPath.item + 1 < innerWeekDay + 7 ? "" : "\(indexPath.item + 1 - (innerWeekDay - 1) - 7)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 15, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0 , right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
