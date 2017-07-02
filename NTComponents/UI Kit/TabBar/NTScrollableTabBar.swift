//
//  NTScrollableTabBar.swift
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
//  Created by Nathan Tannar on 2/12/17.
//

import UIKit

open class NTScrollableTabBar: UIView {

    var pageItemPressedBlock: ((_ index: Int, _ direction: UIPageViewControllerNavigationDirection) -> Void)?
    var pageTabItems: [String] = [] {
        didSet {
            pageTabItemsCount = pageTabItems.count
            beforeIndex = pageTabItems.count
        }
    }
    var layouted: Bool = false

    
    fileprivate var beforeIndex: Int = 0
    internal var currentIndex: Int = 0
    fileprivate var pageTabItemsCount: Int = 0
    fileprivate var shouldScrollToItem: Bool = false
    fileprivate var pageTabItemsWidth: CGFloat = 0.0
    fileprivate var collectionViewContentOffsetX: CGFloat = 0.0
    fileprivate var currentBarViewWidth: CGFloat = 0.0
    fileprivate var currentBarViewLeftConstraint: NSLayoutConstraint?
    fileprivate var tabHeight: CGFloat = 32
    fileprivate var tabBarPosition: NTTabBarPosition = .top

    open var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NTScrollableTabBarItem.self, forCellWithReuseIdentifier: NTScrollableTabBarItem.cellIdentifier)
        collectionView.backgroundColor = Color.Default.Background.TabBar
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        return collectionView
    }()
    
    open var currentBarView = UIView()
    
    open var currentBarViewWidthConstraint: NSLayoutConstraint? {
        get {
            return currentBarView.constraint(withIdentifier: "width")
        }
    }
    open var currentBarViewHeightConstraint: NSLayoutConstraint? {
        get {
            return currentBarView.constraint(withIdentifier: "height")
        }
    }
    
    // MARK: - Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(barHeight: CGFloat = 2, barPosition: NTTabBarPosition = .top, tabHeight: CGFloat = 32, itemWidth: CGFloat = 0) {
        super.init(frame: .zero)
        
        self.tabHeight = tabHeight
        pageTabItemsWidth = itemWidth
        
        backgroundColor = Color.Default.Background.TabBar
        translatesAutoresizingMaskIntoConstraints = false
        setDefaultShadow()
        
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.fillSuperview()
        collectionView.addSubview(currentBarView)
        
        
        let left = NSLayoutConstraint(item: currentBarView,
                                      attribute: .leading,
                                      relatedBy: .equal,
                                      toItem: collectionView,
                                      attribute: .leading,
                                      multiplier: 1.0,
                                      constant: 0.0)
        collectionView.addConstraint(left)
        
        currentBarViewLeftConstraint = left
        
        currentBarView.backgroundColor = Color.Default.Tint.TabBar
        currentBarViewHeightConstraint?.constant = barHeight
        currentBarView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tabBarPosition = barPosition
        if barPosition == .bottom {
            currentBarView.anchor(topAnchor, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: barHeight)
            layer.shadowOffset = CGSize(width: -Color.Default.Shadow.Offset.width, height: -Color.Default.Shadow.Offset.height)
        } else {
            currentBarView.anchor(nil, left: nil, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: barHeight)
        }
    }

    /**
     Called when you rotate the device, moves the contentOffset of collectionView

     - parameter index: Next Index
     - parameter contentOffsetX: contentOffset.x of scrollView of isInfinityTabPageViewController
     */
    open func scrollCurrentBarView(_ index: Int, contentOffsetX: CGFloat) {
     
        if collectionViewContentOffsetX == 0.0 {
            collectionViewContentOffsetX = collectionView.contentOffset.x
        }

        let currentIndexPath = IndexPath(item: currentIndex, section: 0)
        let nextIndexPath = IndexPath(item: index, section: 0)
        if let currentCell = collectionView.cellForItem(at: currentIndexPath) as? NTScrollableTabBarItem, let nextCell = collectionView.cellForItem(at: nextIndexPath) as? NTScrollableTabBarItem {
            nextCell.hideCurrentBarView()
            currentCell.hideCurrentBarView()
            currentBarView.isHidden = false

            if currentBarViewWidth == 0.0 {
                currentBarViewWidth = currentCell.frame.width
            }

            let scrollRate = contentOffsetX / frame.width

            if fabs(scrollRate) > 0.6 {
                nextCell.highlightTitle()
                currentCell.unHighlightTitle()
            } else {
                nextCell.unHighlightTitle()
                currentCell.highlightTitle()
            }

            let width = fabs(scrollRate) * (nextCell.frame.width - currentCell.frame.width)
            if scrollRate > 0 {
                currentBarViewLeftConstraint?.constant = currentCell.frame.minX + scrollRate * currentCell.frame.width
            } else {
                currentBarViewLeftConstraint?.constant = currentCell.frame.minX + nextCell.frame.width * scrollRate
            }
            currentBarViewWidthConstraint?.constant = currentBarViewWidth + width
        }
    }

    /**
     Center the current cell after page swipe
     */
    open func scrollToHorizontalCenter() {
        let indexPath = IndexPath(item: currentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        collectionViewContentOffsetX = collectionView.contentOffset.x
    }

    /**
     Called in after the transition is complete pages in isInfinityTabPageViewController in the process of updating the current

     - parameter index: Next Index
     */
    open func updateCurrentIndex(_ index: Int, shouldScroll: Bool) {
        deselectVisibleCells()

        currentIndex = index

        let indexPath = IndexPath(item: currentIndex, section: 0)
        moveCurrentBarView(indexPath, animated: true, shouldScroll: shouldScroll)
    }

    /**
     Make the tapped cell the current

     - parameter index: Next IndexPath
     */
    fileprivate func updateCurrentIndexForTap(_ index: Int) {
        deselectVisibleCells()

        currentIndex = index
        let indexPath = IndexPath(item: index, section: 0)
        moveCurrentBarView(indexPath, animated: true, shouldScroll: true)
    }

    /**
     Move the collectionView to IndexPath of Current

     - parameter indexPath: Next IndexPath
     - parameter animated: true when you tap to move the isInfinityNTScrollableTabBarItem
     - parameter shouldScroll:
     */
    internal func moveCurrentBarView(_ indexPath: IndexPath, animated: Bool, shouldScroll: Bool) {
        if shouldScroll {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
            layoutIfNeeded()
            collectionViewContentOffsetX = 0.0
            currentBarViewWidth = 0.0
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? NTScrollableTabBarItem {
            currentBarView.isHidden = false
            if animated && shouldScroll {
                cell.isCurrent = true
            }
            cell.hideCurrentBarView()
            currentBarViewWidthConstraint?.constant = cell.frame.width
            currentBarViewLeftConstraint?.constant = cell.frame.origin.x
            UIView.animate(withDuration: 0.2, animations: {
                self.layoutIfNeeded()
                }, completion: { _ in
                    if !animated && shouldScroll {
                        cell.isCurrent = true
                    }
                    
                    self.updateCollectionViewUserInteractionEnabled(true)
            })
        }
        beforeIndex = currentIndex
    }

    /**
     Touch event control of collectionView

     - parameter userInteractionEnabled: Bool
     */
    func updateCollectionViewUserInteractionEnabled(_ userInteractionEnabled: Bool) {
        collectionView.isUserInteractionEnabled = userInteractionEnabled
    }

    /**
     Update all of the cells in the display to the unselected state
     */
    fileprivate func deselectVisibleCells() {
        collectionView
            .visibleCells
            .flatMap { $0 as? NTScrollableTabBarItem }
            .forEach { $0.isCurrent = false }
    }
}


// MARK: - UICollectionViewDataSource

extension NTScrollableTabBar: UICollectionViewDataSource {

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageTabItemsCount
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NTScrollableTabBarItem.cellIdentifier, for: indexPath) as! NTScrollableTabBarItem
        cell.title = pageTabItems[indexPath.item]
        cell.isCurrent = indexPath.item == (currentIndex % pageTabItemsCount)
        cell.tabBarPosition = tabBarPosition
        return cell
    }

    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // FIXME: Tabs are not displayed when processing is performed during introduction display
        if let cell = cell as? NTScrollableTabBarItem, layouted {
            let fixedIndex = indexPath.item
            cell.isCurrent = fixedIndex == (currentIndex % pageTabItemsCount)
        }
    }
}


