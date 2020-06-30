//
//  CalendarVariables.swift
//  Calendar_v3
//
//  Created by hyperactive on 23/04/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import Foundation
import UIKit

var newDateComponents = DateComponents()

let shortMonths = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
let DaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
var currentMonth = ""

func getStartDate(month: Int, year: Int) -> Date {
    var comp = DateComponents()
    let cal = Calendar.current
    comp.month = month
    comp.year = year
    guard let date = cal.date(from: comp) else { return Date() }
    return date
}

extension Date {
    func startOfMonth() -> Int {
        let c = Calendar.current
        return c.component(.weekday, from: Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!)
    }
}

func dateComponentsInit(month: Int, day: Int, year: Int) -> (weekDay: Int, month: Int, year: Int){
    let clndr = Calendar.current
    let date = getStartDate(month: month, year: year)
    let m = clndr.component(.month, from: date)
    let d = clndr.component(.weekday, from: date) 
    let y = clndr.component(.year, from: date)
    return (d,m,y)
}

extension UIApplication
{
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
    {
        if let nav = base as? UINavigationController
        {
            let top = topViewController(nav.visibleViewController)
            return top
        }

        if let tab = base as? UITabBarController
        {
            if let selected = tab.selectedViewController
            {
                let top = topViewController(selected)
                return top
            }
        }

        if let presented = base?.presentedViewController
        {
            let top = topViewController(presented)
            return top
        }
        return base
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

struct Calendars: Codable {
    var calendars: [MyCalendar]
    init() {
        self.calendars = []   
    }
}

struct MyCalendar: Codable {
    var calendarName: String
    var color: Int
    var isChecked: Bool
    var events: [Event]
    
    init() {
        self.init(calendarName: "", color: 0)
    }
    
    init(calendarName: String, color: Int) {
        self.calendarName = calendarName
        self.color = color 
        self.isChecked = true
        self.events = []
    }
}

struct Event: Codable {
    var title: String
    var location: String
    var start: String
    var end: String
    var calendar: String
    var alert: String
    var allDay: Bool?
    var timeRepeat: Int?
    var secondAlert: String?
    var URLS: String?
    var notes: String?
    
    init() {
        self.init(title: "", location: "", start: "", end: "", alert: "", calendar: "")
    }
    
    init(title: String, location: String, start: String, end: String, alert: String, calendar: String) {
        self.title = title
        self.location = location
        self.start = start
        self.end = end
        self.alert = alert
        self.calendar = calendar
    }
}

func getURL() -> URL {
    let fileURL = try! FileManager.default
    .url(for: .applicationSupportDirectory,
            in: .userDomainMask,
             appropriateFor: nil,
             create: true)
    .appendingPathComponent("calendarContainer.json")
    return fileURL
}

@IBDesignable
open class CheckBox: UIControl {
    
    ///Used to choose the style for the Checkbox
    public enum Style {
        
        /// ■
        case square
        /// ●
        case circle
        /// x
        case cross
        /// ✓
        case tick
    }
    
    /// Shape of the outside box containing the checkmarks contents.
    /// Used as a visual indication of where the user can tap.
    public enum BorderStyle {
        /// ▢
        case square
        /// ■
        case roundedSquare(radius: CGFloat)
        /// ◯
        case rounded
    }
    
    var style: Style = .circle
    var borderStyle: BorderStyle = .roundedSquare(radius: 8)
    
    @IBInspectable
    var borderWidth: CGFloat = 1.75
    
    var checkmarkSize: CGFloat = 0.5
    
    @IBInspectable
    var uncheckedBorderColor: UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    
    @IBInspectable
    var checkedBorderColor: UIColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
    
    @IBInspectable
    var checkmarkColor: UIColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
    
    var checkboxBackgroundColor: UIColor! = .white
    
    //Used to increase the touchable are for the component
    var increasedTouchRadius: CGFloat = 5
    
    //By default it is true
    var useHapticFeedback: Bool = true
    
    @IBInspectable
    var isChecked: Bool = false {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    //UIImpactFeedbackGenerator object to wake up the device engine to provide feed backs
    private var feedbackGenerator: UIImpactFeedbackGenerator?
    
    //MARK: Intialisers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        
        self.backgroundColor = .clear
        
    }
    
    //Define the above UIImpactFeedbackGenerator object, and prepare the engine to be ready to provide feedback.
    //To store the energy and as per the best practices, we create and make it ready on touches begin.
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.feedbackGenerator = UIImpactFeedbackGenerator.init(style: .light)
        self.feedbackGenerator?.prepare()
    }
    
    //On touches ended,
    //change the selected state of the component, and changing *isChecked* property, draw methos will be called
    //So components appearance will be changed accordingly
    //Hence the state change occures here, we also sent notification for value changed event for this component.
    //After usage of feedback generator object, we make it nill.
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        super.touchesEnded(touches, with: event)
        
        self.isChecked = !isChecked
        self.sendActions(for: .valueChanged)
        if useHapticFeedback {
            self.feedbackGenerator?.impactOccurred()
            self.feedbackGenerator = nil
        }
    }
    
