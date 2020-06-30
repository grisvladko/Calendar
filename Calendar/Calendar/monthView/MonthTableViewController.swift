//
//  MonthTableViewController.swift
//  Calendar
//
//  Created by hyperactive on 26/05/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit


class MonthTableViewController: UITableViewController{
    
    var didEndDragging = Bool()
    var didLoadView = Bool()
    var didScrollUp = Bool()
    var didScrollDown = Bool()
    
    var date = Date()
    var innerMonth = Int()
    var countMonths = 4
    var innerYear = Int()
    var years = [Int]()
    var months = [Int]()
    var lastContentOffset = CGPoint()
    var innerDelegate = MonthInnerDelegate()
    var calendar = Calendar.current
    var addYear = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        innerYear = calendar.component(.year, from: date)
        let back = UIBarButtonItem(title: String(innerYear), style: .plain, target: self, action: nil)
        back.tintColor = .blue
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = back
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        toolbarItems = initTabBarButtons()
        navigationItem.rightBarButtonItems = initNavBarButtons()
        
        innerDelegate.innerYear = calendar.component(.year, from: date)
        innerDelegate.innerMonth = calendar.component(.month, from: date)
        innerMonth = calendar.component(.month, from: date)
        months.append(innerMonth)
        innerYear = calendar.component(.year, from: date)
        years.append(innerYear)
        var tempDate = Date()
        for i in 1..<4 {
            tempDate = calendar.date(byAdding: .month, value: i, to: date)!
            months.append(calendar.component(.month, from: tempDate))
        }
        var tempdate2 = Date()
        for i in 1..<4 {
            tempdate2 = calendar.date(byAdding: .month, value: i, to: date)!
            years.append(calendar.component(.year, from: tempdate2))
        }
        drawDayBar()
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        didEndDragging = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countMonths
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        375
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        375
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "month", for: indexPath) as! MonthTableViewCell
        
        if didScrollUp || didScrollDown {
            changeMonths()
        }
        
        let index = indexPath.row > 3 ? 3 : indexPath.row
        cell.configureCollectionView()
        innerDelegate.innerMonth = months[index]
        innerDelegate.months = months
        innerDelegate.innerYear = years[index]
        cell.collectionView.accessibilityIdentifier = String("\(months[index]).\(years[index])")
        cell.collectionView.tag = months[index]
        cell.collectionView.delegate = innerDelegate
        cell.collectionView.dataSource = innerDelegate
        return cell
    }
    
    func changeMonths() {
        if didScrollDown {
            for x in 0..<months.count {
                years[x] = months[x] >= 12 ? years[x] + 1 : years[x]
                months[x] = months[x] >= 12 ? 1 : months[x] + 1
            }
            innerDelegate.isScrollDown = true
            didScrollDown = false
        } else if didScrollUp {
            for x in 0..<months.count {
                years[x] = months[x] <= 1 ? years[x] - 1 : years[x]
                months[x] = months[x] <= 1 ? 12 : months[x] - 1
            }
            innerDelegate.isScrollDown = false
            didScrollUp = false
        }
        tableView.setNeedsDisplay()
    }
    
    func drawDayBar() {
        let dayLabels = ["S","M","T","W","T","F","S"]
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
        var x:CGFloat = 0.0
        for i in 0..<7 {
            let label = UILabel.init(frame: CGRect(x: x, y: 0, width: UIScreen.main.bounds.width / 7, height: 20))
            label.text = dayLabels[i]
            label.textColor = i == 0 || i == 6 ? .blue : .black
            label.textAlignment = .center
            label.font = label.font.withSize(10)
            view.addSubview(label)
            x += UIScreen.main.bounds.width / 7
        }
        
        view.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        self.view.addSubview(view)
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
        let Calendar = UIBarButtonItem(title: "Calendar", style: .plain, target: self, action: #selector(calendarFunc))
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
    
    @objc func calendarFunc() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "CalendarsTableViewController")
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func inbox() {
        
    }
    
    @objc func today() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScrollViewController")
        self.show(vc, sender: nil)
    }
}

class MonthViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
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
            label.textColor = .white
        }
    }
}

class MonthInnerDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var isScrollDown = Bool()
    var isScrollUp = Bool()
    var i = Int()
    var months = [Int()]
    var innerMonth = Int()
    var innerYear = Int()
    var innerWeekDay = Int()
    var monthName = String()
    let secondCellIdentifier = "secondCell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tuple = dateComponentsInit(month: innerMonth, day: 1, year: innerYear)
        innerMonth = tuple.month
        monthName = shortMonths[tuple.month - 1]
        innerWeekDay = tuple.weekDay - 1
        return innerYear % 4 == 0 && tuple.month == 2 ? DaysInMonth[tuple.month - 1] + 7 + innerWeekDay + 1 : DaysInMonth[tuple.month - 1] + 7 + innerWeekDay
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let date = Date()
//        
//        let day = Calendar.current.component(.day, from: date)
//        let month = Calendar.current.component(.month, from: date)
//        let year = Calendar.current.component(.year, from: date)
//        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  secondCellIdentifier, for: indexPath) as! MonthViewCell
//        if day == indexPath.item - 7 && month == innerMonth && year == innerYear {
//            cell.layer.cornerRadius = cell.frame.width / 2
//            cell.layer.backgroundColor = UIColor.blue.cgColor
//            cell.label.textColor = .white
//        }
        
        cell.label.text = indexPath.item + 1 <= innerWeekDay + 7 ? (indexPath.item == innerWeekDay ? monthName : "" ) :   "\(indexPath.item + 1 - (innerWeekDay + 7))"
        cell.isUserInteractionEnabled = cell.label.text == "" || cell.label.text == monthName ? false : true
        
        return cell
    }
    
    func decodeIdentifier(identifier: String) -> (month:Int,year:Int) {
        var month = String()
        for c in identifier {
            if c != "." {
            month.append(c)
            } else { break }
        }
        var year = String()
        var x = 0
        for c in identifier {
            if x == 1 {
                year.append(c)
            }
            if c == "." {
                x = 1
            }
        }
        return (month:Int(month)!,year:Int(year)!)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScrollViewController")
        
        let identifierDecoded = decodeIdentifier(identifier: collectionView.accessibilityIdentifier!)
        let tuple = dateComponentsInit(month: identifierDecoded.month, day: 1, year: identifierDecoded.year)
        
        let cal = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = identifierDecoded.year
        dateComponents.month = identifierDecoded.month
        dateComponents.day = indexPath.item - tuple.weekDay - 4
        let date = cal.date(from: dateComponents)
        scrollViewDate = date!

        UIApplication.topViewController()?.navigationController?.show(vc, sender: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
}

extension MonthTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        lastContentOffset = offset
        
        if lastContentOffset.y < -120 {
            countMonths += 1
            didScrollUp = true
            scrollUp()
        } else if lastContentOffset.y > 300 && !didScrollUp && !didScrollDown {
            countMonths += 1
            didScrollDown = true
            scrollDown()
        }
    }

    func scrollDown() {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        let indexPath = IndexPath(row: countMonths - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .none)
        tableView.endUpdates()
        if countMonths > 4 {
            tableView.beginUpdates()
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.deleteRows(at: [indexPath], with: .none)
            countMonths -= 1
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
        if countMonths > 4 {
            tableView.beginUpdates()
            let indexPath = IndexPath(row: countMonths - 1, section: 0)
            tableView.deleteRows(at: [indexPath], with: .none)
            countMonths -= 1
            tableView.endUpdates()
        }
        UIView.setAnimationsEnabled(true)
        lastContentOffset.y += tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        tableView.setContentOffset(lastContentOffset, animated: false)
    }
}
