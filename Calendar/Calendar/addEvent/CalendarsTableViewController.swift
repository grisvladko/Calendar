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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summonCalendars()
        self.navigationItem.rightBarButtonItem = addItemsToNavBar()
        toolbarItems = addButtonsOnToolBar()
        colors = [.red,.yellow,.orange,.green,.blue,.purple,.brown]
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
        if indexPath.section == 0 {
            let checkBox = initCheckBoxForCell(forIndex: indexPath.row)
            let label = UILabel.init(frame: CGRect(x: 40, y: 0, width: UIScreen.main.bounds.width, height: 40))
            label.text = dataBase?.calendars[indexPath.row].calendarName
            let button = UIButton.init(type: .infoLight)
            button.frame.origin.x = UIScreen.main.bounds.width - button.frame.size.width - 10
            button.tintColor = .blue
            button.frame.origin.y = 10
            button.addTarget(self, action: #selector(showCalendarInfo), for: .touchUpInside)
            cell.addSubview(checkBox)
            cell.addSubview(label)
            cell.addSubview(button)
        } else {
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
    
    @objc func checkBoxTouch(sender: UIControl) {
        dataBase.calendars[sender.tag].isChecked = !dataBase.calendars[sender.tag].isChecked
    }
    
    @objc func showCalendarInfo() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "InfoCalendarTableViewController")
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
    
    func initCheckBoxForCell(forIndex: Int) -> CheckBox {
        let checkBox = CheckBox.init(frame: CGRect(x: 11, y: 11, width: 20, height: 20))
        checkBox.style = .tick
        checkBox.borderStyle = .rounded
        checkBox.uncheckedBorderColor = colors[forIndex]
        checkBox.checkedBorderColor = colors[forIndex]
        checkBox.checkboxBackgroundColor = colors[forIndex]
        checkBox.checkmarkColor = colors[forIndex]
        checkBox.frame.origin.x = 10
        checkBox.addTarget(self, action: #selector(checkBoxTouch), for: .allTouchEvents)
        checkBox.isChecked = dataBase?.calendars[forIndex].isChecked ?? false
        checkBox.tag = forIndex
        return checkBox
    }
}
