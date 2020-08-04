//
//  TableViewController.swift
//  Calendar
//
//  Created by hyperactive on 29/06/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

class CalendarsTableViewController: UITableViewController {
    
    var dataBase: Calendars!
    var isChecked = Bool()
    var colors = [UIColor]()
    var checkBoxes: [CheckBox] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summonCalendars()
        self.navigationItem.rightBarButtonItem = addItemsToNavBar()
        toolbarItems = addButtonsOnToolBar()
        
        colors = [.red,.yellow,.orange,.green,.blue,.purple,.brown]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nvc = self.presentingViewController
        if let vc = nvc?.children.last as? MonthTableViewController {
            vc.innerDelegate.summonCalendars()
            vc.tableView.reloadData()
        } else if let vc = nvc?.children.last as? WeekViewController {
            vc.reloadTimeTable()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return dataBase?.calendars.count ?? 0}
        else { return 2 }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var str = String()
        switch section {
        case 0: str = "ON MY IPHONE"
        default: str = "OTHER"
        }
        return str
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //when deleted calendar provided problems with reused cell
        if !cell.subviews.isEmpty {
            for view in cell.subviews {
                view.removeFromSuperview()
            }
            if indexPath.section == 0 && indexPath.row == 0 {
                checkBoxes.removeAll()
            }
        }
        if indexPath.section == 0 {
            let checkBox = initCheckBoxForCell(forIndex: indexPath.row, color: dataBase?.calendars[indexPath.row].color ?? 0)
            checkBoxes.append(checkBox)
            let label = UILabel.init(frame: CGRect(x: 40, y: 0, width: UIScreen.main.bounds.width, height: 40))
            label.text = dataBase?.calendars[indexPath.row].calendarName
            let button = UIButton.init(type: .infoLight)
            button.frame.origin.x = UIScreen.main.bounds.width - button.frame.size.width - 10
            button.tintColor = .blue
            button.accessibilityIdentifier = dataBase?.calendars[indexPath.row].calendarName
            button.frame.origin.y = 10
            button.addTarget(self, action: #selector(showCalendarInfo(sender:)), for: .touchUpInside)
            button.tag = indexPath.row
            cell.addSubview(checkBox)
            cell.addSubview(label)
            cell.addSubview(button)
        } else {
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            checkBoxes[indexPath.row].isChecked = !checkBoxes[indexPath.row].isChecked
            dataBase.calendars[indexPath.row].isChecked = checkBoxes[indexPath.row].isChecked
        }
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
    
    @objc func checkBoxTouch(sender: UIControl) {
        dataBase.calendars[sender.tag].isChecked = !dataBase.calendars[sender.tag].isChecked
    }
    
    @objc func showCalendarInfo(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "InfoCalendarTableViewController")
        (vc as? InfoCalendarTableViewController)?.calName = sender.accessibilityIdentifier ?? "no name"
        (vc as? InfoCalendarTableViewController)?.calendarIndex = sender.tag 
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func addCalendar() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddCalendarTableViewController")
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func showAll() {
        tableView.beginUpdates()
        for i in 0..<dataBase.calendars.count {
            dataBase.calendars[i].isChecked = true
            checkBoxes[i].isChecked = true
        }
        tableView.endUpdates()
        
        let hideAllB = UIBarButtonItem(title: "Hide All", style: .plain, target: self, action: #selector(hideAll))
        hideAllB.tintColor = .blue
        toolbarItems![toolbarItems!.count - 1] = hideAllB
    }
    
    @objc func hideAll() {
        tableView.beginUpdates()
        for i in 0..<dataBase.calendars.count {
            dataBase.calendars[i].isChecked = false
            checkBoxes[i].isChecked = false
        }
        tableView.endUpdates()
        
        let showAllB = UIBarButtonItem(title: "Show All", style: .plain, target: self, action: #selector(showAll))
        showAllB.tintColor = .blue
        toolbarItems![toolbarItems!.count - 1] = showAllB
    }
    
    @objc func done() {
        saveData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveData() {
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("calendarContainer.json")
            try JSONEncoder().encode(dataBase).write(to: fileURL)
        } catch {
            print(error)
        }
    }
    
    func addButtonsOnToolBar() -> [UIBarButtonItem]{
        let addCalendarB = UIBarButtonItem(title: "Add Calendar", style: .plain, target: self, action: #selector(addCalendar))
            addCalendarB.tintColor = .blue
        let showAllB = UIBarButtonItem(title: "Show All", style: .plain, target: self, action: #selector(showAll))
            showAllB.tintColor = .blue
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        return [addCalendarB,spacer,showAllB]
    }
    
    func addItemsToNavBar() -> UIBarButtonItem{
        let doneB = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        doneB.tintColor = .blue
        return doneB
    }
    
    func summonCalendars() {
        let url = getURL()
        guard let data = try? Data(contentsOf: url) else { return }
        dataBase = (try! JSONDecoder().decode(Calendars.self, from: data))
    }
    
    func initCheckBoxForCell(forIndex: Int, color: Int) -> CheckBox {
        let checkBox = CheckBox.init(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        checkBox.style = .tick
        checkBox.borderStyle = .rounded
        checkBox.uncheckedBorderColor = colors[color]
        checkBox.checkedBorderColor = colors[color]
        checkBox.checkboxBackgroundColor = colors[color]
        checkBox.checkmarkColor = colors[color]
        checkBox.startTintColor = colors[color]
        checkBox.addTarget(self, action: #selector(checkBoxTouch), for: .allTouchEvents)
        checkBox.isChecked = dataBase?.calendars[forIndex].isChecked ?? false
        checkBox.tag = forIndex
        return checkBox
    }
}