    open override func draw(_ rect: CGRect) {
        
        //Draw the outlined component
        let newRect = rect.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(self.isChecked ? checkedBorderColor.cgColor : tintColor.cgColor)
        context.setFillColor(checkboxBackgroundColor.cgColor)
        context.setLineWidth(borderWidth)
        
        var shapePath: UIBezierPath!
        switch self.borderStyle {
        case .square:
            shapePath = UIBezierPath(rect: newRect)
        case .roundedSquare(let radius):
            shapePath = UIBezierPath(roundedRect: newRect, cornerRadius: radius)
        case .rounded:
            shapePath = UIBezierPath.init(ovalIn: newRect)
        }
        
        context.addPath(shapePath.cgPath)
        context.strokePath()
        context.fillPath()
        
        //When it is selected, depends on the style
        //By using helper methods, draw the inner part of the component UI.
        if isChecked {
            
            switch self.style {
            case .square:
                self.drawInnerSquare(frame: newRect)
            case .circle:
                self.drawCircle(frame: newRect)
            case .cross:
                self.drawCross(frame: newRect)
            case .tick:
                self.drawCheckMark(frame: newRect)
            }
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setNeedsDisplay()
    }
    
    //we override the following method,
    //To increase the hit frame for this component
    //Usaully check boxes are small in our app's UI, so we need more touchable area for its interaction
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        let relativeFrame = self.bounds
        let hitTestEdgeInsets = UIEdgeInsets(top: -increasedTouchRadius, left: -increasedTouchRadius, bottom: -increasedTouchRadius, right: -increasedTouchRadius)
        let hitFrame = relativeFrame.inset(by: hitTestEdgeInsets)
        return hitFrame.contains(point)
    }
    
