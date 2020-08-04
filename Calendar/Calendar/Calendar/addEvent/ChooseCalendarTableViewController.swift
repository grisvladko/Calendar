//
//  ChooseCalendarTableViewController.swift
//  Calendar
//
//  Created by hyperactive on 30/06/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

class ChooseCalendarTableViewController: UITableViewController {
    
    var dataBase: Calendars!
    var calendar: MyCalendar?
    var colors = [UIColor]()
    var chosenCalendarName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
        let b = UIBarButtonItem(title: "back", style: .plain, target: nil, action: nil)
        b.tintColor = .blue
        navigationController?.navigationBar.topItem?.backBarButtonItem = b
        summonCalendars()
        colors = [.red,.yellow,.orange,.green,.blue,.purple,.brown]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //for addEvent
        if let vc = (navigationController?.topViewController as? AddEventTableViewController) {
            vc.chosenCalendarName = chosenCalendarName
            vc.currentCalendar = calendar ?? vc.currentCalendar
        }
        
        if let vc = (navigationController?.topViewController as? EventDetailsViewController) {
            vc.chosenCalendarName = chosenCalendarName
            vc.currentCalendar = calendar ?? vc.currentCalendar
            vc.changedCalendar = true
            vc.reloadSmallGrid()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBase.calendars.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        chosenCalendarName = dataBase.calendars[indexPath.row].calendarName
        calendar = dataBase.calendars[indexPath.row]
        self.navigationController?.popViewController(animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        for _ in 0..<dataBase.calendars.count{
            let label = UILabel.init(frame: CGRect(x: 40, y: 0, width: UIScreen.main.bounds.width, height: 40))
            label.text = dataBase.calendars[indexPath.row].calendarName
            cell.addSubview(label)
            
            let label2 = UILabel(frame: CGRect(x: 15, y: 15, width: 10, height: 10))
            label2.layer.cornerRadius = 10 / 2
            label2.layer.masksToBounds = true
            label2.backgroundColor = colors[dataBase.calendars[indexPath.row].color]
            cell.addSubview(label2)
        }
        
        return cell
    }
    
    func summonCalendars() {
        let url = getURL()
        guard let data = try? Data(contentsOf: url) else { return }
        dataBase = (try! JSONDecoder().decode(Calendars.self, from: data))
    }
}
