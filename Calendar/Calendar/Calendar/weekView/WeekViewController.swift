//
//  WeekViewController.swift
//  Calendar
//
//  Created by hyperactive on 16/07/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit
import Foundation

var scrollViewDate = Date()
class WeekViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var eventScrollView: UIScrollView!
    
    var weekScrollView: UIScrollView!
    var dateLabel: UILabel!
    
    var count = 0
    var realDate = Date()
    var minDate = Date()
    var maxDate = Date()
    
    var allDayView: UIView?
    var grid = EventGrid()
    var weeks = [UIView]()
    var oldContentOffset = CGPoint()
    var newContentOffset = CGPoint()
    var dates: [Date]!
    var days = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var daysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var calendar = Calendar.current
    var buttons = [DateButton]()
    var dataBase: Calendars!
    var events = [Event]()
    var eventViews = [UIView]()
    var colors = [UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summonCalendars()
        colors = [.red,.yellow,.orange,.green,.blue,.purple,.brown]
        toolbarItems = initTabBarButtons()
        navigationItem.rightBarButtonItems = initNavBarButtons()
        setBackButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setWeekViewConstraints()
        drawTimeTable()
        searchEvent()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
           oldContentOffset = scrollView.contentOffset
       }
       
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        newContentOffset = scrollView.contentOffset
    
        if oldContentOffset.x < newContentOffset.x {
            
            count += 1
             print("\(count) didScroll")
            for i in 0..<3 {
                weeks[i].removeFromSuperview()
            }
            weeks[0] = weeks[1]
            weeks[0].frame.origin = CGPoint(x: 0, y: 0)
            weeks[1] = weeks[2]
            weeks[1].frame.origin = CGPoint(x: 414, y: 0)
            changeDaysOnRight()
            let view = drawWeekView(atXposition: 828,startIndex: 14)
            weeks[2] = view
            for i in 0..<3 {
                weekScrollView.addSubview(weeks[i])
            }
            weekScrollView.setContentOffset(CGPoint(x: 414, y: 0), animated: false)
        } else if oldContentOffset.x > newContentOffset.x {
            for i in 0..<3 {
                weeks[i].removeFromSuperview()
            }
            weeks[2] = weeks[1]
            weeks[2].frame.origin = CGPoint(x: 828, y: 0)
            weeks[1] = weeks[0]
            weeks[1].frame.origin = CGPoint(x: 414, y: 0)
            changeDaysOnLeft()
            let view = drawWeekView(atXposition: 0,startIndex: 0)
            weeks[0] = view
            for i in 0..<3 {
                weekScrollView.addSubview(weeks[i])
            }
            weekScrollView.setContentOffset(CGPoint(x: 414, y: 0), animated: false)
        }
    }
    
    func drawTimeTable() {
        grid = EventGrid(frame: CGRect(x: 0, y: eventScrollView.frame.origin.y, width: UIScreen.main.bounds.width, height: 50.0 * 25.5))
        grid.date = scrollViewDate
        eventScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 50.0 * 26.5)
        eventScrollView.addSubview(grid)
    }
    
    func drawWeekView(atXposition: CGFloat, startIndex: Int) -> UIView {
        let view = UIView.init(frame: CGRect(x: atXposition, y: 0, width: UIScreen.main.bounds.width, height: 40))
        var xPosition = 12.5
        for  i in startIndex..<(startIndex + 7) {
            let ord = Calendar.current.compare(dates[i], to: scrollViewDate, toGranularity: .day)
            let button = DateButton.init(frame: CGRect(x: xPosition, y: 0, width: 35, height: 35))
            button.date = dates[i]
            if ord == .orderedSame {
                button.backgroundColor = .blue
                button.setTitleColor(.white, for: .normal)
                setDateLabel(date: dates[i])
                button.isSelected = true
            } else {
                let order = Calendar.current.compare(dates[i], to: Date(), toGranularity: .day)
                button.backgroundColor = order == ComparisonResult.orderedSame ? .cyan : .clear
                button.setTitleColor(.black, for: .normal)
            }
            button.addTarget(self, action: #selector(selectedDate(sender:)), for: .touchUpInside)
            let day = Calendar.current.component(.day, from: dates[i])
            button.setTitle(String(day), for: .normal)
            button.layer.cornerRadius = button.frame.size.width / 2
            view.addSubview(button)
            buttons.append(button)
            xPosition += Double(UIScreen.main.bounds.width / 7)
        }
        return view
    }
    
     @objc func selectedDate(sender : UIButton) {
            for button in buttons {
                let order = Calendar.current.compare(button.date, to: Date(), toGranularity: .day)
                button.backgroundColor = order == ComparisonResult.orderedSame ? .cyan : .clear
                button.setTitleColor(.black, for: .normal)
                button.isSelected = false
            }
            sender.isSelected = true
            sender.backgroundColor = .blue
            sender.setTitleColor(.white, for: .normal)
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE MMM-dd,yyyy"
            dateLabel.text = formatter.string(from: (sender as? DateButton)!.date )
            scrollViewDate = (sender as? DateButton)!.date
        
            reloadTimeTable()
        }
        
    func summonCalendars() {
        let url = getURL()
        guard let data = try? Data(contentsOf: url) else { return }
        dataBase = (try? JSONDecoder().decode(Calendars.self, from: data))!
    }
    
    func searchEvent(){
        for i in 0..<dataBase.calendars.count {
            if dataBase.calendars[i].isChecked {
                searchEventDate(calendar: dataBase.calendars[i], calendarIndex: i)
            }
        }
    }
    
    func drawAllDayEvent(event: Event, color: Int, i: CGFloat, count: CGFloat) {
        
        let widthAndX = dataBase.widthAndXForAllDay(date: scrollViewDate, event: event)
        
        let eventView = UIView(frame: CGRect(x: widthAndX.x, y: 3, width: widthAndX.width, height: 20))
        eventView.backgroundColor = colors[color].withAlphaComponent(0.6)
        let title = UILabel(frame: CGRect(x: 3, y: 3, width: eventView.frame.width, height: 15))
        title.text = event.title
        title.adjustsFontSizeToFitWidth = true
        title.font = title.font.withSize(10)
        eventView.addSubview(title)
        
        let g = EventGestureRecognizer.init(target: self, action: #selector(eventTapped))
        g.event = event
        eventView.addGestureRecognizer(g)
        
        allDayView?.addSubview(eventView)
    }
    
    func addAllDayView() {
        allDayView = UIView(frame: CGRect(x: 0, y: dateLabel.frame.maxY, width: UIScreen.main.bounds.width, height: 25))
        allDayView!.backgroundColor = .systemGray5
        let allDayLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 40, height: 15))
        allDayLabel.text = "All-Day"
        allDayLabel.font = allDayLabel.font.withSize(10)
        allDayView!.addSubview(allDayLabel)
        self.view.addSubview(allDayView!)
    }
    
    func searchEventDate(calendar: MyCalendar, calendarIndex: Int) {
        var tag = 0
        let cal = Calendar.current
        
        var allDayEvents: [Event] = []
        
        for event in calendar.events {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
            let start = formatter.date(from: event.start)!
            let end = formatter.date(from: event.end)!
            
            if event.allDay ?? false && cal.compare(scrollViewDate, to: start, toGranularity: .day) == .orderedSame {
                allDayEvents.append(event)
                continue
            }
            
            if scrollViewDate.isBetween(start, and: end) {
                //if the same day
                if cal.compare(scrollViewDate, to: start, toGranularity: .day) == .orderedSame {
                    
                    if cal.compare(scrollViewDate, to: end, toGranularity: .day) == .orderedSame {
                        let shour = cal.component(.hour, from: start)
                        let sminute = cal.component(.minute, from: start)
                        
                        let ehour = cal.component(.hour, from: end)
                        let eminute = cal.component(.minute, from: end)
                        
                        print("\(shour):\(sminute)  \(ehour):\(eminute)")
                        events.append(event)
                        
                        let widthAndX = dataBase.widthForEvent(date: start, event : event)
                        
                        drawEvent(startH: shour + 2, startMin: sminute, endH: ehour + 2, endMin: eminute, title: event.title, tag: tag, color: dataBase.calendars[calendarIndex].color, width: widthAndX.width,x: widthAndX.x,event: event)
                      
                        tag += 1
                    } else {
                        let shour = cal.component(.hour, from: start)
                        let sminute = cal.component(.minute, from: start)
                        let widthAndX = dataBase.widthForEvent(date: start, event : event)
                        
                        drawEvent(startH: shour + 2, startMin: sminute, endH: 23 + 2, endMin: 55, title: event.title, tag: tag, color: dataBase.calendars[calendarIndex].color,width: widthAndX.width,x: widthAndX.x,event: event)
                       
                    }
                        
                } else if cal.compare(scrollViewDate, to: start, toGranularity: .day) == .orderedDescending {
                    let shour = 0
                    let sminute = 0
                    
                    if cal.compare(scrollViewDate,to: end, toGranularity: .day) == .orderedSame {
                        let ehour = cal.component(.hour, from: end)
                        let eminute = cal.component(.minute, from: end)
                        events.append(event)
                        let widthAndX = dataBase.widthForEvent(date: start, event : event)
                       
                        drawEvent(startH: shour + 2, startMin: sminute, endH: ehour + 2, endMin: eminute, title: event.title, tag: tag, color: dataBase.calendars[calendarIndex].color,width: widthAndX.width,x: widthAndX.x,event: event)
                        
                    } else {
                        let widthAndX = dataBase.widthForEvent(date: start, event : event)
                       
                        drawEvent(startH: shour + 2, startMin: sminute, endH: 23 + 2, endMin: 55, title: event.title, tag: tag, color: dataBase.calendars[calendarIndex].color,width: widthAndX.width,x: widthAndX.x,event: event)
                      
                    }
                } else if cal.compare(scrollViewDate,to: end, toGranularity: .day) == .orderedAscending {
                    let shour = 0, sminute = 0, ehour = 23, eminute = 55
                    let widthAndX = dataBase.widthForEvent(date: start, event : event)
                    
                    drawEvent(startH: shour + 2, startMin: sminute, endH: ehour + 2, endMin: eminute, title: event.title, tag: tag, color: dataBase.calendars[calendarIndex].color,width: widthAndX.width,x: widthAndX.x,event: event)
                  
                }
                
            } else if cal.compare(scrollViewDate, to: start, toGranularity: .day) == .orderedSame {
                let shour = cal.component(.hour, from: start)
                let sminute = cal.component(.minute, from: start)
                
                let ehour = cal.component(.hour, from: end)
                let eminute = cal.component(.minute, from: end)
                
                print("\(shour):\(sminute)  \(ehour):\(eminute)")
                events.append(event)
                
                let widthAndX = dataBase.widthForEvent(date: start, event : event)
               
                drawEvent(startH: shour + 2, startMin: sminute, endH: ehour + 2, endMin: eminute, title: event.title, tag: tag, color: dataBase.calendars[calendarIndex].color,width: widthAndX.width,x: widthAndX.x,event: event)
              
                tag += 1
            }
        }
        
        for i in 0..<allDayEvents.count {
            if allDayView == nil {
                addAllDayView()
            }
            drawAllDayEvent(event: allDayEvents[i], color: calendar.color, i: CGFloat(i), count: CGFloat(allDayEvents.count))
        }
    }
    
    func drawEvent(startH: Int, startMin: Int, endH: Int, endMin: Int, title: String, tag: Int, color: Int, width : CGFloat, x: CGFloat, event: Event) {
        
        let view = UIView.init(frame: CGRect(x: x, y: CGFloat(Double(startH) * 50 + 10 + ((5/6) * Double(startMin))), width: width, height: CGFloat(((Double(endH) * 50.0 + ((5/6) * Double(endMin))) - (Double(startH) * 50.0 + ((5/6) * Double(startMin))) ))))
        
        view.backgroundColor = colors[color].withAlphaComponent(0.3)
        
        view.addBorders(edges: .left, color: colors[color], thickness: 2)
        
        let label = UILabel(frame: CGRect(x: 5, y: 0, width: view.bounds.width, height: 30))
        label.text = title
        label.adjustsFontSizeToFitWidth = true
    
        view.addSubview(label)
        let g = EventGestureRecognizer.init(target: self, action: #selector(eventTapped))
        g.event = event
        
        view.addGestureRecognizer(g)
        eventScrollView.addSubview(view)
        eventViews.append(view) //remmember to delete the view
    }
    
    func checkSameTimeEvents() {
        
    }
    
    @objc func eventTapped(sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "EventDetailsViewController")
        (vc as? EventDetailsViewController)!.event = (sender as? EventGestureRecognizer)!.event
        navigationController?.show(vc, sender: nil)
    }
    
        func changeDaysOnRight() {

            var max = calendar.date(byAdding: .day, value: 1, to: dates[dates.count - 1])!
            
            for i in 0..<14 {
                dates[i] = dates[i + 7]
            }
            for i in 14..<21 {
                dates[i] = max
                max = calendar.date(byAdding: .day, value: 1, to: max)!
            }
        }
        
        func changeDaysOnLeft() {
            var min = calendar.date(byAdding: .day, value: -1, to: dates[0])!
        
            for i in stride(from: 20, through: 7, by: -1) {
                dates[i] = dates[i - 7]
            }
            
            for i in stride(from: 6, through: 0, by: -1){
                dates[i] = min
                min = calendar.date(byAdding: .day, value: -1, to: min)!
            }
        }
    
    func newInit() {
        let weekDay = Calendar.current.component(.weekday, from: scrollViewDate)
        var start = Calendar.current.date(byAdding: .day, value: -(weekDay + 6), to: scrollViewDate)!
        dates = [Date]()
        dates.append(start)
        for _ in 0...19 {
            start = Calendar.current.date(byAdding: .day, value: 1, to: start)!
            dates.append(start)
        }
    }
    
    func initScrollView() {
        weekScrollView = UIScrollView(frame: CGRect(x: 0, y: 108, width: UIScreen.main.bounds.width, height: 40))
        weekScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 3, height: 40)
        weekScrollView.showsHorizontalScrollIndicator = false
        weekScrollView.isPagingEnabled = true
        weekScrollView.delegate = self
        
        newInit()
        
        var xPosition: CGFloat = 0.0
        var startIndex = 0
        for _ in 0..<3 {
            let view = drawWeekView(atXposition: xPosition, startIndex: startIndex)
            weeks.append(view)
            weekScrollView.addSubview(view)
            xPosition += UIScreen.main.bounds.width
            startIndex += 7
        }
        weekScrollView.setContentOffset(CGPoint(x: weeks[1].bounds.maxX, y: 0), animated: false)
    }
    
    func initDayBar() -> UIView{
        let dayLabels = ["S","M","T","W","T","F","S"]
        let view = UIView.init(frame: CGRect(x: 0, y: 88, width: UIScreen.main.bounds.width, height: 20))
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
        return view
    }
    
    func setWeekViewConstraints() {
        count += 1
        print("\(count) setWeekViewConstraints")
        let dayBar = initDayBar()
        dayBar.translatesAutoresizingMaskIntoConstraints = false
        
        initScrollView()
        
        dayBar.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        self.view.addSubview(dayBar)
        weekScrollView.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        self.view.addSubview(weekScrollView)
    }
    
    func setBackButton() {
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "MMM"
        let str = dateFormmater.string(from: scrollViewDate)
        let back = UIBarButtonItem(title: str, style: .plain, target: self, action: nil)
        back.tintColor = .blue
        navigationController?.navigationBar.topItem?.backBarButtonItem = back
    }
    
    func setDateLabel(date: Date) {
        dateLabel = UILabel(frame: CGRect(x: 0, y: 148, width: UIScreen.main.bounds.width, height: 30))
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "EEEE MMM-dd,yyyy"
        dateLabel.text = dateFormmater.string(from: date)
        
        dateLabel.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        dateLabel.textAlignment = .center
        self.view.addSubview(dateLabel)
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
        (vc as? AddEventTableViewController)?.startDate = passDatePickerDate()
        print((vc as? AddEventTableViewController)?.startDate ?? "MEOW!")
        let nav = UINavigationController.init(rootViewController: vc)
        nav.setToolbarHidden(false, animated: false)
        self.present(nav, animated: true, completion: nil)
    }
    
    func passDatePickerDate() -> Date{
        var date: Date?
        for button in buttons {
            if button.isSelected {
                date = button.date
            }
        }
        return date ?? Date()
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
        
    }
    
    func reloadTimeTable() {
        summonCalendars()
        for view in eventScrollView.subviews {
            view.removeFromSuperview()
        }
        allDayView?.removeFromSuperview()
        for v in allDayView?.subviews ?? [] {
            v.removeFromSuperview()
        }
        allDayView = nil
        drawTimeTable()
        searchEvent()
    }
}

