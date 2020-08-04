//
//  NewWeekViewController.swift
//  Calendar
//
//  Created by hyperactive on 24/06/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//
// fucking indian 
import UIKit

class NewWeekViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedDate = String()
    var selectedDateIndex = Int()
    var monthToShow = String()
    var sevenDates = [String]()
    var lastDateInArray = String()
    var firstDateInArray = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7 - 5
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5.0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarDateCollectionViewCell
        cell.label.text = sevenDates[indexPath.row]
        return cell
    }
    
    func getSevenDates() {
        let selectedDataInString = self.selectedDate
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSFIX")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: selectedDataInString)!
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "EEEE"
        let weekDay = dateFormatter1.string(from: date)
        self.selectedDateIndex = 0
        switch weekDay {
        case "sunday": selectedDateIndex = 0
        case "monday": selectedDateIndex = 1
        case "tuesday": selectedDateIndex = 2
        case "wednesday": selectedDateIndex = 3
        case "thursday": selectedDateIndex = 4
        case "friday": selectedDateIndex = 5
        case "saturday": selectedDateIndex = 6
        default: break
        }
        
        var sevenDaysToShow: [String] = []
        sevenDaysToShow.removeAll()
        for index in 0..<7 {
            let newIndex = index - selectedDateIndex
            sevenDaysToShow.append(getDates(i: newIndex, currentDate: date).0)
        }
        
        let monthToSelectFrom = sevenDaysToShow[3]
        let dateFormatterMonth = DateFormatter()
        dateFormatterMonth.locale = Locale.init(identifier: "en_US_POSFIX")
        dateFormatterMonth.dateFormat = "dd-MM-yyyy"
        let monthDate = dateFormatterMonth.date(from: monthToSelectFrom)
        
        let dateFormatterMonth2 = DateFormatter()
        dateFormatterMonth2.dateFormat = "MMMM, yyyy"
        let month = dateFormatterMonth2.string(from: monthDate!)
        self.monthToShow = month
        
        self.lastDateInArray = sevenDaysToShow.last ?? ""
        self.firstDateInArray = sevenDaysToShow.first ?? ""
        self.sevenDates = sevenDaysToShow
    }
    
    func getDates(i: Int, currentDate: Date) -> (String,String){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "en_US")
        var date = currentDate
        let cal = Calendar.current
        date = cal.date(byAdding: .day, value: i, to: date)!
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let stringFormat = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let stringFormat2 = dateFormatter.string(from: date)
        return(stringFormat,stringFormat2)
    }
    
    func getNextSevenDays(ComplitionHandler: @escaping (String) -> Void) {
        let selectedDateInString = lastDateInArray
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "en_US_POSFIX")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: selectedDateInString)!
        
        var sevenDaysToShow: [String] = []
        sevenDaysToShow.removeAll()
        for index in 0..<7 {
            sevenDaysToShow.append(getDates(i: index, currentDate: date).0)
        }
        
        let monthToSelectFrom = sevenDaysToShow[3]
        let dateFormatterMonth = DateFormatter()
        dateFormatterMonth.locale = Locale.init(identifier: "en_US_POSFIX")
        dateFormatterMonth.dateFormat = "dd-MM-yyyy"
        let monthDate = dateFormatterMonth.date(from: monthToSelectFrom)!
        
        let dateFormatterMonth2 = DateFormatter()
        dateFormatterMonth2.dateFormat = "MMMM, yyyy"
        let month = dateFormatterMonth2.string(from: monthDate)
        monthToShow = month
        
        lastDateInArray = sevenDaysToShow.last ?? ""
        firstDateInArray = sevenDaysToShow.first ?? ""
        sevenDates = sevenDaysToShow
        return ComplitionHandler("success")
    }
    
    func getPreviousSevenDates(ComplitionHandler: @escaping (String) -> Void) {
        let selectedDateInString = firstDateInArray
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "en_US_POSFIX")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: selectedDateInString)!
        
        var sevenDaysToShow: [String] = []
        sevenDaysToShow.removeAll()
        var count = 7
        while count != 0 {
            sevenDaysToShow.append(getDates(i: count, currentDate: date).0)
            count -= 1
        }
        
        let monthToSelectFrom = sevenDaysToShow[3]
        let dateFormatterMonth = DateFormatter()
        dateFormatterMonth.locale = Locale.init(identifier: "en_US_POSFIX")
        dateFormatterMonth.dateFormat = "dd-MM-yyyy"
        let monthDate = dateFormatterMonth.date(from: monthToSelectFrom)!
        
        let dateFormatterMonth2 = DateFormatter()
        dateFormatterMonth2.dateFormat = "MMMM, yyyy"
        let month = dateFormatterMonth2.string(from: monthDate)
        monthToShow = month
        
        lastDateInArray = sevenDaysToShow.last ?? ""
        firstDateInArray = sevenDaysToShow.first ?? ""
        sevenDates = sevenDaysToShow
        return ComplitionHandler("success")
    }
    
    func preformGesture() {
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(sender:)))
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(sender:)))
        
        leftGesture.direction = .left
        rightGesture.direction = .right
        
        self.collectionView.addGestureRecognizer(leftGesture)
        self.collectionView.addGestureRecognizer(rightGesture)
    }
    
    @objc func handleSwipes(sender:UISwipeGestureRecognizer) {
        if sender.direction == .right {
            getNextSevenDays { [weak self] (response) in
                if response == "success" {
                    DispatchQueue.main.async {
                    self?.collectionView.layer.add(self!.swipeTransitionToLeftSide(false), forKey: nil)
                        self?.collectionView.collectionViewLayout.invalidateLayout()
                        self?.collectionView.layoutSubviews()
                        self?.collectionView.reloadData()
                    }
                }
            }
        }
        if sender.direction == .left {
            getPreviousSevenDates { [weak self] (response) in
                if response == "success" {
                    DispatchQueue.main.async {
                    self?.collectionView.layer.add(self!.swipeTransitionToLeftSide(false), forKey: nil)
                        self?.collectionView.collectionViewLayout.invalidateLayout()
                        self?.collectionView.layoutSubviews()
                        self?.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func swipeTransitionToLeftSide(_ leftSide: Bool) -> CATransition {
        let transition = CATransition()
        transition.startProgress = 0.0
        transition.endProgress = 1.0
        transition.type = CATransitionType.push
        transition.subtype = leftSide ? CATransitionSubtype.fromRight : CATransitionSubtype.fromLeft
        transition.duration = 0.3
        return transition
    }
}

class CalendarDateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
}
