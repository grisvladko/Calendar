//
//  WeekViewController.swift
//  Calendar
//
//  Created by hyperactive on 20/05/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

class WeekViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var date = (day	: Int(), month: Int(), year: Int(),weekDay: Int())
    var numberOfItems = 1000 //can be more if needed high number provides a lag
    var days = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var daysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var oldContentOffset: CGPoint?
    var newContentOffset: CGPoint?
    var isWeekHalfAscending = Bool()
    var isWeekHalfDescending = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        collectionView.scrollToItem(at: IndexPath(item: numberOfItems / 2 - 7, section: 0), at: .centeredHorizontally, animated: false)
        self.collectionView.isPrefetchingEnabled = true
        initWeek(day: date.day)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    }
    
    func initWeek(day: Int) {
        if date.year % 4 == 0 {daysInMonth[1] = 29}
        let weekDay = date.weekDay + 7
        days[weekDay] = day
        
        var day = day - 1
        var index = weekDay == 0 ? 0 : weekDay - 1
        var previousMonth = Int()
        switch date.month {
        case 0: previousMonth = 10
        case 1: previousMonth = 11
        default: previousMonth = date.month - 2
        }
        if day <= 0 { isWeekHalfDescending = true }
        day = day <= 0 ? daysInMonth[previousMonth] : day
        
        for i in stride(from: index, through: 0, by: -1){
            if day <= 0 { isWeekHalfDescending = true }
            day = day <= 0 ? daysInMonth[previousMonth] : day
            days[i] = day
            day -= 1
        }
        
        index = weekDay + 1
        if day <= 0 { isWeekHalfAscending = true }
        
        day = date.day == daysInMonth[date.month - 1] ? 1 : date.day + 1
        for i in index..<days.count {
            if day <= 0 { isWeekHalfAscending = true }
            day = day == daysInMonth[date.month - 1] + 1 ? 1 : day
            days[i] = day
            day += 1
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        oldContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        newContentOffset = scrollView.contentOffset
    
        if oldContentOffset != nil{
            if oldContentOffset!.x < newContentOffset!.x {
//                switch fullyVisibleCells(collectionView) {
//                case 0: helper(current: 6, firstToChange: 7, stride: (8,13))
//                case 7: helper(current: 13, firstToChange: 14, stride: (15,20))
//                case 14: helper(current: 20, firstToChange: 0, stride: (1,6))
//                default: break                 }
                scrollRight()
                collectionView.reloadData()
            }
            else if oldContentOffset!.x > newContentOffset!.x {
                scrollLeft()
                collectionView.reloadData()
            }
        }
        print(date)
    }
    
    func helper(current: Int, firstToChange: Int, stride: (start:Int,end:Int)) {
        let currentMonth = date.month
        var currentIndex = 0
        if isWeekHalfAscending { date.month += 1; isWeekHalfAscending = false}

        currentIndex = current
        if days[currentIndex] >= daysInMonth[currentMonth - 1] {
            if date.month == 12 {
                date.month = 1
                date.year += 1
                if date.year % 4 != 0 { daysInMonth[1] = 28}
            } else { date.month += 1}
            days[firstToChange] = 1
        } else { days[firstToChange] = days[currentIndex] + 1 }
            
        for i in stride.start...stride.end {
            days[i] = days[i - 1] + 1
            if days[i] > daysInMonth[date.month - 1] {
                if date.month == 12 {
                    date.month = 1
                    date.year += 1
                    if date.year % 4 != 0 { daysInMonth[1] = 28}
                }else { date.month += 1}
                days[i] = 1
            }
        }
    }
    
    func scrollRight() {
        let firstVisibleCell = fullyVisibleCells(collectionView)
        let currentMonth = date.month
        var currentIndex = 0
        if isWeekHalfAscending { date.month += 1; isWeekHalfAscending = false}
        
        if firstVisibleCell == 0 {
            currentIndex = 6
            if days[currentIndex] >= daysInMonth[currentMonth - 1] {
                if date.month == 12 {
                    date.month = 1
                    date.year += 1
                    if date.year % 4 != 0 { daysInMonth[1] = 28}
                } else { date.month += 1}
                days[7] = 1
            } else { days[7] = days[currentIndex] + 1 }
            
            for i in 8...13 {
                days[i] = days[i - 1] + 1
                if days[i] > daysInMonth[date.month - 1] {
                    if date.month == 12 {
                        date.month = 1
                        date.year += 1
                        if date.year % 4 != 0 { daysInMonth[1] = 28}
                    }else { date.month += 1}
                    days[i] = 1
                }
            }
            
        } else if firstVisibleCell == 7 {
            currentIndex = 13
            if days[currentIndex] >= daysInMonth[currentMonth - 1] {
                if date.month == 12 {
                    date.month = 1
                    date.year += 1
                    if date.year % 4 != 0 { daysInMonth[1] = 28}
                } else { date.month += 1}
                days[14] = 1
            } else { days[14] = days[currentIndex] + 1 }
            
            for i in 15...20 {
                days[i] = days[i - 1] + 1
                if days[i] > daysInMonth[date.month - 1] {
                    if date.month == 12 {
                        date.month = 1
                        date.year += 1
                        if date.year % 4 != 0 { daysInMonth[1] = 28}
                    } else { date.month += 1}
                    days[i] = 1
                }
            }
           
        } else if firstVisibleCell == 14 {
            currentIndex = 20 // to pass
            if days[currentIndex] >= daysInMonth[currentMonth - 1] {
                if date.month == 12 {
                    date.month = 1
                    date.year += 1
                    if date.year % 4 != 0 { daysInMonth[1] = 28}
                } else { date.month += 1}
                days[0] = 1 // to pass
            } else { days[0] = days[currentIndex] + 1 }
            
            for i in 1...6 { // to pass
                days[i] = days[i - 1] + 1
                if days[i] > daysInMonth[date.month - 1] {
                    if date.month == 12 {
                        date.month = 1
                        date.year += 1
                        if date.year % 4 != 0 { daysInMonth[1] = 28}
                    } else { date.month += 1}
                    days[i] = 1
                }
            }
        }
    }
    
    func switchMonth() -> Int{
        var previousMonth = Int()
        switch date.month {
        case 0: previousMonth = 10
        case 1: previousMonth = 11
        default: previousMonth = date.month - 2
        }
        return previousMonth
    }
    
    func scrollLeft() {
        
        if isWeekHalfDescending { date.month -= 1; isWeekHalfDescending  = false}
        let firstVisibleCell = fullyVisibleCells(collectionView)
        var currentIndex = 0
        var previousMonth = Int()
        
        if firstVisibleCell == 0 {
            currentIndex = 0
            if days[currentIndex] <= 1 {
                if date.month == 1 {
                    date.month = 12
                    date.year -= 1
                    if date.year % 4 != 0 { daysInMonth[1] = 28}
                } else { date.month -= 1}
                previousMonth = switchMonth()
                days[20] = daysInMonth[previousMonth]
            } else { days[20] = days[currentIndex] - 1 }
            
            for i in stride(from: 19, through: 14, by: -1){
                days[i] = days[i + 1] - 1
                if days[i] < 1 {
                    if date.month == 1 {
                        date.month = 12
                        date.year -= 1
                        if date.year % 4 != 0 { daysInMonth[1] = 28}
                    }else { date.month -= 1}
                    previousMonth = switchMonth()
                    days[i] = daysInMonth[previousMonth]
                }
            }
        } else if firstVisibleCell == 7 {
            currentIndex = 7
            if days[currentIndex] <= 1 {
                if date.month == 1 {
                    date.month = 12
                    date.year -= 1
                    if date.year % 4 != 0 { daysInMonth[1] = 28}
                } else { date.month -= 1}
                previousMonth = switchMonth()
                days[6] = daysInMonth[previousMonth]
            } else { days[6] = days[currentIndex] - 1 }
            
            for i in stride(from: 5, through: 0, by: -1) {
                days[i] = days[i + 1] - 1
                if days[i] < 1 {
                    if date.month <= 1 {
                        date.month = 12
                        date.year -= 1
                        if date.year % 4 != 0 { daysInMonth[1] = 28}
                    } else { date.month -= 1}
                    previousMonth = switchMonth()
                    days[i] = daysInMonth[previousMonth]
                }
            }
           
        } else if firstVisibleCell == 14 {
            currentIndex = 14
            if days[currentIndex] <= 1 {
                if date.month == 1 {
                    date.month = 12
                    date.year -= 1
                    if date.year % 4 != 0 { daysInMonth[1] = 28}
                } else { date.month -= 1}
                previousMonth = switchMonth()
                days[13] = daysInMonth[previousMonth]
            } else { days[13] = days[currentIndex] - 1 }
            
            for i in stride(from: 12, through: 7, by: -1) {
                days[i] = days[i + 1] - 1
                if days[i] < 1{
                    if date.month == 1 {
                        date.month = 12
                        date.year -= 1
                        if date.year % 4 != 0 { daysInMonth[1] = 28}
                    } else { date.month -= 1}
                    previousMonth = switchMonth()
                    days[i] = daysInMonth[previousMonth]
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.isPagingEnabled = true
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekDay", for: indexPath) as! WeekDayCell

        cell.weekDayLabel.text = String(days[indexPath.row % days.count])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 59.1428571429, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func fullyVisibleCells(_ inCollectionView: UICollectionView) -> Int {

        var indexPaths = [IndexPath]()

        var vCells = inCollectionView.visibleCells
        vCells = vCells.filter({ cell -> Bool in
            let cellRect = inCollectionView.convert(cell.frame, to: inCollectionView.superview)
            return inCollectionView.frame.contains(cellRect)
        })

        vCells.forEach({
            if let pth = inCollectionView.indexPath(for: $0) {
                indexPaths.append(pth)
            }
        })
        
        indexPaths.sort()
        
        let firstItemInSection = indexPaths[0].row % days.count

        return firstItemInSection

    }
}

class WeekDayCell: UICollectionViewCell {
    @IBOutlet weak var weekDayLabel: UILabel!
}

