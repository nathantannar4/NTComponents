//
//  NTScrollableTabBar.swift
//  NTComponents
//
//  Created by EndouMari on 2016/02/24.
//  Copyright © 2016年 EndouMari. All rights reserved.
//
//  Modified by Nathan Tannar on 1/12/17.
//    - Integrated customizability into the rest of NTComponents
//    - Removed the need for xib or storyboard files through pure programatic initalization
//    - Removed infinity option
//  Modifications Copyright © 2017 Nathan Tannar. All rights reserved.

import UIKit

internal class NTScrollableTabBar: UIView {

    var pageItemPressedBlock: ((_ index: Int, _ direction: UIPageViewControllerNavigationDirection) -> Void)?
    var pageTabItems: [String] = [] {
        didSet {
            pageTabItemsCount = pageTabItems.count
            beforeIndex = pageTabItems.count
        }
    }
    var layouted: Bool = false

    
    fileprivate var properties: NTTabBarProperties = NTTabBarProperties()
    fileprivate var beforeIndex: Int = 0
    internal var currentIndex: Int = 0
    fileprivate var pageTabItemsCount: Int = 0
    fileprivate var shouldScrollToItem: Bool = false
    fileprivate var pageTabItemsWidth: CGFloat = 0.0
    fileprivate var collectionViewContentOffsetX: CGFloat = 0.0
    fileprivate var currentBarViewWidth: CGFloat = 0.0
    fileprivate var cachedCellSizes: [IndexPath: CGSize] = [:]
    fileprivate var currentBarViewLeftConstraint: NSLayoutConstraint?

    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var currentBarView = UIView()
    
    var currentBarViewWidthConstraint: NSLayoutConstraint? {
        get {
            return currentBarView.constraint(withIdentifier: "width")
        }
    }
    var currentBarViewHeightConstraint: NSLayoutConstraint? {
        get {
            return currentBarView.constraint(withIdentifier: "height")
        }
    }
    
    
    // MARK: - Initialization

    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(properties: NTTabBarProperties) {
        super.init(frame: .zero)
        self.properties = properties
        
        backgroundColor = properties.tabBackgroundColor.withAlphaComponent(properties.tabBarAlpha)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(collectionView)
        collectionView.backgroundColor = properties.tabBackgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollsToTop = false
        collectionView.fillSuperview()
        collectionView.register(NTScrollableTabBarItem.self, forCellWithReuseIdentifier: NTScrollableTabBarItem.cellIdentifier)

        collectionView.addSubview(currentBarView)
        currentBarView.backgroundColor = properties.currentColor
        currentBarViewHeightConstraint?.constant = properties.currentBarHeight
        currentBarView.anchor(nil, left: nil, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: properties.currentBarHeight)
        currentBarView.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: currentBarView,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: collectionView,
                                     attribute: .top,
                                     multiplier: 1.0,
                                     constant: properties.tabHeight - (currentBarViewHeightConstraint?.constant ?? 0))
        
        let left = NSLayoutConstraint(item: currentBarView,
                                      attribute: .leading,
                                      relatedBy: .equal,
                                      toItem: collectionView,
                                      attribute: .leading,
                                      multiplier: 1.0,
                                      constant: 0.0)
        currentBarViewLeftConstraint = left
        collectionView.addConstraints([top, left])
        
        setDefaultShadow()
    }
}


// MARK: - View

extension NTScrollableTabBar {
    

    /**
     Called when you swipe in isInfinityTabPageViewController, moves the contentOffset of collectionView

     - parameter index: Next Index
     - parameter contentOffsetX: contentOffset.x of scrollView of isInfinityTabPageViewController
     */
    func scrollCurrentBarView(_ index: Int, contentOffsetX: CGFloat) {
     
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
    func scrollToHorizontalCenter() {
        let indexPath = IndexPath(item: currentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        collectionViewContentOffsetX = collectionView.contentOffset.x
    }

    /**
     Called in after the transition is complete pages in isInfinityTabPageViewController in the process of updating the current

     - parameter index: Next Index
     */
    func updateCurrentIndex(_ index: Int, shouldScroll: Bool) {
        deselectVisibleCells()

        currentIndex = index

        let indexPath = IndexPath(item: currentIndex, section: 0)
        moveCurrentBarView(indexPath, animated: true, shouldScroll: shouldScroll)
    }

    /**
     Make the tapped cell the current if isInfinity is true

     - parameter index: Next IndexPath√
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
    fileprivate func moveCurrentBarView(_ indexPath: IndexPath, animated: Bool, shouldScroll: Bool) {
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

     - parameter userInteractionEnabled: collectionViewに渡すuserInteractionEnabled
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

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageTabItemsCount
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NTScrollableTabBarItem.cellIdentifier, for: indexPath) as! NTScrollableTabBarItem
        configureCell(cell, indexPath: indexPath)
        return cell
    }

    fileprivate func configureCell(_ cell: NTScrollableTabBarItem, indexPath: IndexPath) {
        let fixedIndex = indexPath.item
        cell.title = pageTabItems[fixedIndex]
        cell.properties = properties
        cell.isCurrent = fixedIndex == (currentIndex % pageTabItemsCount)
        cell.tabItemButtonPressedBlock = { [weak self, weak cell] in
            var direction: UIPageViewControllerNavigationDirection = .forward
            if let currentIndex = self?.currentIndex {
                if indexPath.item < currentIndex {
                    direction = .reverse
                }
            }
            self?.pageItemPressedBlock?(fixedIndex, direction)

            if cell?.isCurrent == false {
                // Not accept touch events to scroll the animation is finished
                self?.updateCollectionViewUserInteractionEnabled(false)
            }
            self?.updateCurrentIndexForTap(indexPath.item)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // FIXME: Tabs are not displayed when processing is performed during introduction display
        if let cell = cell as? NTScrollableTabBarItem, layouted {
            let fixedIndex = indexPath.item
            cell.isCurrent = fixedIndex == (currentIndex % pageTabItemsCount)
        }
    }
}


// MARK: - UIScrollViewDelegate

extension NTScrollableTabBar: UICollectionViewDelegate {

    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            currentBarView.isHidden = true
            let indexPath = IndexPath(item: currentIndex, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? NTScrollableTabBarItem {
                cell.showCurrentBarView()
            }
        }



        if pageTabItemsWidth == 0.0 {
            pageTabItemsWidth = floor(scrollView.contentSize.width / 3.0)
        }

        if (scrollView.contentOffset.x <= 0.0) || (scrollView.contentOffset.x > pageTabItemsWidth * 2.0) {
            scrollView.contentOffset.x = pageTabItemsWidth
        }

    }

    internal func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // Accept the touch event because animation is complete
        updateCollectionViewUserInteractionEnabled(true)


        let indexPath = IndexPath(item: currentIndex, section: 0)
        if shouldScrollToItem {
            // After the moved so as not to sense of incongruity, to adjust the contentOffset at the currentIndex
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            shouldScrollToItem = false
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension NTScrollableTabBar: UICollectionViewDelegateFlowLayout {

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

//        if let size = cachedCellSizes[indexPath] {
//            return size
//        }
//        
//        let cell = NTScrollableTabBarItem()
//
//        configureCell(cell, indexPath: indexPath)
//
//        let size = cell.sizeThatFits(CGSize(width: collectionView.bounds.width, height: properties.tabHeight))
//        cachedCellSizes[indexPath] = size
        
        let size = CGSize(width: (UIScreen.main.bounds.width / CGFloat(pageTabItemsCount)), height: properties.tabHeight)

        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
