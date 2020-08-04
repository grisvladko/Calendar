//
//  InfoCalendarTableViewController.swift
//  Calendar
//
//  Created by hyperactive on 29/06/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

class InfoCalendarTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var calendarName: UITextField!
    @IBOutlet weak var red: UILabel!
    @IBOutlet weak var yellow: UILabel!
    @IBOutlet weak var orange: UILabel!
    @IBOutlet weak var green: UILabel!
    @IBOutlet weak var blue: UILabel!
    @IBOutlet weak var purple: UILabel!
    @IBOutlet weak var brown: UILabel!
    
    var calendarIndex: Int!
    var dataBase: Calendars!
    var labels = [UILabel]()
    var colors = [UIColor]()
    var colorIndex = Int()
    var calName: String = "no string"
    var didSelectColor = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSavedData()
        
        calendarName.text = calName
        calendarName.addTarget(self, action: #selector(calendarNameChange(_:)), for: .editingChanged)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem?.tintColor = .blue
        labels = [red,yellow,orange,green,blue,purple,brown]
        colors = [.red,.yellow,.orange,.green,.blue,.purple,.brown]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for i in 0..<labels.count {
            let dot: NSMutableAttributedString = NSMutableAttributedString(string: "●")
            dot.addAttribute(NSAttributedString.Key.foregroundColor, value: colors[i], range: NSRange(location:0,length: 1))
            labels[i].attributedText = dot
            labels[i].font = labels[i].font.withSize(10)
        }
        summonCalendars()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nvc = self.presentingViewController
        if let vc = nvc?.children.first as? CalendarsTableViewController {
            vc.summonCalendars()
            vc.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 2 && isEventInCalendar() {
            return ""
        } else { return super.tableView(tableView, titleForFooterInSection: section)}
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 && isEventInCalendar() {
            return ""
        } else { return super.tableView(tableView, titleForHeaderInSection: section)}
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 && isEventInCalendar() {
            return 0
        } else if indexPath.section == 3 && dataBase.calendars.count < 2{
            return 0
        }
        else { return super.tableView(tableView, heightForRowAt: indexPath)}
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
            label.text = "Delete Calendar"
            label.textAlignment = .center
            label.tintColor = .blue
            cell.addSubview(label)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            colorIndex = indexPath.row
            didSelectColor = true
        } else if indexPath.section == 3 {
            deleteCalendar()
        }
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
    
    func deleteCalendar() {
        let ac = UIAlertController(title: nil, message: "Are you sure you want to delete this calendar? All events associated with this calendar will be also deleted", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Delete Calendar", style: .default, handler: delete))
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func delete(action: UIAlertAction) {
        dataBase.calendars.remove(at: calendarIndex)
        saveData()
        getSavedData()
        self.dismiss(animated: true, completion: nil)
    }
    
    //just to check
    func getSavedData() {
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("calendarContainer.json")

            let data = try Data(contentsOf: fileURL)
            let dictionary = try JSONSerialization.jsonObject(with: data)
            print(dictionary)
        } catch {
            print(error)
        }
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func done() {
        dataBase.calendars[calendarIndex].calendarName = calName
        dataBase.calendars[calendarIndex].color =  didSelectColor ? colorIndex : dataBase.calendars[calendarIndex].color
        
        saveData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func calendarNameChange(_ textField: UITextField) {
        if let text = textField.text {
            calName = text
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func isEventInCalendar() -> Bool{
        for calendar in dataBase.calendars {
            if !calendar.events.isEmpty { return false }
        }
        return true
    }
    
    func summonCalendars() {
        let url = getURL()
        guard let data = try? Data(contentsOf: url) else { return }
        dataBase = (try? JSONDecoder().decode(Calendars.self, from: data))!
    }
    
    func searchCalendar(name: String) -> Int {
        var position = Int()
        for i in 0..<dataBase.calendars.count {
            if dataBase.calendars[i].calendarName == name {
                position = i
                return position
            }
        }
        return position
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
}
