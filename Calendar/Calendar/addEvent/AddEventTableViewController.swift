//
//  AddEventTableViewController.swift
//  Calendar
//
//  Created by hyperactive on 26/06/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

class AddEventTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var travelTimeLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var titleTxT: UITextField!
    @IBOutlet weak var urlTxT: UITextField!
    @IBOutlet var notesTxT: UITextField!
    
    var dataBase: Calendars!
    var colors = [UIColor]()
    
    //event variables
    var eventTitle: String?
    var location: String?
    var start: String?
    var end: String?
    var calendar: String?
    var alert: String?
    var timeRepeat: Int?
    var secondAlert: String?
    var URLS: String?
    var notes: String?
    
    var startDate = Date()
    var endDate = Date()
    var chosenCalendarName = String()
    var allDay = Bool()
    var isAllowedToSave = false
    var isEndDPHidden = true
    var isStartDPHidden = true
    var isSecondAlertHidden = true
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavBar()
        summonCalendars()
        titleTxT.addTarget(self, action: #selector(titleChange), for: .editingChanged)
        urlTxT.addTarget(self, action: #selector(urlChange), for: .editingChanged)
        notesTxT.addTarget(self, action: #selector(notesChange), for: .editingChanged)
        endDate = Calendar.current.date(byAdding: .hour, value: 1, to: startDate)!
        colors = [.red,.yellow,.orange,.green,.blue,.purple,.brown]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (1,1): toggleStartDatePicker()
        case (1,3): toggleEndDatePicker()
        default: break
        }
        
        if indexPath.section == 2 {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChooseCalendarTableViewController")
            self.show(vc, sender: nil)
        } else if indexPath.section == 3  && indexPath.row == 0{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "AlertTableViewController")
            self.show(vc, sender: nil)
        }
        
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isStartDPHidden && indexPath.section == 1 && indexPath.row == 2 {
            return 0
        } else if isEndDPHidden && indexPath.section == 1 && indexPath.row == 4{
            return 0
        } else if allDay && indexPath.section == 1 && indexPath.row == 6{
            return 0
        } else if indexPath.section == 3 && indexPath.row == 1 && isSecondAlertHidden {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
//            let dot: NSMutableAttributedString = NSMutableAttributedString(string: "●")
//            dot.addAttribute(NSAttributedString.Key.foregroundColor, value: colors[dataBase.calendars[indexPath.row].color], range: NSRange(location:0,length: 1))
            let label = UILabel.init(frame: calendarLabel.frame)
            label.textAlignment = .center
            label.font = label.font.withSize(11)
            calendarLabel.addSubview(label)
            calendarLabel.text = chosenCalendarName
        }
    }
   
    
    @IBAction func allDaySwitch(_ sender: Any) {
        allDay = (sender as! UISwitch).isOn
        if allDay { self.navigationItem.rightBarButtonItem?.isEnabled = true }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    @IBAction func didChangeStartDate() {
        startLabel.text = DateFormatter.localizedString(from: startDatePicker.date, dateStyle: .medium, timeStyle: .short)
        startDate = startDatePicker.date
    }
    
    @IBAction func didChangeEndDate() {
        endLabel.text = DateFormatter.localizedString(from: endDatePicker.date, dateStyle: .none, timeStyle: .short)
        endDate = endDatePicker.date
    }
    
    
    
    
    
    
    
    
    func initNavBar() {
        let add = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addEvent))
        add.tintColor = .blue
        navigationItem.rightBarButtonItem = add
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelEvent))
        cancel.tintColor = .blue
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem = cancel
    }
    
    func toggleStartDatePicker() {
        isStartDPHidden = !isStartDPHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func toggleEndDatePicker() {
        isEndDPHidden = !isEndDPHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @objc func notesChange(_ textField: UITextField) {
        if let text = textField.text {
            notes = text
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    @objc func urlChange(_ textField: UITextField) {
        if let text = textField.text {
            URLS = text
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    @objc func titleChange(_ textField: UITextField) {
        if let text = textField.text {
            eventTitle = text
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    @objc func cancelEvent() {
        let ac = UIAlertController(title: nil, message: "Are you sure you want to discard this new event?", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Discard Changes", style: .default, handler: cancel))
        ac.addAction(UIAlertAction(title: "Keep Editing", style: .cancel, handler: nil))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func cancel(action: UIAlertAction)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addEvent() {
        saveData()
        getSavedData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func summonCalendars() {
        let url = getURL()
        guard let data = try? Data(contentsOf: url) else { return }
        dataBase = (try? JSONDecoder().decode(Calendars.self, from: data))!
    }
    
    func convertDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE MMM-dd,yyyy HH:MM"
        start = dateFormatter.string(from: startDate)
        end = dateFormatter.string(from: endDate)
    }
    
    func makeEvent() -> Event{
        convertDate()
        let event = Event.init(title: eventTitle!, location: "location!", start: start!, end: end!, alert: "alert!", calendar: chosenCalendarName)
        appDelegate?.scheduleNotification(title: eventTitle!, date: startDate, identifier: String("\(eventTitle!)\(start)"))
        return event
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
        let event = makeEvent()
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("calendarContainer.json")
            if dataBase != nil {
                dataBase.calendars[searchCalendar(name: chosenCalendarName)].events.append(event)
            } else {
                dataBase = .init()
                dataBase.calendars[searchCalendar(name: chosenCalendarName)].events.append(event)
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
