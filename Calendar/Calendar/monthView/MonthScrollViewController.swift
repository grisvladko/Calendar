//
//  MonthScrollViewController.swift
//  Calendar
//
//  Created by hyperactive on 27/06/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit
var monthScrollDate = Date()
class MonthScrollViewController: UIViewController {
    @IBOutlet weak var scrollView: MyInfiniteMonthScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        drawDayBar()
    }
    
    func drawDayBar() {
        let dayLabels = ["S","M","T","W","T","F","S"]
        let maxY = CGFloat(navigationController?.navigationBar.frame.maxY ?? 85)
        let view = UIView.init(frame: CGRect(x: 0, y: maxY, width: UIScreen.main.bounds.width, height: 20))
        var x:CGFloat = 0.0
        for i in 0..<7 {
            let label = UILabel.init(frame: CGRect(x: x, y: 0, width: UIScreen.main.bounds.width / 7, height: 20))
            label.text = dayLabels[i]
            label.textColor = i == 0 || i == 6 ? .blue : .black
            label.textAlignment = .center
            label.font = label.font.withSize(10)
            view.addSubview(label)
            x += UIScreen.main.bounds.width / 7
        }
        
        view.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        self.view.addSubview(view)
        self.scrollView.frame.origin.y = view.frame.maxY
    }
}

class MyInfiniteMonthScrollView: UIScrollView, UIScrollViewDelegate {

    var firstDate = Date()
    var lastDate = Date()
    var months = [UIView]()
    var oldContentOffset = CGPoint()
    var newContentOffset = CGPoint()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 400 * 3)
        var yPosition: CGFloat = 3
        for _ in 0..<3 {
            let view = drawMonthView(atYposition: yPosition)
            months.append(view)
            print(monthScrollDate)
            yPosition += 400
        }
//        let view = drawMonthView(atYposition: 0)
//        months.insert(view, at: 0)
        for month in months {
            self.addSubview(month)
        }
        self.delegate = self
        self.setContentOffset(CGPoint(x: 0, y: 414), animated: false)
    }
    
    func drawMonthView(atYposition: CGFloat) -> UIView {
        let view = MonthView(frame: CGRect(x: 0, y: atYposition, width: UIScreen.main.bounds.width, height: 400))
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView.init(frame: view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = view
        collectionView.dataSource = view
        view.addSubview(collectionView)
//        let view : MonthView = .fromNib()
//        view.frame.origin.y = atYposition
        return view
    }
    
    func scrollDown() {
        for month in months {
            month.removeFromSuperview()
            month.frame.origin.y -= 400
        }
        let view = drawMonthView(atYposition: 400 * 3)
        self.setContentOffset(newContentOffset, animated: false)
        months[0] = months[1]
        months[1] = months[2]
        months[2] = months[3]
        months[3] = view
        for month in months {
            self.addSubview(month)
        }
    }
    
    func scrollUp() {
        let view = drawMonthView(atYposition: 0)
        self.frame.size.height += 400
        self.addSubview(view)
    }
    
    func initMonth(day: Int) {
        
    }
//
//    func recenterIfNecessary() {
//        let currentOffset = self.contentOffset
//        let contentHeight = self.contentSize.height
//        let centerOffsety = (contentHeight  - self.bounds.size.height) / 3.0
//        let distanceFromCenter = abs(currentOffset.y - centerOffsety)
//        if distanceFromCenter > contentHeight / 5.0 {
//            self.contentOffset = CGPoint(x: currentOffset.x, y: centerOffsety)
//
//            for view in months {
//                var center = self.convert(view.center, to: self)
//                center.y += centerOffsety - currentOffset.y
//                view.center = convert(center, to: self )
//            }
//        }
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        recenterIfNecessary()
//        let visibleBounds = self.bounds
//        let minimumVisibleY = visibleBounds.minY
//        let maximumVisibleY = visibleBounds.maxY
//        tileViews(fromMinY: minimumVisibleY, toMaxY: maximumVisibleY)
//    }
//
//    func insertView() -> UIView {
//        let view = drawMonthView(atYposition: 0)
//        self.addSubview(view)
//        return view
//    }
//
//    func placeNewViewOnTop(rightEdge: CGFloat) -> CGFloat{
//        let view = self.insertView()
//        self.months.insert(view, at: 0)
//        var frame = view.frame
//        frame.origin.y = rightEdge
//        view.frame = frame
//
//        return frame.maxY
//    }
//
//    func placeNewViewOnBottom(leftEdge: CGFloat) -> CGFloat {
//        let view = self.insertView()
//        self.months.append(view)
//        var frame = view.frame
//        frame.origin.y = leftEdge - frame.size.height
//        view.frame = frame
//
//        return frame.minY
//    }
//
//    func tileViews(fromMinY: CGFloat, toMaxY: CGFloat) {
//        if self.months.count == 0 { placeNewViewOnTop(rightEdge: fromMinY)}
//
//        var lastview = months.last
//        var rightEdge = lastview?.frame.maxY
//
//        while rightEdge! < toMaxY {
//            rightEdge = placeNewViewOnTop(rightEdge: rightEdge!)
//        }
//
//        var firstview = months[0]
//        var leftEdge = firstview.frame.minY
//
//        while leftEdge > fromMinY {
//            leftEdge = placeNewViewOnBottom(leftEdge: leftEdge)
//        }
//
//        lastview = months.last
//
//        while lastview!.frame.origin.y > toMaxY {
//            lastview?.removeFromSuperview()
//            months.removeLast()
//            lastview = months.last
//        }
//
//        firstview = months[0]
//
//        while firstview.frame.maxY < fromMinY {
//            firstview.removeFromSuperview()
//            self.months.removeFirst()
//            firstview = months[0]
//        }
    //   }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        newContentOffset = scrollView.contentOffset
//        if oldContentOffset.y < newContentOffset.y {
//            self.setContentOffset(CGPoint(x: 0, y: 414), animated: false)
//            scrollDown()
//            print("down")
//        }
//        /*
//         else if oldContentOffset.y > newContentOffset.y {
//             self.setContentOffset(CGPoint(x: 0, y: 828), animated: false)
//
//         }
//         */
//    }
}

class MonthView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var weekDay = Int()
    var monthName = String()
    var calendar = Calendar.current
    var lastDate = Date()
    var daysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    let cellId = "MonthCell"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let weekDay = calendar.component(.weekday, from: monthScrollDate)
        let month = calendar.component(.month, from: monthScrollDate)
        let year = calendar.component(.year, from: monthScrollDate)
        monthScrollDate = calendar.date(byAdding: .month, value: -1, to: monthScrollDate)!
        lastDate = monthScrollDate
        self.weekDay = weekDay
        monthName = shortMonths[month - 1]
        return year % 4 == 0 && month == 2 ? daysInMonth[month - 1] + 7 + weekDay + 1 : daysInMonth[month - 1] + 7 + weekDay
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(MonthScrollCell.self, forCellWithReuseIdentifier: cellId )
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  cellId, for: indexPath)

        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        label.text = indexPath.item + 1 <= weekDay + 7 ? (indexPath.item == weekDay ? monthName : "") : "\(indexPath.item + 1 - (weekDay + 7))"
        label.textAlignment = .center
        cell.addSubview(label)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScrollViewController")

        UIApplication.topViewController()?.navigationController?.show(vc, sender: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0 , right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

class MonthScrollCell: UICollectionViewCell {
    
}
