//
//  YearTableViewCell.swift
//  Calendar
//
//  Created by hyperactive on 19/05/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

class YearTableViewCell: UITableViewCell {
    var innerYear = Int()
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.reloadData()
    }
}

class TableViewInnerCellDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    let innerDelegateTwo = InnerCellCollectionViewDelegateTwo()
    var innerYear = Int()
    var monthTapped = UIButton()
    let firstCell = "yearCell"

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: firstCell, for: indexPath) as! VGHYearCVCell
        
        cell.innerYear = innerYear
        cell.configureCollectionView(dt: innerDelegateTwo, withNibName: "YearCollectionViewCell", isInteractionEnabled: false)
        
        cell.showMonthButton.tag = indexPath.item 
        cell.yearViewMonthLabel.text = shortMonths[indexPath.item] //works fine
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 5 , right: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

class InnerCellCollectionViewDelegateTwo: NSObject,UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    var innerYear = Int()
    var i = 12
    var innerWeekDay = Int()
    
    let secondCellIdentifier = "secondCell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let tuple = dateComponentsInit(month: i, day: 1, year: innerYear)
        innerWeekDay = tuple.weekDay
        i = i == 1 ? 12 : i - 1
        let returnNumber = innerYear % 4 == 0 && i == 1 ? DaysInMonth[(tuple.month - 1)] + innerWeekDay :
                DaysInMonth[(tuple.month - 1)] + innerWeekDay - 1
        
        return innerWeekDay > 3 ? returnNumber : returnNumber + 7
    }
    
    //change the arrangement of the days,  play with it to set 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  secondCellIdentifier, for: indexPath) as! YearCollectionViewCell
     
        let text = innerWeekDay > 3 ? (indexPath.item + 1 < innerWeekDay ? "" : "\(indexPath.item + 1 - (innerWeekDay - 1))") : (indexPath.item + 1 < innerWeekDay + 7 ? "" : "\(indexPath.item + 1 - (innerWeekDay - 1) - 7)")
        
        var components = DateComponents()
        components.year = innerYear
        components.month = i + 1
        components.day = Int(text)
        let date = Calendar.current.date(from: components)!
        
        cell.label.text = text
        if Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedSame {
            cell.isSelected = true
            cell.label.textAlignment = .center
        }
        cell.label.font = .boldSystemFont(ofSize: 11)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 18.5, height: 18.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0 , right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class VGHYearCVCell: UICollectionViewCell {
    var innerYear = Int()
    
    @IBOutlet weak var showMonthButton: UIButton!
    
    @IBAction func monthTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "MonthTableViewController")
        var dateComponents = DateComponents()
        dateComponents.year = innerYear
        dateComponents.month = showMonthButton.tag + 1
        dateComponents.day = 1
        let date = Calendar.current.date(from: dateComponents)!
        (vc as? MonthTableViewController)?.date = date
        monthViewDate = date
        UIApplication.topViewController()?.navigationController?.show(vc, sender: nil)
    }
    
    @IBOutlet weak var yearViewMonthLabel: UILabel!
    let secondCellIdentifier = "secondCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    func configureCollectionView(dt: UICollectionViewDataSource & UICollectionViewDelegate, withNibName: String, isInteractionEnabled: Bool) {
        
        addSubview(collectionView)
        (dt as? InnerCellCollectionViewDelegateTwo)?.innerYear = self.innerYear
        
        collectionView.dataSource = dt
        collectionView.delegate = dt
        
        collectionView.isUserInteractionEnabled = isInteractionEnabled
        collectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    
        collectionView.register(UINib(nibName: withNibName, bundle: .main), forCellWithReuseIdentifier: secondCellIdentifier)
        
        collectionView.reloadData()
    }
}

