//
//  AddCalendarTableViewController.swift
//  Calendar
//
//  Created by hyperactive on 29/06/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

class AddCalendarTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var red: UILabel!
    @IBOutlet weak var yellow: UILabel!
    @IBOutlet weak var orange: UILabel!
    @IBOutlet weak var green: UILabel!
    @IBOutlet weak var blue: UILabel!
    @IBOutlet weak var purple: UILabel!
    @IBOutlet weak var brown: UILabel!
    
    var color = Int()
    var calendarTitle = String()
    var labels = [UILabel]()
    var colors = [UIColor]()
    var dataBase: Calendars!
    var colorNames = [String]()
    @IBOutlet weak var calendarName: UITextField!
    
    @IBAction func editCalendarName(_ sender: Any) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        calendarTitle = calendarName.text ?? ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavBar()
        summonCalendars()
        labels = [red,yellow,orange,green,blue,purple,brown]
        colors = [.red,.yellow,.orange,.green,.blue,.purple,.brown]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeDotColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let nvc = self.presentingViewController
        if let vc = nvc?.children.first as? CalendarsTableViewController {
            DispatchQueue.main.async {
            vc.dataBase = self.dataBase
            vc.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.cellForRow(at: indexPath)?.accessoryView?.tintColor = .blue
            color = indexPath.row
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func done(sender: UIBarButtonItem) {
        saveData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func initNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem?.tintColor = .blue
        self.navigationItem.rightBarButtonItem?.tintColor = .blue
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func changeDotColor() {
        for i in 0..<labels.count {
            let dot: NSMutableAttributedString = NSMutableAttributedString(string: "●")
            dot.addAttribute(NSAttributedString.Key.foregroundColor, value: colors[i], range: NSRange(location:0,length: 1))
            labels[i].attributedText = dot
            labels[i].font = labels[i].font.withSize(10)
        }
    }
    
    func summonCalendars() {
        let url = getURL()
        guard let data = try? Data(contentsOf: url) else { return }
        dataBase = (try? JSONDecoder().decode(Calendars.self, from: data))
    }
    
    func saveData() {
        let calendar = MyCalendar.init(calendarName: calendarName.text ?? "Untitled Calendar", color: color)
         
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("calendarContainer.json")
            if dataBase != nil {
                dataBase.calendars.append(calendar)
            } else {
                dataBase = .init()
                dataBase.calendars.append(calendar)
            }
            
            try JSONEncoder().encode(dataBase).write(to: fileURL)
        } catch {
            print(error)
        }
    }
    
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
}

