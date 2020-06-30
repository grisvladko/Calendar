//
//  ScrollMonthViewController.swift
//  Calendar
//
//  Created by hyperactive on 29/05/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit
let ScrollMonthDelegate = ScrollMonthTableViewDelegate()
class ScrollMonthViewController: UIViewController, UIScrollViewDelegate {
    
    override func loadView() {
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width:300, height: 300))
        collectionView.delegate = ScrollMonthDelegate
        collectionView.dataSource = ScrollMonthDelegate
        self.view.addSubview(collectionView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = UIScrollView()
    }
}

fileprivate extension UIView {
    enum SubviewPosition {
        case Top
        case Bottom
    }

    func addSubview(_ newView :UIView, relativeToOtherSubviewsAt position: SubviewPosition) {
        newView.frame.origin.y = CGFloat(0)
        newView.translatesAutoresizingMaskIntoConstraints = false
        if position == .Top {
            self.addSubview(newView)
            for subview in self.subviews {
                subview.frame.origin.y += newView.frame.size.height
            }
        } else if position == .Bottom {
            //finding last subview
            var lastSubview = newView
            for subview in self.subviews {
                if subview.frame.maxY > lastSubview.frame.maxY {
                    lastSubview = subview
                    newView.frame.origin.y = subview.frame.maxY
                }
            }
            self.addSubview(newView)
            if lastSubview != newView {
                newView.topAnchor.constraint(equalTo:lastSubview.bottomAnchor).isActive = true
            }
        }
    }
}

fileprivate extension UIScrollView {

    func updateContentSize() {
        let contentRect: CGRect = subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        contentSize = contentRect.size
    }
}

class ScrollMonthTableViewDelegate: NSObject,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var innerWeekDay = Int()
    let secondCellIdentifier = "secondCell"
    var dex = 0
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dex += 1
        let tuple = dateComponentsInit(month: dex, day: 1, year: 2020)
        innerWeekDay = tuple.weekDay
        return DaysInMonth[tuple.month - 1] + 7 + innerWeekDay - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  secondCellIdentifier, for: indexPath) as! SecondCollectionViewCell
        
        cell.label.text = "\(dex)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "WeekViewController")
        UIApplication.topViewController()?.navigationController?.show(vc, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
}