    //Draws tick inside the component
    func drawCheckMark(frame: CGRect) {
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 0.26000 * frame.width, y: frame.minY + 0.50000 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.42000 * frame.width, y: frame.minY + 0.62000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.38000 * frame.width, y: frame.minY + 0.60000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.42000 * frame.width, y: frame.minY + 0.62000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.70000 * frame.width, y: frame.minY + 0.24000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.78000 * frame.width, y: frame.minY + 0.30000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.44000 * frame.width, y: frame.minY + 0.76000 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.20000 * frame.width, y: frame.minY + 0.58000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.44000 * frame.width, y: frame.minY + 0.76000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.26000 * frame.width, y: frame.minY + 0.62000 * frame.height))
        checkmarkColor.setFill()
        bezierPath.fill()
    }
    
    //Draws circle inside the component
    func drawCircle(frame: CGRect) {
        //// General Declarations
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: frame.minX + fastFloor(frame.width * 0.22000 + 0.5), y: frame.minY + fastFloor(frame.height * 0.22000 + 0.5), width: fastFloor(frame.width * 0.76000 + 0.5) - fastFloor(frame.width * 0.22000 + 0.5), height: fastFloor(frame.height * 0.78000 + 0.5) - fastFloor(frame.height * 0.22000 + 0.5)))
        checkmarkColor.setFill()
        ovalPath.fill()
    }

    //Draws square inside the component
    func drawInnerSquare(frame: CGRect) {
        //// General Declarations
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        //// Rectangle Drawing
        let padding = self.bounds.width * 0.3
        let innerRect = frame.inset(by: .init(top: padding, left: padding, bottom: padding, right: padding))
        let rectanglePath = UIBezierPath.init(roundedRect: innerRect, cornerRadius: 3)
        
        //        let rectanglePath = UIBezierPath(rect: CGRect(x: frame.minX + fastFloor(frame.width * 0.22000 + 0.15), y: frame.minY + fastFloor(frame.height * 0.26000 + 0.15), width: fastFloor(frame.width * 0.76000 + 0.15) - fastFloor(frame.width * 0.22000 + 0.15), height: fastFloor(frame.height * 0.76000 + 0.15) - fastFloor(frame.height * 0.26000 + 0.15)))
        checkmarkColor.setFill()
        rectanglePath.fill()
    }
    
    //Draws cross inside the component
    func drawCross(frame: CGRect) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        //// Subframes
        let group: CGRect = CGRect(x: frame.minX + fastFloor((frame.width - 17.37) * 0.49035 + 0.5), y: frame.minY + fastFloor((frame.height - 23.02) * 0.51819 - 0.48) + 0.98, width: 17.37, height: 23.02)
        
        //// Group
        //// Rectangle Drawing
        context.saveGState()
        context.translateBy(x: group.minX + 14.91, y: group.minY)
        context.rotate(by: 35 * CGFloat.pi/180)
        
        let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 3, height: 26))
        checkmarkColor.setFill()
        rectanglePath.fill()
        
        context.restoreGState()
        
        //// Rectangle 2 Drawing
        context.saveGState()
        context.translateBy(x: group.minX, y: group.minY + 1.72)
        context.rotate(by: -35 * CGFloat.pi/180)
        
        let rectangle2Path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 3, height: 26))
        checkmarkColor.setFill()
        rectangle2Path.fill()
        
        context.restoreGState()
    }
}











 /*

 //wwdc infinite scroll
 class InfiniteScroll: UIScrollView {
     
     var i = 0
     var visibleDates = [UIView]()
     var containerView = UIView()
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
         self.contentSize = CGSize(width: 5000, height: 50)
         self.isPagingEnabled = true
         containerView.frame = CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)
         self.addSubview(containerView)
     }
     
     func recenterIfNecessary() {
         let currentOffset = self.contentOffset
         let contentWidth = self.contentSize.width
         let centerOffsetX = (contentWidth - self.bounds.size.width) / 2.0
         let distanceFromCenter = abs(currentOffset.x - centerOffsetX)
         if distanceFromCenter > contentWidth / 5.0 {
             self.contentOffset = CGPoint(x: centerOffsetX, y: currentOffset.y)
             
             for view in visibleDates {
                 var center = containerView.convert(view.center, to: self)
                 center.x += centerOffsetX - currentOffset.x
                 view.center = convert(center, to: containerView )
             }
         }
     }
     
     override func layoutSubviews() {
         super.layoutSubviews()
         recenterIfNecessary()
         let visibleBounds = self.bounds
         let minimumVisibleX = visibleBounds.minX
         let maximumVisibleX = visibleBounds.maxX
         tileViews(fromMinX: minimumVisibleX, toMaxX: maximumVisibleX)
     }
     
     func drawWeekView() -> UIView {
         let view = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
         var xPosition = 0.0
         for j in 0..<7 {
             let label = UILabel.init(frame: CGRect(x: xPosition, y: 0, width: Double(UIScreen.main.bounds.width / 7), height: 50))
             label.text = String(j)
             label.textAlignment = .center
             view.addSubview(label)
             xPosition += Double(UIScreen.main.bounds.width / 7)
         }
         return view
     }
  
     func insertView() -> UIView {
         let view = drawWeekView()
         self.containerView.addSubview(view)
         return view
     }
     
     func placeNewViewOnRight(rightEdge: CGFloat) -> CGFloat{
         let view = self.insertView()
         self.visibleDates.append(view)
         var frame = view.frame
         frame.origin.x = rightEdge
         frame.origin.y = self.containerView.bounds.size.height - frame.size.height
         view.frame = frame
         
         return frame.maxX
     }
     
     func placeNewViewOnLeft(leftEdge: CGFloat) -> CGFloat {
         let view = self.insertView()
         self.visibleDates.insert(view, at: 0)
         var frame = view.frame
         frame.origin.x = leftEdge - frame.size.width
         frame.origin.y = self.containerView.bounds.size.height - frame.size.height
         view.frame = frame
         
         return frame.minX
     }
     
     func tileViews(fromMinX: CGFloat, toMaxX: CGFloat) {
         if self.visibleDates.count == 0 { placeNewViewOnRight(rightEdge: fromMinX)}
         
         var lastview = visibleDates.last
         var rightEdge = lastview?.frame.maxX
         
         while rightEdge! < toMaxX {
             rightEdge = placeNewViewOnRight(rightEdge: rightEdge!)
         }
         
         var firstview = visibleDates[0]
         var leftEdge = firstview.frame.minX
         
         while leftEdge > fromMinX {
             leftEdge = placeNewViewOnLeft(leftEdge: leftEdge)
         }
         
         lastview = visibleDates.last
         
         while lastview!.frame.origin.x > toMaxX {
             lastview?.removeFromSuperview()
             visibleDates.removeLast()
             lastview = visibleDates.last
         }
         
         firstview = visibleDates[0]
         
         while firstview.frame.maxX < fromMinX {
             firstview.removeFromSuperview()
             self.visibleDates.removeFirst()
             firstview = visibleDates[0]
         }
     }
 }

 */
