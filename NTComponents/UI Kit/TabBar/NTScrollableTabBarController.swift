//
//  NTScrollableTabBarController.swift
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

public enum NTTabBarPosition {
    case top, bottom
}

public extension UIViewController {
    var scrollableTabBarController: NTScrollableTabBarController? {
        var parentViewController = parent
        
        while parentViewController != nil {
            if let view = parentViewController as? NTScrollableTabBarController {
                return view
            }
            parentViewController = parentViewController!.parent
        }
        Log.write(.warning, "View controller did not have an NTScrollableTabBarController as a parent")
        return nil
    }
}

open class NTScrollableTabBarController: NTViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    public var currentIndex: Int? {
        get {
            guard let viewController = pageViewController.viewControllers?.first else {
                return nil
            }
            return viewControllers.index(of: viewController)
        }
    }
    
    open var pageViewController: UIPageViewController = {
        let viewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        viewController.view.backgroundColor = .clear
        return viewController
    }()
    
    fileprivate var viewControllers: [UIViewController] = [NTViewController()]
    fileprivate var beforeIndex: Int = 0
    fileprivate var viewControllerCount: Int {
        get {
            return viewControllers.count
        }
    }
    fileprivate var defaultContentOffsetX: CGFloat {
        return self.view.bounds.width
    }
    fileprivate var shouldScrollCurrentBar: Bool = true
    
    open var tabBar: NTScrollableTabBar?
    open var tabBarTopConstraint: NSLayoutConstraint?
    open var currentTabBarHeight: CGFloat = 2.5
    open var tabBarHeight: CGFloat = 32
    open var tabBarItemWidth: CGFloat = 0
    open var tabBarPosition: NTTabBarPosition = .top {
        didSet {
            updateNavigationBar()
        }
    }
    
    // MARK: - Initialization
    
    public convenience init(viewControllers: [UIViewController]) {
        self.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Standard Methods

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageViewController()
        setupTabBar()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewControllers[beforeIndex].beginAppearanceTransition(true, animated: true)
        if let currentIndex = currentIndex {
            tabBar?.updateCurrentIndex(currentIndex, shouldScroll: true)
        }
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewControllers[beforeIndex].endAppearanceTransition()
        tabBar?.layouted = true
    }
    
    open override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        tabBar?.collectionView.collectionViewLayout.invalidateLayout()
        tabBar?.setNeedsDisplay()
        view.setNeedsDisplay()
        DispatchQueue.main.async {
            self.tabBar?.updateCurrentIndex(self.tabBar!.currentIndex, shouldScroll: true)
        }
    }

    open func displayControllerWithIndex(_ index: Int, direction: UIPageViewControllerNavigationDirection, animated: Bool) {

        beforeIndex = index
        shouldScrollCurrentBar = false
        
        let nextViewControllers: [UIViewController] = [viewControllers[index]]

        let completion: ((Bool) -> Void) = { [weak self] _ in
            self?.shouldScrollCurrentBar = true
            self?.beforeIndex = index
        }

        pageViewController.setViewControllers(
            nextViewControllers,
            direction: direction,
            animated: animated,
            completion: completion)

        guard isViewLoaded else { return }
        tabBar?.updateCurrentIndex(index, shouldScroll: true)
    }
    
    open func setupPageViewController() {
        pageViewController.beginAppearanceTransition(true, animated: true)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        automaticallyAdjustsScrollViewInsets = false
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
    
        for vc in viewControllers {
            pageViewController.addChildViewController(vc)
            vc.didMove(toParentViewController: pageViewController)
        }
        
        pageViewController.setViewControllers([viewControllers[beforeIndex]],
                           direction: .forward,
                           animated: false,
                           completion: nil)
        pageViewController.endAppearanceTransition()
        setupScrollView()
    }

    open func setupScrollView() {
        let scrollView = pageViewController.view.subviews.flatMap { $0 as? UIScrollView }.first
        scrollView?.scrollsToTop = false
        scrollView?.delegate = self
    }


    open func updateNavigationBar() {
        if tabBarPosition == .top {
            navigationController?.navigationBar.layer.shadowOpacity = 0
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.hideShadow()
        } else {
            navigationController?.navigationBar.setDefaultShadow()
        }
    }

    open func setupTabBar() {
        let tabBar = NTScrollableTabBar(barHeight: currentTabBarHeight, barPosition: tabBarPosition, tabHeight: tabBarHeight, itemWidth: tabBarItemWidth)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBar)
        self.tabBar?.removeFromSuperview()
        self.tabBar = nil
        self.tabBar = tabBar
        
        applytabBarContraints()
        
        if tabBarPosition == .top {
            pageViewController.view.anchor(tabBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            updateNavigationBar()
        } else {
            pageViewController.view.anchor(view.topAnchor, left: view.leftAnchor, bottom: tabBar.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        }
        
        self.tabBar?.pageTabItems = viewControllers.map({ $0.title ?? String() })
        self.tabBar?.updateCurrentIndex(beforeIndex, shouldScroll: true)
        
        self.tabBar?.pageItemPressedBlock = { [weak self] (index: Int, direction: UIPageViewControllerNavigationDirection) in
            self?.displayControllerWithIndex(index, direction: direction, animated: true)
        }
    }
    
    open func applytabBarContraints() {
        if tabBarPosition == .top {
            tabBarTopConstraint = tabBar?.anchorWithReturnAnchors(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: tabBarHeight)[0]
        } else {
            tabBarTopConstraint = tabBar?.anchorWithReturnAnchors(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: tabBarHeight)[0]
        }
    }

    open func updateTabBarOrigin(hidden: Bool) {
        guard let tabBarTopConstraint = tabBarTopConstraint else { return }
        
        if !hidden && tabBarTopConstraint.constant == 0.0 {
            return
        } else if hidden && tabBarTopConstraint.constant != 0.0 {
            return
        }
        
        if tabBarPosition == .top {
            tabBarTopConstraint.constant = hidden ? -tabBarHeight : 0.0
        } else {
            tabBarTopConstraint.constant = hidden ? tabBarHeight : 0.0
        }
        UIView.animate(withDuration: 2 * TimeInterval(UINavigationControllerHideShowBarDuration)) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - UIPageViewControllerDataSource

    fileprivate func nextViewController(_ viewController: UIViewController, isAfter: Bool) -> UIViewController? {

        guard var index = viewControllers.index(of: viewController) else { return nil }
        if isAfter {
            index += 1
        } else {
            index -= 1
        }

        if index >= 0 && index < viewControllerCount {
            return viewControllers[index]
        }
        return nil
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController, isAfter: true)
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController, isAfter: false)
    }
    
    // MARK: - UIPageViewControllerDelegate

    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        shouldScrollCurrentBar = true
        tabBar?.scrollToHorizontalCenter()

        // Order to prevent the the hit repeatedly during animation
        tabBar?.updateCollectionViewUserInteractionEnabled(false)
    }

    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentIndex = currentIndex , currentIndex < viewControllerCount {
            tabBar?.updateCurrentIndex(currentIndex, shouldScroll: false)
            beforeIndex = currentIndex
        }
        
        tabBar?.updateCollectionViewUserInteractionEnabled(true)
    }
    
    // MARK: - UIScrollViewDelegate

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == defaultContentOffsetX || !shouldScrollCurrentBar {
            return
        }

        var index: Int
        if scrollView.contentOffset.x > defaultContentOffsetX {
            index = beforeIndex + 1
        } else {
            index = beforeIndex - 1
        }
        
        if index == viewControllerCount {
            index = 0
        } else if index < 0 {
            index = viewControllerCount - 1
        }

        let scrollOffsetX = scrollView.contentOffset.x - view.frame.width
        tabBar?.scrollCurrentBarView(index, contentOffsetX: scrollOffsetX)
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tabBar?.updateCurrentIndex(beforeIndex, shouldScroll: true)
    }
}
