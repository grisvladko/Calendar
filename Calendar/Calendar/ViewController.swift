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
class ViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarItems = initTabBarButtons()
        navigationItem.rightBarButtonItems = initNavBarButtons()
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
        print(indexPath.row)
        return cell
    }
}

class InnerCollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    var i = 12
    var innerWeekDay = Int()
    
    let secondCellIdentifier = "secondCell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tuple = dateComponentsInit(month: i, day: 1, year: 2020)
        innerWeekDay = tuple.weekDay
        i = i == 0 ? 11 : i - 1
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
        return CGSize(width: 40, height: 50)
    }
    
//    func showModally(_ viewController: UIViewController) {
//        let window = UIApplication.shared.keyWindow
//        let rootViewController = window?.rootViewController
//        rootViewController?.present(viewController, animated: true, completion: nil)
//    }
}

extension UIApplication
{
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
    {
        if let nav = base as? UINavigationController
        {
            let top = topViewController(nav.visibleViewController)
            return top
        }

        if let tab = base as? UITabBarController
        {
            if let selected = tab.selectedViewController
            {
                let top = topViewController(selected)
                return top
            }
        }

        if let presented = base?.presentedViewController
        {
            let top = topViewController(presented)
            return top
        }
        return base
    }
}
