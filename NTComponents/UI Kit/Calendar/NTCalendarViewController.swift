//
//  NTCalendarViewController.swift
//  NTComponents
//
//  Copyright © 2017 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 6/16/17.
//

open class NTCalendarViewController: NTViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    
    open var dateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.timeZone = Calendar.current.timeZone
        format.locale = Calendar.current.locale
        return format
    }()
    
    open var calendarHeaderView: NTCalendarHeaderView = {
        let view = NTCalendarHeaderView()
        view.setDefaultShadow()
        return view
    }()
    open var calendarView = NTCalendarView()
    open var detailView = UIView()
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    open func setup() {
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        view.addSubview(calendarHeaderView)
        view.addSubview(calendarView)
        view.addSubview(detailView)
        calendarHeaderView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        calendarView.anchor(calendarHeaderView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        calendarView.heightAnchor.constraint(lessThanOrEqualToConstant: 350).isActive = true
        detailView.anchor(calendarView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        calendarView.visibleDates { (dates) in
            if let firstDayInVisibleMonth = dates.monthDates.first?.date {
                self.updateTitleView(withDate: firstDayInVisibleMonth)
                self.calendarView.scrollingMode = .stopAtEachCalendarFrameWidth
                self.calendarView.scrollToDate(Date().startOfMonth(), animateScroll: false, preferredScrollPosition: .left)
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTabBar(shadowHidden: true)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        updateTabBar(shadowHidden: false)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open func updateNavigationBar(shadowHidden: Bool) {
        if let navigationBar = navigationController?.navigationBar {
            if shadowHidden {
                navigationBar.layer.shadowOpacity = 0
                navigationBar.shadowImage = UIImage()
                navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigationBar.hideShadow()
            } else {
                navigationBar.setDefaultShadow()
            }
        }
    }
    
    open func updateTabBar(shadowHidden: Bool) {
        if let tabBarController = scrollableTabBarController {
            if tabBarController.tabBarPosition == .top {
                shadowHidden ? tabBarController.tabBar?.hideShadow() : tabBarController.tabBar?.setDefaultShadow()
            } else {
                updateNavigationBar(shadowHidden: shadowHidden)
            }
        } else {
            updateNavigationBar(shadowHidden: shadowHidden)
        }
    }
    
    open func updateTitleView(withDate date: Date) {
        dateFormatter.dateFormat = "MMMM"
        calendarHeaderView.monthLabel.text = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyy"
        calendarHeaderView.yearLabel.text = dateFormatter.string(from: date)
    }
    
    // MARK: - JTAppleCalendarViewDataSource
    
    public func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        dateFormatter.dateFormat = "yyyy MM dd"
        let startDate = dateFormatter.date(from: "2000 01 01")!
        let endDate = dateFormatter.date(from: "2030 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    public func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: NTCalendarViewCell.reuseIdentifier, for: indexPath) as! NTCalendarViewCell
        cell.cellState = cellState
        cell.controller = self
        return cell
    }
    
    // MARK: - JTAppleCalendarViewDelegate
    
    public func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? NTCalendarViewCell else {
            return
        }
        cell.isSelected = true
    }
    
    public func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? NTCalendarViewCell else {
            return
        }
        cell.isSelected = false
    }
    
    public func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        if let firstDayInVisibleMonth = visibleDates.monthDates.first?.date {
            updateTitleView(withDate: firstDayInVisibleMonth)
        }
    }
}
