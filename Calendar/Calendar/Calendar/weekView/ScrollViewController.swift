//
//  ScrollViewController.swift
//  Calendar
//
//  Created by hyperactive on 22/06/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {
    
    @IBOutlet weak var gridScrollView: UIScrollView!
    
    override func loadView() {
        super.loadView()
        
        let view: WeekView = .fromNib()
        view.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
//        view.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 100)
        view.frame.origin.y = (navigationController?.navigationBar.frame.height)!
        let dateFormmater = DateFormatter()
        print(scrollViewDate)
        dateFormmater.dateFormat = "EEEE MMM-dd,yyyy"
        let d = Calendar.current.date(byAdding: .day, value: -1, to: scrollViewDate)!
        view.selectedDate.text = dateFormmater.string(from: d)
        dateFormmater.dateFormat = "MMM"
        
        let back = UIBarButtonItem(title: dateFormmater.string(from: d), style: .plain, target: self, action: nil)
        back.tintColor = .blue
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = back
        self.view.addSubview(view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let grid = EventGrid(frame: CGRect(x: 0, y: gridScrollView.frame.origin.y, width: UIScreen.main.bounds.width, height: 50.0 * 25.5))
        gridScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 50.0 * 25.5)
        gridScrollView.addSubview(grid)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let back = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        back.tintColor = .blue
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = back
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
        let vc = storyboard.instantiateViewController(withIdentifier: "MonthTableViewController")
        self.show(vc, sender: nil)
    }
    
    @objc func selenium() {
        print("BOMZHI!")
    }
}

class WeekView: UIView {
        
    @IBOutlet weak var selectedDate: UILabel!
    let dayLabels = ["S","M","T","W","T","F","S"]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        setup()
    }
    
    func setup() {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
        var x:CGFloat = 0.0
        for i in 0..<7 {
            let label = UILabel.init(frame: CGRect(x: x, y: 0, width: UIScreen.main.bounds.width / 7, height: 20))
            label.text = dayLabels[i]
            label.textColor = i == 0 || i == 6 ? .blue : .black
            label.textAlignment = .center
            view.addSubview(label)
            x += UIScreen.main.bounds.width / 7
        }
        view.backgroundColor = .clear
        self.addSubview(view)
    }
}


class MyInfiniteScrollView: UIScrollView, UIScrollViewDelegate {
    
    var date = (day: Int(), month: Int(), year: Int(),weekDay: Int())
    var realDate = Date()
    var minDate = Date()
    var maxDate = Date()
    var weeks = [UIView]()
    var oldContentOffset = CGPoint()
    var newContentOffset = CGPoint()
    var days = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var daysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var calendar = Calendar.current
    var buttons = [UIButton]()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentSize = CGSize(width: UIScreen.main.bounds.width * 3, height: 50)
        self.isPagingEnabled = true
        self.delegate = self
        realDate = scrollViewDate
        let day = calendar.component(.day, from: realDate) - 1
        initWeek(day: day)
        
        var xPosition: CGFloat = 0.0
        var startIndex = 0
        for _ in 0..<3 {
            let view = drawWeekView(atXposition: xPosition, startIndex: startIndex)
            weeks.append(view)
            self.addSubview(view)
            xPosition += UIScreen.main.bounds.width
            startIndex += 7
        }
        self.setContentOffset(CGPoint(x: weeks[1].bounds.maxX, y: 0), animated: false)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        oldContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        newContentOffset = scrollView.contentOffset
        if oldContentOffset.x < newContentOffset.x {
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
                self.addSubview(weeks[i])
            }
            self.setContentOffset(CGPoint(x: 414, y: 0), animated: false)
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
                self.addSubview(weeks[i])
            }
            self.setContentOffset(CGPoint(x: 414, y: 0), animated: false)
        }
    }
    
    func drawWeekView(atXposition: CGFloat, startIndex: Int) -> UIView {
        let view = UIView.init(frame: CGRect(x: atXposition, y: 0, width: UIScreen.main.bounds.width, height: 50))
        var xPosition = 5.0
        for  i in startIndex..<(startIndex + 7) {
            let button = UIButton.init(frame: CGRect(x: xPosition, y: 0, width: 40, height: 40))
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(ScrollViewController.selenium), for: .touchUpInside)
            button.tag = days[i]
            button.setTitle(String(days[i]), for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = button.frame.size.width / 2
            view.addSubview(button)
            buttons.append(button)
            xPosition += Double(UIScreen.main.bounds.width / 7)
        }
        return view
    }
    
    @objc func selectedDate(sender : UIButton) {
        for button in buttons {
            button.backgroundColor = .clear
            button.setTitleColor(.black, for: .normal)
        }
        sender.backgroundColor = .blue
        sender.setTitleColor(.white, for: .normal)
    }
    
    func changeDaysOnRight() {
        maxDate = calendar.date(byAdding: .day, value: 1, to: maxDate)!
        var day = calendar.component(.day, from: maxDate)
        for i in 0..<14 {
            days[i] = days[i + 7]
        }
        for i in 14..<21 {
            days[i] = day
            maxDate = calendar.date(byAdding: .day, value: 1, to: maxDate)!
            day = calendar.component(.day, from: maxDate)
        }
        maxDate = calendar.date(bySetting: .day, value: days[days.count - 1], of: maxDate)!
        minDate = calendar.date(bySetting: .day, value: days[0], of: minDate)!
//        buttons.removeFirst(7)
    }
    
    func changeDaysOnLeft() {
        minDate = calendar.date(byAdding: .day, value: -1, to: minDate)!
        var day = calendar.component(.day, from: minDate)
        
        for i in stride(from: 20, through: 7, by: -1) {
            days[i] = days[i - 7]
        }
        
        for i in stride(from: 6, through: 0, by: -1){
            days[i] = day
            minDate = calendar.date(byAdding: .day, value: -1, to: minDate)!
            day = calendar.component(.day, from: minDate)
        }
        maxDate = calendar.date(bySetting: .day, value: days[days.count - 1], of: maxDate)!
        minDate = calendar.date(bySetting: .day, value: days[0], of: minDate)!
//        buttons.removeLast(7)
    }
    
    func initWeek(day: Int) {
        let weekDay = calendar.component(.weekday, from: realDate) + 5
        days[weekDay] = day
        
        var index = weekDay == 0 ? 0 : weekDay - 1
  
        minDate = calendar.date(byAdding: .day, value: -1, to: realDate)!
        
        for i in stride(from: index, through: 0, by: -1){
            minDate = calendar.date(byAdding: .day, value: -1, to: minDate)!
            days[i] = calendar.component(.day, from: minDate)
        }
        
        index = weekDay + 1
        maxDate = realDate
        for i in index..<days.count {
            days[i] = calendar.component(.day, from: maxDate)
            maxDate = calendar.date(byAdding: .day, value:  1, to: maxDate)!
        }
        maxDate = calendar.date(bySetting: .day, value: days[days.count - 1], of: maxDate)!
        minDate = calendar.date(bySetting: .day, value: days[0], of: minDate)!
    }
}
