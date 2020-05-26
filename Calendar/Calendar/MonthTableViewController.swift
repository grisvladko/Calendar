//
//  MonthTableViewController.swift
//  Calendar
//
//  Created by hyperactive on 26/05/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit
let MonthInnerDelegate = MonthTableViewDelegate()
class MonthTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarItems = initTabBarButtons()
        navigationItem.rightBarButtonItems = initNavBarButtons()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 12
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        return 300
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "month", for: indexPath) as! MonthTableViewCell
        currentMonth = shortMonths[indexPath.row]
        cell.collectionView.delegate = MonthInnerDelegate
        cell.collectionView.dataSource = MonthInnerDelegate
        MonthInnerDelegate.i += 1
        return cell
    }
}

class MonthTableViewDelegate: NSObject,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var i = 0
    var innerWeekDay = Int()
    
    let secondCellIdentifier = "secondCell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tuple = dateComponentsInit(month: i + 1, day: 1, year: 2020)
        innerWeekDay = tuple.weekDay
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
        return CGSize(width: 40, height: 40)
    }
}
