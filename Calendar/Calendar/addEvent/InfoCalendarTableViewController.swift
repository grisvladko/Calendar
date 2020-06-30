//
//  InfoCalendarTableViewController.swift
//  Calendar
//
//  Created by hyperactive on 29/06/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

class InfoCalendarTableViewController: UITableViewController {
    
    @IBOutlet weak var calendarName: UITextField!
    @IBOutlet weak var red: UILabel!
    @IBOutlet weak var yellow: UILabel!
    @IBOutlet weak var orange: UILabel!
    @IBOutlet weak var green: UILabel!
    @IBOutlet weak var blue: UILabel!
    @IBOutlet weak var purple: UILabel!
    @IBOutlet weak var brown: UILabel!
    
    var labels = [UILabel]()
    var colors = [UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
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
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
    
    @IBAction func deleteCalendar(_ sender: Any) {
    }
    
    @objc func done(sender: UIBarButtonItem) {
    }
}
