//
//  YearTableViewController.swift
//  Calendar
//
//  Created by hyperactive on 17/05/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

class YearTableViewController: UITableViewController {
    
    var tableViewInnerDelegate = TableViewInnerCellDelegate()
    var date = Date()
    var myYears = 3
    var lastContentOffset = CGPoint()
    var didScrollUp = Bool()
    var didScrollDown = Bool()
    var years = [2020,2021,2022]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       tableView.showsVerticalScrollIndicator = false
       toolbarItems = initTabBarButtons()
       navigationItem.rightBarButtonItems = initNavBarButtons()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myYears
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height - 250
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "year", for: indexPath) as! YearTableViewCell

        if didScrollDown || didScrollUp {
        changeYears()
        }
        let index = indexPath.row > 2 ? 2 : indexPath.row // keep index in range
        tableViewInnerDelegate.innerYear = years[index]
        cell.yearLabel.text = String(years[index])
        cell.collectionView.delegate = tableViewInnerDelegate
        cell.collectionView.dataSource = tableViewInnerDelegate
     
        return cell
    }

    func changeYears() {
        if didScrollDown {
            for x in 0..<years.count {
                years[x] += 1
            }
            didScrollDown = false
        } else if didScrollUp {
            for x in 0..<years.count {
                years[x] -= 1
            }
            didScrollUp = false
        }
        tableView.setNeedsDisplay()
    }
    
    func initNavBarButtons() -> [UIBarButtonItem] {
        let addB = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
            addB.tintColor = .blue
        let searchB = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
            searchB.tintColor = .blue
        
        return [addB,searchB]
    }

    func initTabBarButtons() -> [UIBarButtonItem] {
        
        let Today = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(today))
            Today.tintColor = .blue
        let Calendar = UIBarButtonItem(title: "Calendar", style: .plain, target: self, action: #selector(calendar))
            Calendar.tintColor = .blue
        let Inbox = UIBarButtonItem(title: "Inbox", style: .plain, target: self, action: #selector(inbox))
            Inbox.tintColor = .blue
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        return [Today,spacer,Calendar,spacer,Inbox]
    }
    
    @objc func add() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddEventTableViewController")
        let nav = UINavigationController.init(rootViewController: vc)
        nav.setToolbarHidden(false, animated: false)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func search() {
        // add code
    }
    
    @objc func calendar() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "CalendarsTableViewController")
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func inbox() {
        
    }
    
    @objc func today() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "MonthTableViewController")
        self.show(vc, sender: nil)
    }
}

extension YearTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        lastContentOffset = offset
        if lastContentOffset.y < -100 && !didScrollDown && !didScrollUp {
            myYears += 1
            didScrollUp = true
            scrollUp()
        } else if lastContentOffset.y > scrollView.frame.size.height - 350 && !didScrollUp && !didScrollDown {
            myYears += 1
            didScrollDown = true
            scrollDown()
        }
    }
    
    func scrollDown() {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        let indexPath = IndexPath(row: myYears - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .none)
        tableView.endUpdates()
        if myYears > 3 {
            tableView.beginUpdates()
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.deleteRows(at: [indexPath], with: .none)
            myYears -= 1
            tableView.endUpdates()
        }
        UIView.setAnimationsEnabled(true)
    }
    
    func scrollUp() {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .none)
        tableView.endUpdates()
        if myYears > 3 {
            tableView.beginUpdates()
            let indexPath = IndexPath(row: myYears - 1, section: 0)
            tableView.deleteRows(at: [indexPath], with: .none)
            myYears -= 1
            tableView.endUpdates()
        }
        UIView.setAnimationsEnabled(true)
        lastContentOffset.y += tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        tableView.setContentOffset(lastContentOffset, animated: false)
    }
}

class CircleView: UIView {

    override class var layerClass: AnyClass { return CAShapeLayer.self }

    override func layoutSubviews() {
        super.layoutSubviews()

        let layer = self.layer as! CAShapeLayer
        layer.strokeColor = UIColor.blue.cgColor
        layer.fillColor = UIColor.blue.cgColor
        let width: CGFloat = 3
        layer.lineWidth = width
        layer.path = CGPath(ellipseIn: bounds.insetBy(dx: width / 2, dy: width / 2), transform: nil)
    }
}
