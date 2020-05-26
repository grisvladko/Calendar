//
//  YearTableViewController.swift
//  Calendar
//
//  Created by hyperactive on 17/05/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

let tableViewInnerDelegate = TableViewInnerCellDelegate()

class YearTableViewController: UITableViewController {
    var paths = [IndexPath]()
    var lastContentOffset = CGFloat()
    
    override func viewWillAppear(_ animated: Bool) {
        let path = IndexPath(row: 1, section: 0)
        tableView.scrollToRow(at: path, at: .middle, animated: false)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarItems = initTabBarButtons()
        navigationItem.rightBarButtonItems = initNavBarButtons()
    }

    @objc func addReminder() {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        return UIScreen.main.bounds.height - 150
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "year", for: indexPath) as! YearTableViewCell
        cell.collectionView.delegate = tableViewInnerDelegate
        cell.collectionView.dataSource = tableViewInnerDelegate
        switchYear(atRow: indexPath.row)
        cell.yearLabel.text = String(someYearVar)
        return cell
    }
    
    func switchYear(atRow: Int) {
        switch atRow {
        case 0:
            someYearVar = 2019
        case 1:
            someYearVar = 2020
        case 2:
            someYearVar = 2021
        default:
            0
        }
    }
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (self.lastContentOffset > scrollView.contentOffset.y) {
//            someYearVar -= 1
//            tableView.beginUpdates()
//            let indexPath = IndexPath(row: 0, section: 0)
//            paths.insert(indexPath, at: 0)
//            tableView.insertRows(at: paths, with: .fade)
//            tableView.endUpdates()
//        }
//        else if (self.lastContentOffset < scrollView.contentOffset.y) {
////           someYearVar += 1
////           tableView.beginUpdates()
////            let indexPath = IndexPath(row: paths.count + 1, section: 0)
////            paths.insert(indexPath, at: 0)
////           tableView.insertRows(at: paths, with: .fade)
////           tableView.endUpdates()
//        }
//
//        self.lastContentOffset = scrollView.contentOffset.y
//    }
    
//    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
//        if translation.y > 0 {
//            someYearVar -= 1
//            self.tableView.beginUpdates()
//            let indexPath = IndexPath(row: 0, section: 0)
//            paths.insert(indexPath, at: 0)
//            tableView.insertRows(at: paths, with: .fade)
//            self.tableView.endUpdates()
//            print("DOWN")
//        } else {
//            // swipes from bottom to top of screen -> up
//            someYearVar += 1
//            self.tableView.beginUpdates()
//            let indexPath = IndexPath(row: 1 + paths.count, section: 0)
//            paths.insert(indexPath, at: 0)
//            tableView.insertRows(at: paths, with: .fade)
//            self.tableView.endUpdates()
//            print("DOWN")
//        }
//    }
    
}

func table() {
    
}
