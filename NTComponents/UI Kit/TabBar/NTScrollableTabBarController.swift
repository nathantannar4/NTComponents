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

open class NTScrollableTabBarController: NTViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate, UINavigationControllerDelegate {
    
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
    
    fileprivate var viewControllers: [UIViewController]
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
    
    open var tabView: NTScrollableTabBar?
    open var tabBarTopConstraint: NSLayoutConstraint?
    open var currentTabBarHeight: CGFloat = 2
    open var tabBarHeight: CGFloat = 32
    open var tabBarItemWidth: CGFloat = 0
    open var tabBarPosition: NTTabBarPosition = .top
    

    // MARK: - Initialization
    
    public init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Standard Methods

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabView()
        setupPageViewController()
        setupScrollView()
        updateNavigationBar()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let currentIndex = currentIndex {
            tabView?.updateCurrentIndex(currentIndex, shouldScroll: true)
        }
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateNavigationBar()
        tabView?.layouted = true
    }
    
    open override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        tabView?.collectionView.collectionViewLayout.invalidateLayout()
        tabView?.setNeedsDisplay()
        view.setNeedsDisplay()
        DispatchQueue.executeAfter(0.1) {
            self.tabView?.updateCurrentIndex(self.tabView!.currentIndex, shouldScroll: true)
        }
    }

    open func displayControllerWithIndex(_ index: Int, direction: UIPageViewControllerNavigationDirection, animated: Bool) {

        beforeIndex = index
        shouldScrollCurrentBar = false
        
        let nextViewControllers: [UIViewController] = [viewControllers[index]]

        let completion: ((Bool) -> Void) = { [weak self] _ in
            self?.shouldScrollCurrentBar = true
            self?.beforeIndex = index
            self?.viewControllers[index].viewDidAppear(false)
        }

        pageViewController.setViewControllers(
            nextViewControllers,
            direction: direction,
            animated: animated,
            completion: completion)

        guard isViewLoaded else { return }
        tabView?.updateCurrentIndex(index, shouldScroll: true)
    }
    
    fileprivate func setupPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        automaticallyAdjustsScrollViewInsets = false
        addChildViewController(pageViewController)
        view.insertSubview(pageViewController.view, belowSubview: tabView!)
        pageViewController.didMove(toParentViewController: self)
        
        if tabBarPosition == .top {
            pageViewController.view.anchor(tabView!.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        } else {
            pageViewController.view.anchor(view.topAnchor, left: view.leftAnchor, bottom: tabView!.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        }
    
        for vc in viewControllers {
            pageViewController.addChildViewController(vc)
            vc.didMove(toParentViewController: pageViewController)
        }
        
        pageViewController.setViewControllers([viewControllers[beforeIndex]],
                           direction: .forward,
                           animated: false,
                           completion: nil)
    }

    fileprivate func setupScrollView() {
        // Disable UIPageViewController's ScrollView bounce
        let scrollView = pageViewController.view.subviews.flatMap { $0 as? UIScrollView }.first
        scrollView?.scrollsToTop = false
        scrollView?.delegate = self
    }


    fileprivate func updateNavigationBar() {
        navigationController?.delegate = self
        if let navigationBar = navigationController?.navigationBar, tabBarPosition == .top {
            navigationBar.layer.shadowOpacity = 0
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
    }

    open func configureTabView() {
        let tabView = NTScrollableTabBar(barHeight: currentTabBarHeight, barPosition: tabBarPosition, tabHeight: tabBarHeight, itemWidth: tabBarItemWidth)
        tabView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabView)
        self.tabView?.removeFromSuperview()
        self.tabView = nil
        self.tabView = tabView
        
        applyTabViewContraints()
        
        let _ = viewControllers.map({ $0.viewDidLoad() })
        
        self.tabView?.pageTabItems = viewControllers.map({ $0.title ?? String() })
        self.tabView?.updateCurrentIndex(beforeIndex, shouldScroll: true)
        
        self.tabView?.pageItemPressedBlock = { [weak self] (index: Int, direction: UIPageViewControllerNavigationDirection) in
            self?.displayControllerWithIndex(index, direction: direction, animated: true)
        }

    }
    
    open func applyTabViewContraints() {
        if tabBarPosition == .top {
            tabBarTopConstraint = tabView?.anchorWithReturnAnchors(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: tabBarHeight)[0]
        } else {
            tabBarTopConstraint = tabView?.anchorWithReturnAnchors(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: tabBarHeight)[0]
        }
    }

    open func updateTabBarOrigin(hidden: Bool) {
        guard let tabBarTopConstraint = tabBarTopConstraint else { return }
        
        if tabBarPosition == .top {
            tabBarTopConstraint.constant = hidden ? -tabBarHeight : 0.0
        } else {
            tabBarTopConstraint.constant = hidden ? tabBarHeight : 0.0
        }
        if !hidden {
            navigationController?.navigationBar.hideShadow()
        } else {
            DispatchQueue.executeAfter(1.5 * TimeInterval(UINavigationControllerHideShowBarDuration), closure: {
                self.navigationController?.navigationBar.setDefaultShadow()
            })
        }
        UIView.animate(withDuration: 2 * TimeInterval(UINavigationControllerHideShowBarDuration)) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - UIPageViewControllerDataSource

    fileprivate func nextViewController(_ viewController: UIViewController, isAfter: Bool) -> UIViewController? {

        guard var index = viewControllers.index(of: viewController) else {
            return nil
        }

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
        tabView?.scrollToHorizontalCenter()
        let _ = pendingViewControllers.map({ $0.viewDidAppear(true) })

        // Order to prevent the the hit repeatedly during animation
        tabView?.updateCollectionViewUserInteractionEnabled(false)
    }

    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentIndex = currentIndex , currentIndex < viewControllerCount {
            tabView?.updateCurrentIndex(currentIndex, shouldScroll: false)
            beforeIndex = currentIndex
        }

        tabView?.updateCollectionViewUserInteractionEnabled(true)
    }
    
    // MARK: - UIScrollViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
        tabView?.scrollCurrentBarView(index, contentOffsetX: scrollOffsetX)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tabView?.updateCurrentIndex(beforeIndex, shouldScroll: true)
    }
    
    // MARK: - UINavigationControllerDelegate
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        updateTabBarOrigin(hidden: !(viewController == self))
    }
}
