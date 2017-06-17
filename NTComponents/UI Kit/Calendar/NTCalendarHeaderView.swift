//
//  NTCalendarHeaderView.swift
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

open class NTCalendarHeaderView: UIView {
    
    open var monthLabel: NTLabel = {
        let label = NTLabel(style: .title)
        label.text = "January"
        label.font = Font.Default.Title.withSize(24)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    open var yearLabel: NTLabel = {
        let label = NTLabel(style: .subtitle)
        label.text = "2017"
        label.font = Font.Default.Title.withSize(18)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        return label
    }()
    
    open var days: [String] = ["SUN","MON","TUE","WED","THR","FRI","SAT"]
    open var dayLabels: [String:NTLabel] = [:]
    fileprivate var layedOutDayLabels: Bool = false
    
    // MARK: - Initialization
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {
        
        backgroundColor = Color.Default.Background.NavigationBar
        
        addSubview(monthLabel)
        addSubview(yearLabel)
        
        monthLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: yearLabel.leftAnchor, topConstant: 2, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        yearLabel.anchor(nil, left: monthLabel.rightAnchor, bottom: monthLabel.bottomAnchor, right: rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        monthLabel.anchorWidthToItem(yearLabel)
        
        populateDayLabels()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutDayLabels()
    }
    
    // MARK: - Methods
    
    open func layoutDayLabels() {
        if layedOutDayLabels {
            return
        }
        
        var currentAnchor = leftAnchor
        for (index, day) in days.enumerated() {
            guard let label = dayLabels[day] else {
                return
            }
            
            label.anchor(monthLabel.bottomAnchor, left: currentAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 6, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            
            if index == days.count - 1 {
                label.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            } else {
                currentAnchor = label.rightAnchor
                if let lastLabel = dayLabels[days.last!] {
                    label.anchorWidthToItem(lastLabel)
                }
            }
        }
        
        
        
        layedOutDayLabels = true
    }
    
    open func populateDayLabels() {
    
        for day in days {
            let label = dayLabel(withText: day)
            dayLabels[day] = label
            addSubview(label)
        }
    }
    
    open func dayLabel(withText text: String?) -> NTLabel {
        let label = NTLabel(style: .caption)
        label.text = text
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = Color.Default.Text.Title.darker(by: 15)
        return label
    }
}
