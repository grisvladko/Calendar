//
//  CalendarVariables.swift
//  Calendar_v3
//
//  Created by hyperactive on 23/04/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import Foundation
import UIKit

//current day
var date = Date()
var calendar = Calendar.current
var day  = calendar.component(.day, from: date)
var weekDay = Date().startOfMonth()
var month = calendar.component(.month, from: date) - 1
var year = calendar.component(.year, from: date)

var someYearVar = 2020
var newDateComponents = DateComponents()

var countMonthInit = 1

let months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
let shortMonths = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
let DaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
var currentMonth = "lolipop"

func getStartDate(month: Int, year: Int) -> Date {
    var comp = DateComponents()
    let cal = Calendar.current
    comp.month = month
    comp.year = year
    guard let date = cal.date(from: comp) else { return Date() }
    return date
}

extension Date {
    func startOfMonth() -> Int {
        let c = Calendar.current
        return c.component(.weekday, from: Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!)
    }
}

func initNavBarButtons() -> [UIBarButtonItem] {
    let add = UIBarButtonItem(barButtonSystemItem: .add, target: YearTableViewController(), action: #selector(YearTableViewController.addReminder))
    let search = UIBarButtonItem(barButtonSystemItem: .search, target: YearTableViewController(), action: #selector(YearTableViewController.addReminder))
    
    return [add,search]
}

func initTabBarButtons() -> [UIBarButtonItem] {
    
    let Today = UIBarButtonItem(title: "Today", style: .plain, target: YearTableViewController(), action: #selector(YearTableViewController.addReminder))
    let Calendar = UIBarButtonItem(title: "Calendar", style: .plain, target: YearTableViewController(), action: #selector(YearTableViewController.addReminder))
    let Inbox = UIBarButtonItem(title: "Inbox", style: .plain, target: YearTableViewController(), action: #selector(YearTableViewController.addReminder))
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    return [Today,spacer,Calendar,spacer,Inbox]
}

func dateComponentsInit(month: Int, day: Int, year: Int) -> (weekDay: Int, month: Int, year: Int){
    let clndr = Calendar.current
    let date = getStartDate(month: month, year: year)
    let m = clndr.component(.month, from: date)
    let d = clndr.component(.weekday, from: date) 
    let y = clndr.component(.year, from: date)
    return (d,m,y)
}
