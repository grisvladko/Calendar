//
//  SearchResultTableViewController.swift
//  Calendar
//
//  Created by hyperactive on 23/07/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

class SearchResultTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchCell.self, forCellReuseIdentifier: "cell")
    }
}

class SearchCell: UITableViewCell {
    var event: Event!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
}