// MARK: - UIScrollViewDelegate

extension NTScrollableTabBar: UICollectionViewDelegate {

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            currentBarView.isHidden = true
            let indexPath = IndexPath(item: currentIndex, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? NTScrollableTabBarItem {
                cell.showCurrentBarView()
            }
            
        }
    }

    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // Accept the touch event because animation is complete
        updateCollectionViewUserInteractionEnabled(true)


        let indexPath = IndexPath(item: currentIndex, section: 0)
        if shouldScrollToItem {
            // After the moved so as not to sense of incongruity, to adjust the contentOffset at the currentIndex
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            shouldScrollToItem = false
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fixedIndex = indexPath.item
        let isCurrent = fixedIndex == (currentIndex % pageTabItemsCount)
        var direction: UIPageViewControllerNavigationDirection = .forward
        if indexPath.item < currentIndex {
            direction = .reverse
        }
        self.pageItemPressedBlock?(fixedIndex, direction)
        
        if !isCurrent {
            // Not accept touch events to scroll the animation is finished
            self.updateCollectionViewUserInteractionEnabled(false)
        }
        self.updateCurrentIndexForTap(indexPath.item)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension NTScrollableTabBar: UICollectionViewDelegateFlowLayout {

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = pageTabItemsWidth == 0 ? (UIScreen.main.bounds.width / CGFloat(pageTabItemsCount)) : pageTabItemsWidth

        let size = CGSize(width: width, height: tabHeight)

        return size
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
