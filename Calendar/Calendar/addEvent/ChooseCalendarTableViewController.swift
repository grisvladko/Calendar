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
    var colors = [UIColor]()
    var chosenCalendarName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem?.tintColor = .blue
        summonCalendars()
        colors = [.red,.yellow,.orange,.green,.blue,.purple,.brown]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let nvc = self.presentingViewController
        if let vc = nvc?.children.first as? AddEventTableViewController {
            DispatchQueue.main.async {
                vc.chosenCalendarName = self.chosenCalendarName
                vc.tableView.reloadData()
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBase.calendars.count
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        chosenCalendarName = dataBase.calendars[indexPath.row].calendarName
        self.navigationController?.popViewController(animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        for _ in 0..<dataBase.calendars.count{
            let label = UILabel.init(frame: CGRect(x: 40, y: 10, width: UIScreen.main.bounds.width, height: 40))
            label.text = dataBase.calendars[indexPath.row].calendarName
            cell.addSubview(label)
        }
        for _ in 0..<dataBase.calendars.count{
            let dot: NSMutableAttributedString = NSMutableAttributedString(string: "●")
            dot.addAttribute(NSAttributedString.Key.foregroundColor, value: colors[dataBase.calendars[indexPath.row].color], range: NSRange(location:0,length: 1))
            let label = UILabel.init(frame: CGRect(x: 15, y: 11, width: 25, height: 40))
            label.attributedText = dot
            label.font = label.font.withSize(10)
            cell.addSubview(label)
        }
        
        return cell
    }
    
    func changeDotColor(){
        for i in 0..<dataBase.calendars.count{
            let dot: NSMutableAttributedString = NSMutableAttributedString(string: "●")
            dot.addAttribute(NSAttributedString.Key.foregroundColor, value: colors[i], range: NSRange(location:0,length: 1))
            let label = UILabel.init(frame: CGRect(x: 10, y: 10, width: 25, height: 30))
            label.attributedText = dot
            label.font = label.font.withSize(10)
        }
    }
    
    func summonCalendars() {
        let url = getURL()
        guard let data = try? Data(contentsOf: url) else { return }
        dataBase = (try! JSONDecoder().decode(Calendars.self, from: data))
    }
}
