//
//  EventDetailsViewController.swift
//  Calendar
//
//  Created by hyperactive on 19/07/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

class EventDetailsViewController: UITableViewController {

    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventStart: UILabel!
    @IBOutlet weak var eventEnd: UILabel!
    @IBOutlet weak var eventRpeat: UILabel!
    @IBOutlet weak var calendarName: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    
    var dotLabel = UILabel()
    var alert = String()
    var chosenCalendarName: String?
    var eventGrid = SmallEventGrid()
    var dataBase: Calendars!
    var isAllDayTapped = false
    var event = Event()
    var currentCalendar = MyCalendar()
    var height: CGFloat = 0
    var drawnEvent = UIView()
    var colors = [UIColor]()
    var changedCalendar: Bool?
    var startDate = Date()
    var endDate = Date()
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summonCalendars()
        findCalendar()
        setBackButton()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        startDate = formatter.date(from: event.start)!
        endDate = formatter.date(from: event.end)!
        
        colors = [.red,.yellow,.orange,.green,.blue,.purple,.brown]
    
        eventRpeat.text = event.location
        eventTitle.text = event.title
        alertLabel.text = event.alert
        if !(event.allDay ?? false) {
            eventStart.text = DateFormatter.localizedString(from: startDate, dateStyle: .long, timeStyle: .medium)
            eventEnd.text = DateFormatter.localizedString(from: endDate, dateStyle: .long, timeStyle: .medium)
        } else {
            eventStart.text = DateFormatter.localizedString(from: startDate, dateStyle: .medium, timeStyle: .none)
            eventEnd.text = "All-Day"
        }
        toolbarItems = initTabBar()
        
        if !(event.allDay ?? false) {
            height = countHightForEvent(d1: startDate, d2: endDate)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(currentCalendar.calendarName)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        if changedCalendar ?? false {
            changeEventCalendar()
            saveData()
        }
        (navigationController?.topViewController as? WeekViewController)?.reloadTimeTable()
    }
    
