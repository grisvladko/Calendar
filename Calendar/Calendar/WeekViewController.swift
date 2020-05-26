//
//  WeekViewController.swift
//  Calendar
//
//  Created by hyperactive on 20/05/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

class WeekViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekDay", for: indexPath) as! WeekDayCell
        cell.weekDayLabel.text = String(indexPath.row + 1)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        toolbarItems = initTabBarButtons()
        navigationItem.rightBarButtonItems = initNavBarButtons()
        setTableView(self.view)
    }
}

class WeekDayCell: UICollectionViewCell {
    @IBOutlet weak var weekDayLabel: UILabel!
}

class TimeTable : UITableView, UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TimeCell()
        if indexPath.row > 0  && indexPath.row < 7 {
            cell.topTime = "\(indexPath.row)AM"
            cell.bottomTime = "\(indexPath.row + 1)AM"
        } else if indexPath.row > 6 && indexPath.row < 13 {
            cell.topTime = "\(indexPath.row)PM"
            cell.bottomTime = "\(indexPath.row + 1)PM"
        } else {
            cell.topTime = ""
        }
        return cell
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("initWithCoder has not been implemented")
    }
    
    func setupTable()
    {
        self.delegate = self
        self.dataSource = self
        self.rowHeight = 50
        self.estimatedRowHeight = 50
        self.separatorStyle = .none
        // to allow scrolling below the last cell
        self.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
    }
}

//change and add red line
class TimeCell: UITableViewCell {
    // little "hack" using two labels to render time both above and below the cell
    private let topTimeLabel = UILabel()
    private let bottomTimeLabel = UILabel()
    private let separatorLine = UIView()
    private let timeNow = UIBezierPath()
    
    var topTime: String = "" {
        didSet {
            topTimeLabel.text = topTime
        }
    }
    var bottomTime: String = "" {
        didSet {
            bottomTimeLabel.text = bottomTime
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        contentView.addSubview(topTimeLabel)
        contentView.addSubview(bottomTimeLabel)
        contentView.addSubview(separatorLine)

        topTimeLabel.textColor = UIColor.lightGray
        topTimeLabel.textAlignment = .right
        bottomTimeLabel.textColor = UIColor.lightGray
        bottomTimeLabel.textAlignment = .right
        separatorLine.backgroundColor = UIColor.lightGray
        
        bottomTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        topTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomTimeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            bottomTimeLabel.centerYAnchor.constraint(equalTo: self.bottomAnchor),
            bottomTimeLabel.widthAnchor.constraint(equalToConstant: 20),
            topTimeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            topTimeLabel.centerYAnchor.constraint(equalTo: self.topAnchor),
            topTimeLabel.widthAnchor.constraint(equalToConstant: 20),
            separatorLine.leftAnchor.constraint(equalTo: bottomTimeLabel.rightAnchor, constant: 8),
            separatorLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


func setTableView(_ view: UIView){
    let rect = CGRect(x: 0, y: 200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 200)
    let timeTable = TimeTable(frame: rect)
    view.addSubview(timeTable)
}

