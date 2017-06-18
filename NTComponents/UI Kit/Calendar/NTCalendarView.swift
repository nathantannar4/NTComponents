//
//  NTCalendarView.swift
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

open class NTCalendarView: JTAppleCalendarView {
    
    // MARK: - Initialization
    
    public override init() {
        super.init()
        setup()
    }
    
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {
        backgroundColor = .clear
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        register(NTCalendarViewCell.self, forCellWithReuseIdentifier: NTCalendarViewCell.reuseIdentifier)
    }
}


/*
@objc public protocol NTCalendarViewDataSource: NSObjectProtocol {
    func calendarView(_ calendarView: NTCalendarView, cellForItemAt indexPath: IndexPath) -> NTCalendarViewCell
}

@objc public protocol NTCalendarViewDelegate: NSObjectProtocol {
    @objc optional func calendarView(_ calendarView: NTCalendarView, didSelectItemAt indexPath: IndexPath)
}


open class NTCalendarView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, NTCalendarHeaderViewDelegate, NTCalendarHeaderViewDataSource {
    
    open var dataSource: NTCalendarViewDataSource?
    open var delegate: NTCalendarViewDelegate?
    open weak var calendarHeaderView: NTCalendarHeaderView? {
        didSet {
            calendarHeaderView?.delegate = self
            calendarHeaderView?.dataSource = self
        }
    }
    
    open var calendar: Calendar = Calendar.current
    
    open var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    open func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NTCalendarViewCell.self, forCellWithReuseIdentifier: NTCalendarViewCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dataSource?.calendarView(self, cellForItemAt: indexPath) ?? collectionView.dequeueReusableCell(withReuseIdentifier: NTCalendarViewCell.reuseIdentifier, for: indexPath) as! NTCalendarViewCell
        cell.backgroundColor = indexPath.row % 2 == 0 ? Color.White : Color.White.darker()
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }
    
    // MARK: - UICollectionViewFlowLayoutDelegate

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width / 7
        return CGSize(width: width, height: 60)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.calendarView?(self, didSelectItemAt: indexPath)
    }
}
 */