   override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    if !(event.allDay ?? false){
            eventGrid = SmallEventGrid.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height),event: event)
            eventGrid.addSubview(drawnEvent)
            tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.addSubview(eventGrid)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 && event.allDay ?? false {
            return 0
        }
        else if indexPath.row == 1 && isAllDayTapped {
            return eventGrid.frame.height
        } else if indexPath.row == 4 && event.URLS == nil {
            return 0
        } else if indexPath.row == 5 && event.notes == nil {
            return 0
        }
        else { return super.tableView(tableView, heightForRowAt: indexPath) }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            toggleSecondRow()
        } else if indexPath.row == 2 {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChooseCalendarTableViewController")
            self.show(vc, sender: nil)
        } else if indexPath.row == 3 {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "AlertTableViewController")
            self.show(vc, sender: nil)
        }
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: false)
    }
    
    func toggleSecondRow() {
        isAllDayTapped = !isAllDayTapped
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 1 && isAllDayTapped {
            
        } else if indexPath.row == 2 {
            if chosenCalendarName == nil {
                setCalendarDot()
                cell.addSubview(dotLabel)
            } else {
                changeChosenCalendarDot()
            }
        } else if indexPath.row == 3 {
            alertLabel.text = event.alert
        } else if indexPath.row == 4 && event.URLS != nil {
            cell.accessoryType = .none
            cell.detailTextLabel?.text = event.URLS
        } else if indexPath.row == 5 && event.notes != nil {
            cell.accessoryType = .none
            cell.detailTextLabel?.text = event.notes
        }
    }
    
    func initTabBar() -> [UIBarButtonItem] {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let delete = UIBarButtonItem(title: "Delete Event", style: .plain, target: self, action: #selector(deleteEvent))
        delete.tintColor = .blue
        return [spacer,delete,spacer]
    }
    
    @objc func deleteEvent() {
        let ac = UIAlertController(title: nil, message: "Are you sure you want to delete this event?", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Delete Event", style: .default, handler: delete))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func countHightForEvent(d1: Date, d2: Date) -> CGFloat {
        let startHour = Calendar.current.component(.hour, from: d1) - 1
        let endHour = Calendar.current.component(.hour, from: d2) - 1
        let startMin = Calendar.current.component(.minute, from: d1)
        let endMin = Calendar.current.component(.minute, from: d2)
        
        let result = CGFloat((Double(endHour) * 35.0 + ((3.5/6) * Double(endMin))) - (Double(startHour) * 35.0 + ((3.5/6) * Double(startMin)))) + 20
        
        let widthAndX = dataBase.widthForEvent(date: d1, event: self.event)
        
        drawnEvent = UIView(frame: CGRect(x: widthAndX.x, y: 10, width: widthAndX.width, height: result - 20))
        drawnEvent.backgroundColor = colors[currentCalendar.color].withAlphaComponent(0.8)
        let label = UILabel.init(frame: CGRect(x: 5, y: 0, width: drawnEvent.bounds.width, height: 20))
        label.text = event.title
        
        drawnEvent.addSubview(label)
        
        return result < 35 * 5 ? 35 * 5 : result
    }
    
    func reloadSmallGrid() {
        summonCalendars()
        eventTitle.text = event.title
        eventGrid.removeFromSuperview()
        if !(event.allDay ?? false) {
            eventStart.text = event.start
            eventEnd.text = event.end
            height = countHightForEvent(d1: startDate, d2: endDate)
            eventGrid = SmallEventGrid.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height),event: event)
            eventGrid.addSubview(drawnEvent)
            tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.addSubview(eventGrid)
        }
        changeChosenCalendarDot()
        tableView.reloadData()
    }
    
    func findChosenCalendar() {
        for calendar in dataBase.calendars {
            if calendar.calendarName == currentCalendar.calendarName {
                currentCalendar = calendar
            }
        }
    }
    
    func changeChosenCalendarDot() {
        findChosenCalendar()
        dotLabel.backgroundColor = colors[currentCalendar.color]
        calendarName.text = currentCalendar.calendarName
    }
    
    func setCalendarDot() {
        let x = calendarName.frame.origin.x - 15
        dotLabel = UILabel(frame: CGRect(x: x, y: 17, width: 10, height: 10))
        dotLabel.layer.cornerRadius = 10 / 2
        dotLabel.layer.masksToBounds = true
        dotLabel.tag = 1
        dotLabel.backgroundColor = colors[currentCalendar.color]
        calendarName.text = chosenCalendarName ?? currentCalendar.calendarName

    }
    
    func findCalendar() {
        for calendar in dataBase.calendars {
            for i in 0..<calendar.events.count {
                if calendar.events[i].isEqual(event: event) {
                    currentCalendar = calendar
                    return
                }
            }
        }
    }
    
    func changeEventCalendar() {
        for i in 0..<dataBase.calendars.count {
            dataBase.calendars[i].events.removeAll(where: { $0.isEqual(event: event)})
        }
        for i in 0..<dataBase.calendars.count {
            if dataBase.calendars[i].isEqual(calendar: currentCalendar) {
                dataBase.calendars[i].events.append(event)
            }
        }
    }
    
    func delete(action: UIAlertAction) {
        for i in 0..<dataBase.calendars.count {
            dataBase.calendars[i].events.removeAll(where: { $0.isEqual(event: event)})
        }
        saveData()
        navigationController?.popViewController(animated: true)
    }
    
    func summonCalendars() {
        let url = getURL()
        guard let data = try? Data(contentsOf: url) else { return }
        dataBase = (try? JSONDecoder().decode(Calendars.self, from: data))!
    }
    
    func setBackButton() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let d1 = formatter.date(from: event.start)!
        let str = DateFormatter.localizedString(from: d1, dateStyle: .short, timeStyle: .none)
    
        let b = UIBarButtonItem(title: str, style: .plain, target: self, action: nil)
        
        b.tintColor = .blue
        navigationController?.navigationBar.topItem?.backBarButtonItem = b
        
        let e = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(edit))
        e.tintColor = .blue
        navigationItem.rightBarButtonItem = e
    }
    
    @objc func edit() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddEventTableViewController")
        
        (vc as? AddEventTableViewController)?.passedEvent = event
        
        let nav = UINavigationController.init(rootViewController: vc)
        nav.setToolbarHidden(false, animated: false)
        self.present(nav, animated: true, completion: nil)
    }
    
    func saveData() {
        makeNotification()
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("calendarContainer.json")
            
            for var calendar in dataBase.calendars {
                calendar.events.sort(by: {
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
            }
            try JSONEncoder().encode(dataBase).write(to: fileURL)
        } catch {
            print(error)
        }
    }
    
    func makeNotification() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let d1 = formatter.date(from: event.start)!
        
        var components: DateComponents? = DateComponents()
        
            components!.year = Calendar.current.component(.year, from: d1)
            components!.month = Calendar.current.component(.month, from: d1)
            components!.day = Calendar.current.component(.day, from: d1)
            components!.hour = Calendar.current.component(.hour, from: d1)
            components!.minute = Calendar.current.component(.minute, from: d1)
            
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
            
        appDelegate?.scheduleNotification(title: event.title, date: d1, identifier: String("\(event.title)\(event.start)\(event.end)"),components: components)
    }
}


class SmallEventGrid: UIView {
    
    var path = UIBezierPath()
    var event = Event()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(frame: CGRect, event: Event) {
        self.init(frame:frame)
        self.event = event
    }
    
    func setup() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let d1 = formatter.date(from: event.start)!
        let d2 = formatter.date(from: event.end)!
        
        let startHour = Calendar.current.component(.hour, from: d1) - 1
        var endHour = Calendar.current.component(.hour, from: d2) - 1
        if endHour - startHour < 4 { endHour = startHour + 4}
        
        var startPoint = CGPoint(x: 40, y: 10)
        path.lineWidth = 1.0
       
        for _ in startHour...endHour {
            path.move(to: startPoint)
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: startPoint.y))
            startPoint.y += 35.0
        }
        path.close()
    }
    
    func drawLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let d1 = formatter.date(from: event.start)!
        let d2 = formatter.date(from: event.end)!
        
        let startHour = Calendar.current.component(.hour, from: d1)
        var endHour = Calendar.current.component(.hour, from: d2)
        
        if endHour - startHour < 4 { endHour = startHour + 4}
        
        var startPoint = CGPoint(x: 0, y: 0)
        let array = ["12 AM","1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "Noon", "1 PM","2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM","12 AM"]
        
        for i in startHour..<endHour {
            if i >= array.count || i < 0 { break }
            let label = UILabel.init(frame: CGRect(x: startPoint.x, y: startPoint.y, width: 40, height: 15))
            label.text = array[i]
            label.textAlignment = .right
            label.textColor = .lightGray
            label.font = label.font.withSize(12)
            self.addSubview(label)
            startPoint.y += 35.0
        }
    }
    
    override func draw(_ rect: CGRect) {
        setup()
        UIColor.lightGray.setStroke()
        path.stroke()
        drawLabel()
    }
}
