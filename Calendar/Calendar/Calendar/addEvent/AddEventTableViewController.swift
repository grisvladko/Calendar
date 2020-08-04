//
//  AddEventTableViewController.swift
//  Calendar
//
//  Created by hyperactive on 26/06/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit
import MapKit

class AddEventTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var titleTxT: UITextField!
    @IBOutlet weak var urlTxT: UITextField!
    @IBOutlet var notesTxT: UITextField!
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var locationSubtitle: UILabel!
    @IBOutlet weak var switchOutlet: UISwitch!
    
    var dataBase: Calendars!
    var currentCalendar: MyCalendar?
    var passedEvent: Event?
    var colors = [UIColor]()
    
    //event variables
    var mapLocation: MKMapItem!
    var eventTitle: String?
    var location = String()
    var subtitle = String()
    var start: String?
    var end: String?
    var calendar: String?
    var alert: String?
    var timeRepeat: Int?
    var secondAlert: String?
    var URLS: String?
    var notes: String?
    var dotLabel: UILabel!
    
    var startDate = Date()
    var endDate = Date()
    var chosenCalendarName: String?
    var allDay: Bool?
    var isAllowedToSave = false
    var isEndDPHidden = true
    var isStartDPHidden = true
    var isSecondAlertHidden = true
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavBar()
        summonCalendars()
        setLabelSelectors()
        // to see what i have in the database
        getSavedData()
        endDate = Calendar.current.date(byAdding: .hour, value: 1, to: startDate)!
        colors = [.red,.yellow,.orange,.green,.blue,.purple,.brown]
        setDateLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationTitle.text = location == "" ? "Location" : location
        locationTitle.textColor = location == "" ? .gray : .black
        locationSubtitle.text =  subtitle 
        if chosenCalendarName != nil  && passedEvent == nil { setCalendarAfterChosen() }
        if let event = passedEvent {
            if chosenCalendarName != event.calendar {
                setCalendarAfterChosen()
            }
            locationTitle.text = event.location == "" ? "Location" : event.location
            locationTitle.textColor = event.location == "" ? .gray : .black
            location = event.location
            chosenCalendarName = event.calendar
            alertLabel.text = event.alert
            titleTxT.text = event.title
            urlTxT.text = event.URLS ?? ""
            notesTxT.text = event.notes ?? ""
            switchOutlet.isOn = event.allDay ?? false
            allDay = event.allDay
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let nvc = self.presentingViewController
        if let vc = nvc?.children.last as? MonthTableViewController {
            vc.innerDelegate.summonCalendars()
            vc.tableView.reloadData()
            return
        } else if let vc = nvc?.children.last as? WeekViewController {
            vc.reloadTimeTable()
            return
        }
        else if let vc = nvc?.children.last as? EventDetailsViewController {
            vc.chosenCalendarName = chosenCalendarName
            vc.currentCalendar = currentCalendar ?? vc.currentCalendar
            vc.event = passedEvent!
            vc.reloadSmallGrid()
        }
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
            navigationItem.rightBarButtonItem?.isEnabled = true
            self.show(vc, sender: nil)
        } else if indexPath.section == 3  && indexPath.row == 0{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "AlertTableViewController")
            self.show(vc, sender: nil)
        } else if indexPath.section == 0 && indexPath.row == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "LocationTableViewController")
            self.show(vc, sender: nil)
        }
        
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isStartDPHidden && indexPath.section == 1 && indexPath.row == 2 {
            return 0
        } else if isEndDPHidden && indexPath.section == 1 && indexPath.row == 4{
            return 0
        } else if allDay ?? false && indexPath.section == 1 && indexPath.row == 6{
            return 0
        } else if indexPath.section == 3 && indexPath.row == 1 && isSecondAlertHidden {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if chosenCalendarName == nil || passedEvent != nil {
                cell.addSubview(setCalendarRow())
            } else {
                setCalendarAfterChosen()
            }
        } else if indexPath.row == 1 && indexPath.section == 1 {
            startDatePicker.date = startDate
        } else if indexPath.row == 3 && indexPath.section == 1 {
            endDatePicker.date = endDate
        }
    }
   
    func setCalendarAfterChosen(){
        if chosenCalendarName == "" { return }
        for calendar in dataBase.calendars {
            if calendar.calendarName == chosenCalendarName {
                currentCalendar = calendar
                calendarLabel.text = calendar.calendarName
                dotLabel.backgroundColor = colors[calendar.color]
                break
            }
        }
    }
    
    func setUrlsAndNotes() {
        
    }
    
    //modify
    func setCalendarRow() -> UILabel{
        let x = calendarLabel.frame.origin.x - 15
        dotLabel = UILabel(frame: CGRect(x: x, y: 17, width: 10, height: 10))
        dotLabel.layer.cornerRadius = 10 / 2
        dotLabel.layer.masksToBounds = true
        dotLabel.tag = 1
        
        if let event = passedEvent {
            for calendar in dataBase.calendars {
                for e in calendar.events {
                    if e.isEqual(event: event) {
                        currentCalendar = calendar
                        dotLabel.backgroundColor = colors[calendar.color]
                        calendarLabel.text = calendar.calendarName
                        return dotLabel
                    }
                }
            }
        }
        
        for calendar in dataBase.calendars {
            if calendar.isChecked {
                dotLabel.backgroundColor = colors[calendar.color]
                calendarLabel.text = calendar.calendarName
                currentCalendar = calendar
                break
            }
        }
        
        return dotLabel
    }
    
    @IBAction func allDaySwitch(_ sender: Any) {
        allDay = (sender as! UISwitch).isOn
        setAllDay(bool: allDay ?? false)
        if allDay ?? false {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        startDate = startDatePicker.date
        endDate = endDatePicker.date
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    @IBAction func didChangeStartDate() {
        startLabel.text = DateFormatter.localizedString(from: startDatePicker.date, dateStyle: .medium, timeStyle: .short)
        startDate = startDatePicker.date
        endDate = Calendar.current.date(byAdding: .hour, value: 1, to: startDate)!
        endDatePicker.date = endDate
        endLabel.text = DateFormatter.localizedString(from: endDatePicker.date, dateStyle: .none, timeStyle: .short)
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @IBAction func didChangeEndDate() {
        endLabel.text = DateFormatter.localizedString(from: endDatePicker.date, dateStyle: .medium, timeStyle: .short)
        endDate = endDatePicker.date
        if Calendar.current.compare(startDatePicker.date, to: endDatePicker.date, toGranularity: .minute) == .orderedDescending {
            endLabel.strikeThrough(true)
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            endLabel.strikeThrough(false)
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func setAllDay(bool : Bool) {
        if bool {
            startDatePicker.datePickerMode = .date
            endDatePicker.datePickerMode = .date
            endLabel.text = DateFormatter.localizedString(from: endDatePicker.date, dateStyle: .medium, timeStyle: .none)
            startLabel.text = DateFormatter.localizedString(from: startDatePicker.date, dateStyle: .medium, timeStyle: .none)
        } else {
            startDatePicker.datePickerMode = .dateAndTime
            endDatePicker.datePickerMode = .dateAndTime
            didChangeEndDate()
            didChangeStartDate()
        }
    }
    
    func setLabelSelectors() {
        titleTxT.addTarget(self, action: #selector(titleChange), for: .editingChanged)
        urlTxT.addTarget(self, action: #selector(urlChange), for: .editingChanged)
        notesTxT.addTarget(self, action: #selector(notesChange), for: .editingChanged)
    }
    
    func setDateLabels() {
        
        if let event = passedEvent {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
            let d1 = formatter.date(from: event.start)!
            startDate = d1
            endDate = Calendar.current.date(byAdding: .hour, value: 1, to: startDate)!
        }
        
        startDatePicker.date = startDate
        endDatePicker.date = endDate
        
        startLabel.text = DateFormatter.localizedString(from: startDatePicker.date, dateStyle: .medium, timeStyle: .short)
        endLabel.text = DateFormatter.localizedString(from: endDatePicker.date, dateStyle: .none, timeStyle: .short)
    }
    
    func initNavBar() {
        if passedEvent != nil {
            let d = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
            d.tintColor = .blue
            navigationItem.rightBarButtonItem = d
        } else {
        let add = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addEvent))
        add.tintColor = .blue
        navigationItem.rightBarButtonItem = add
    }
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
    
    func cancel(action: UIAlertAction) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addEvent() {
        saveData()
        getSavedData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func done() {
        saveDataForEditing()
        getSavedData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func setEditingEventForSaving() {
        
        for i in 0..<dataBase.calendars.count {
            dataBase.calendars[i].events.removeAll(where: { $0.isEqual(event: passedEvent!)})
            currentCalendar!.events.removeAll(where: { $0.isEqual(event: passedEvent!)})
        }
        convertDate()
        passedEvent?.title = eventTitle ?? titleTxT.text!
        passedEvent?.allDay = allDay ?? false
        passedEvent?.start = start!
        passedEvent?.end = end!
        passedEvent?.alert = alert ?? "None"
        passedEvent?.location = location
        passedEvent?.calendar = currentCalendar?.calendarName ?? ""
        passedEvent?.notes = notes
        passedEvent?.URLS = URLS
    }
    
    func saveDataForEditing() {
        setEditingEventForSaving()
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("calendarContainer.json")
            if dataBase != nil {
                
            dataBase.calendars[searchCalendar()].events.append(passedEvent!)
                
                dataBase.calendars[searchCalendar()].events.sort(by: {
                    //sorted by length of events
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
                    let start1 = formatter.date(from: $0.start)!
                    let end1 = formatter.date(from: $0.end)!
                    let start2 = formatter.date(from: $1.start)!
                    let end2 = formatter.date(from: $1.end)!
                    
                    let length1 = (Calendar.current.component(.hour, from: end1) + (Calendar.current.component(.minute, from: end1) * (5/6)) ) - (Calendar.current.component(.hour, from: start1) + (Calendar.current.component(.minute, from: start1) * (5/6)))
                    
                    let length2 = (Calendar.current.component(.hour, from: end2) + (Calendar.current.component(.minute, from: end2) * (5/6)) ) - (Calendar.current.component(.hour, from: start2) + (Calendar.current.component(.minute, from: start2) * (5/6)))
                    
                    return length1 > length2
                })
            } else {
                dataBase = .init()
                dataBase.calendars[searchCalendar()].events.append(passedEvent!)
            }
            try JSONEncoder().encode(dataBase).write(to: fileURL)
        } catch {
            print(error)
        }
    }
    
    func summonCalendars() {
        let url = getURL()
        guard let data = try? Data(contentsOf: url) else { return }
        dataBase = (try? JSONDecoder().decode(Calendars.self, from: data))!
    }
    
    func convertDate() {
        start = "\(startDate)"
        end = "\(endDate)"
    }
    
    func makeEvent() -> Event{
        convertDate()
        
        var components: DateComponents? = DateComponents()
    
        components!.year = Calendar.current.component(.year, from: startDate)
        components!.month = Calendar.current.component(.month, from: startDate)
        components!.day = Calendar.current.component(.day, from: startDate)
        components!.hour = Calendar.current.component(.hour, from: startDate)
        components!.minute = Calendar.current.component(.minute, from: startDate)
        
        switch alert {
            case "0" : components!.minute! += 1
            case "5" : components!.minute! -= 5
            case "10": components!.minute! -= 10
            case "15": components!.minute! -= 15
            case "30": components!.minute! -= 30
            case "1h": components!.hour! -= 1
            case "2h": components!.hour! -= 2
            case "1d": components!.day! -= 1
            case "2d": components!.day! -= 2
            case "1w": components!.day! -= 7
            default: components = nil
        }
        
        let event = Event.init(title: eventTitle ?? "New Event", location: location, start: start!, end: end!, alert: alert ?? "None", calendar: currentCalendar?.calendarName ?? "", allDay: allDay,timeRepeat: timeRepeat,secondAlert: secondAlert,URLS: URLS,notes: notes)
        
        appDelegate?.scheduleNotification(title: eventTitle ?? "New Event", date: startDate, identifier: String("\(eventTitle ?? "New Event")\(start)\(end)"),components: components)
        
        return event
    }
    
    func searchCalendar() -> Int {
        var position = Int()
        for i in 0..<dataBase.calendars.count {
            if dataBase.calendars[i].isEqual(calendar: currentCalendar!) {
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
                
            dataBase.calendars[searchCalendar()].events.append(event)
                
                dataBase.calendars[searchCalendar()].events.sort(by: {
                    //sorted by length of events
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
                    let start1 = formatter.date(from: $0.start)!
                    let end1 = formatter.date(from: $0.end)!
                    let start2 = formatter.date(from: $1.start)!
                    let end2 = formatter.date(from: $1.end)!
                    
                    let length1 = (Calendar.current.component(.hour, from: end1) + (Calendar.current.component(.minute, from: end1) * (5/6)) ) - (Calendar.current.component(.hour, from: start1) + (Calendar.current.component(.minute, from: start1) * (5/6)))
                    
                    let length2 = (Calendar.current.component(.hour, from: end2) + (Calendar.current.component(.minute, from: end2) * (5/6)) ) - (Calendar.current.component(.hour, from: start2) + (Calendar.current.component(.minute, from: start2) * (5/6)))
                    
                    return length1 > length2
                })
            } else {
                dataBase = .init()
                dataBase.calendars[searchCalendar()].events.append(event)
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

extension UILabel {

func strikeThrough(_ isStrikeThrough:Bool) {
    if isStrikeThrough {
        if let lblText = self.text {
            let attributeString =  NSMutableAttributedString(string: lblText)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
            self.attributedText = attributeString
        }
    } else {
        if let attributedStringText = self.attributedText {
            //modify
            let txt = attributedStringText.string
            let str = NSMutableAttributedString(attributedString: attributedStringText)
            str.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0,str.length))
            
            self.attributedText = str
            
            return
        }
    }
    }
}