class EventGrid: UIView {
    
    var date = Date()
    var path = UIBezierPath()
    var timePath: UIBezierPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup() {
        var startPoint = CGPoint(x: 40, y: 10)
        path.lineWidth = 1.0
       
        for _ in 0...24 {
            path.move(to: startPoint)
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: startPoint.y))
            startPoint.y += 50.0
        }
        path.close()
    }
    
    func drawLabel() {
        var startPoint = CGPoint(x: 0, y: 0)
        let array = ["12 AM","1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "Noon", "1 PM","2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM","12 AM"]
        
        for i in 0..<array.count {
            let label = UILabel.init(frame: CGRect(x: startPoint.x, y: startPoint.y, width: 40, height: 20))
            label.text = array[i]
            label.textAlignment = .right
            label.textColor = .lightGray
            label.font = label.font.withSize(12)
            self.addSubview(label)
            startPoint.y += 50.0
        }
    }
    
    override func draw(_ rect: CGRect) {
        setup()
        UIColor.lightGray.setStroke()
        path.stroke()
        drawLabel()
        if Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedSame {
            let timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(drawTimeLine), userInfo: nil, repeats: true)
            timer.fire()
        }
    }
    
    @objc func drawTimeLine() {
        
        for view in self.subviews {
            view.viewWithTag(1)?.removeFromSuperview()
        }
        timePath = nil
        self.setNeedsDisplay()
        timePath = UIBezierPath()
        
        let date = Date()
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        let y = CGFloat(Double(hour) * 50 + 10 + ((5/6) * Double(minute)))
        let startPoint = CGPoint(x: 40, y: y)
        
        timePath!.lineWidth = 1.0
        timePath!.move(to: startPoint)
        timePath!.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: startPoint.y))
        timePath!.close()
        UIColor.red.setStroke()
        timePath!.stroke()
        
        let label = UILabel.init(frame: CGRect(x: 0, y: startPoint.y - 10, width: 40, height: 20))
        label.text = "\(hour):\(minute)"
        label.textAlignment = .right
        label.textColor = .red
        label.font = label.font.withSize(8)
        label.tag = 1
        self.addSubview(label)
        self.setNeedsDisplay()
    }
}

class EventGestureRecognizer: UITapGestureRecognizer {
    var event: Event!
}

class DateButton: UIButton {
    var date: Date!
}

extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}


extension UIView {
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {

        var borders = [UIView]()

        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }


        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }

        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }

        return borders
    }
}
