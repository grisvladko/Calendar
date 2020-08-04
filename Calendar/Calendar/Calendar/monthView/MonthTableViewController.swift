//
//  MonthTableViewController.swift
//  Calendar
//
//  Created by hyperactive on 26/05/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

var monthViewDate = Date()
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
        initCalendar()
        var offset = tableView.contentOffset
        offset.y += 20
        tableView.setContentOffset(offset, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        drawDayBar()
        for label in innerDelegate.labels {
            label.isHighlighted = false
            label.backgroundColor = .white
            if (label as? SelectedLabel)?.date != nil {
                if Calendar.current.compare(((label as! SelectedLabel).date), to: Date(), toGranularity: .day) == .orderedSame {
                    label.backgroundColor = .cyan
                }
            }
        }
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.viewWithTag(1)?.removeFromSuperview()
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
        420
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        420
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
        innerDelegate.summonCalendars()
        
        cell.collectionView.accessibilityIdentifier = String("\(months[index]).\(years[index])")
        cell.collectionView.tag = months[index]
        cell.collectionView.delegate = innerDelegate
        cell.collectionView.dataSource = innerDelegate
        return cell
    }
    
    func initCalendar() {
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
    }
    
    func changeMonths() {
        if didScrollDown {
            for x in 0..<months.count {
                if months[x] >= 12 {
                    years[x] += 1
                    let back = UIBarButtonItem(title: String(years[x]), style: .plain, target: self, action: nil)
                    back.tintColor = .blue
                    self.navigationController?.navigationBar.topItem?.backBarButtonItem = back
                }
                months[x] = months[x] >= 12 ? 1 : months[x] + 1
            }
            innerDelegate.isScrollDown = true
            didScrollDown = false
        } else if didScrollUp {
            for x in 0..<months.count {
                if months[x] <= 1 {
                    years[x] -= 1
                    let back = UIBarButtonItem(title: String(years[x]), style: .plain, target: self, action: nil)
                    back.tintColor = .blue
                    self.navigationController?.navigationBar.topItem?.backBarButtonItem = back
                }
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
        view.tag = 1
        view.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        view.frame.origin.y = (self.navigationController?.navigationBar.frame.height)!
        self.navigationController?.navigationBar.addSubview(view)
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
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "searchViewController")
        
        navigationController?.show(vc, sender: nil)
    }
    
    @objc func calendarFunc() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "CalendarsTableViewController")
        let nav = UINavigationController.init(rootViewController: vc)
        nav.isToolbarHidden = false
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func inbox() {
        
    }
    
    @objc func today() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "WeekViewController")
        scrollViewDate = Date()
        self.show(vc, sender: nil)
    }
}

class MonthViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: SelectedLabel!
    @IBOutlet weak var label: UILabel!
}

class SelectedLabel: UILabel {
    var date: Date!
    
    override var isHighlighted: Bool {
        willSet {
            if newValue {
                backgroundColor = .blue
                highlightedTextColor = .white
            }
        }
    }
}

class MonthInnerDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var labels = [UILabel]()
    var isScrollDown = Bool()
    var isScrollUp = Bool()
    var i = Int()
    var months = [Int()]
    var innerMonth = Int()
    var innerYear = Int()
    var innerWeekDay = Int()
    var monthName = String()
    let secondCellIdentifier = "secondCell"
    var dataBase: Calendars!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tuple = dateComponentsInit(month: innerMonth, day: 1, year: innerYear)
        innerMonth = tuple.month
        monthName = shortMonths[tuple.month - 1]
        innerWeekDay = tuple.weekDay - 1
        return innerYear % 4 == 0 && tuple.month == 2 ? DaysInMonth[tuple.month - 1] + 7 + innerWeekDay + 1 : DaysInMonth[tuple.month - 1] + 7 + innerWeekDay
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  secondCellIdentifier, for: indexPath) as! MonthViewCell
        cell.label.backgroundColor = .white
        cell.isUserInteractionEnabled = true
        
        if indexPath.item + 1 <= innerWeekDay + 7 {
            cell.dateLabel.text = indexPath.item == innerWeekDay ? monthName : ""
            cell.label.text = ""
            cell.dateLabel.date = nil
            cell.isUserInteractionEnabled = false
        } else {
            var components = DateComponents()
            components.year = innerYear
            components.month = collectionView.tag
            components.day = indexPath.item + 1 - (innerWeekDay + 7)
    
            let d = Calendar.current.date(from: components)
            cell.dateLabel.date = d!
            cell.dateLabel.text = "\(indexPath.item + 1 - (innerWeekDay + 7))"
        }
        
        if cell.dateLabel.date != nil {
            let order = Calendar.current.compare(cell.dateLabel.date, to: Date(), toGranularity: .day)
            if order == .orderedSame {
                cell.dateLabel.backgroundColor = .cyan
            } else { cell.dateLabel.backgroundColor = .white }
        }
        cell.dateLabel.layer.cornerRadius = 37 / 2
        cell.dateLabel.layer.masksToBounds = true
        cell.dateLabel.frame.origin = CGPoint(x: 3, y: 0)
        cell.dateLabel.textAlignment = .center

        labels.append(cell.dateLabel)
        //event dot
        cell.label.frame = CGRect(x: 17, y: 40, width: 7.5, height: 7.5)
        cell.label.layer.cornerRadius = 7.5 / 2
        cell.label.layer.masksToBounds = true
        cell.label.text = ""
        
        if cell.dateLabel.date != nil {
            if searchEvent(date: cell.dateLabel.date) {
                cell.label.backgroundColor = .darkGray
            } else { cell.label.backgroundColor = .white }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "WeekViewController")
        
        scrollViewDate = (collectionView.cellForItem(at: indexPath) as? MonthViewCell)?.dateLabel.date ?? Date()

        UIApplication.topViewController()?.navigationController?.show(vc, sender: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 45, height: 50)
    }
    
    func summonCalendars() {
        let url = getURL()
        guard let data = try? Data(contentsOf: url) else { return }
        dataBase = (try? JSONDecoder().decode(Calendars.self, from: data))!
    }
    
    func searchEvent(date: Date) -> Bool{
        
        for calendar in dataBase.calendars {
            if calendar.isChecked {
                if isEventPresent(calendar: calendar, date: date) {
                    return true
                }
            }
        }
        return false
    }
    
    func isEventPresent(calendar: MyCalendar, date: Date) -> Bool{
        for event in calendar.events {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
            let d = formatter.date(from: event.start)!
            let d2 = formatter.date(from:event.end)!
            if date.isBetween(d, and: d2) || Calendar.current.compare(d, to: date, toGranularity: .day) == .orderedSame {
                return true
            }
        }
        return false
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
