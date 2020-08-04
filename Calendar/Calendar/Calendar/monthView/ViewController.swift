//
//  ViewController.swift
//  CollectionViewInCollectionViewCell
//
//  Created by Anish on 3/3/19.
//  Copyright © 2019 Anish Kodeboyina. All rights reserved.
//

import UIKit
let innerDelegate = InnerCollectionViewDelegate()
var monthToShow = 0

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var lastContentOffset = CGPoint()
    var myYears = 3
    override func viewDidLoad() {
        super.viewDidLoad()
    } 
    
    override func viewDidLayoutSubviews() {
        let path = IndexPath(item: monthToShow, section: 0)
        collectionView.scrollToItem(at: path, at: .centeredVertically, animated: false)
    }
    
    let firstCellIdentifier = "firstCell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: firstCellIdentifier, for: indexPath) as! FirstCollectionViewCell
        cell.configureCollectionView(dt: innerDelegate, withNibName:
            "SecondCollectionViewCell", isInteractionEnabled: true)
        currentMonth = shortMonths[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollUp() {
        let indexSet = IndexSet(arrayLiteral: 0)
        collectionView.insertSections(indexSet)
    }
    
    func scrollDown() {
        let indexSet = IndexSet(arrayLiteral: 0)
        collectionView.insertSections(indexSet)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset
        //        let contentHeight = scrollView.contentSize.height
        lastContentOffset = offset
        if lastContentOffset.y < -100 {
            myYears += 1
            scrollUp()
        } else if lastContentOffset.y > scrollView.frame.size.height - 310 {
            myYears += 1
            scrollDown()
        }
    }
}

class InnerCollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    var i = 0
    var innerWeekDay = Int()
    
    let secondCellIdentifier = "secondCell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tuple = dateComponentsInit(month: i + 1, day: 1, year: 2020)
        innerWeekDay = tuple.weekDay
        i = i == 11 ? 0 : i + 1
        print(i)
        return DaysInMonth[tuple.month - 1] + 7 + innerWeekDay - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  secondCellIdentifier, for: indexPath) as! SecondCollectionViewCell
        
        cell.label.text = indexPath.item + 1 <= innerWeekDay + 7 ? (indexPath.item + 1 == innerWeekDay ? currentMonth : "" ) :   "\(indexPath.item + 1 - (innerWeekDay + 7))"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "WeekViewController")
        UIApplication.topViewController()?.navigationController?.show(vc, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 45, height: 50)
    }
}
