//
//  AlertTableViewController.swift
//  Calendar
//
//  Created by hyperactive on 30/06/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

class AlertTableViewController: UITableViewController {
    
    var alert: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let b = UIBarButtonItem(title: "back", style: .plain, target: nil, action: nil)
               b.tintColor = .blue
               navigationController?.navigationBar.topItem?.backBarButtonItem = b
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (navigationController?.topViewController as? AddEventTableViewController)?.alert = alert
        (navigationController?.topViewController as? EventDetailsViewController)?.alert = alert
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            alert = "None"
        } else {
            switch indexPath.row {
                case 1: alert = "5"
                case 2: alert = "10"
                case 3: alert = "15"
                case 4: alert = "30"
                case 5: alert = "1h"
                case 6: alert = "2h"
                case 7: alert = "1d"
                case 8: alert = "2d"
                case 9: alert = "1w"
                default: alert = "0"
            }
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        self.navigationController?.popViewController(animated: true)
    }
}
