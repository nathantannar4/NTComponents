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

open class NTScrollableTabBarController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    override open var title: String? {
        didSet {
            self.refreshTitleView(withAlpha: 1.0)
        }
    }
    open var subtitle: String? {
        didSet {
            self.refreshTitleView(withAlpha: 1.0)
        }
    }
    
    public var currentIndex: Int? {
        get {
            guard let viewController = viewControllers?.first else {
                return nil
            }
            return _viewControllers?.index(of: viewController)
        }
    }
    
    fileprivate var _viewControllers: [UIViewController]?
    fileprivate var beforeIndex: Int = 0
    fileprivate var viewControllerCount: Int {
        get {
            return _viewControllers?.count ?? 0
        }
    }
    fileprivate var defaultContentOffsetX: CGFloat {
        return self.view.bounds.width
    }
    fileprivate var shouldScrollCurrentBar: Bool = true
    fileprivate var tabView: NTScrollableTabBar?
    fileprivate var tabBarTopConstraint: NSLayoutConstraint?
    
    public var currentTabBarHeight: CGFloat = 2
    public var tabBarHeight: CGFloat = 32
    public var tabBarPosition: NTTabBarPosition = .top
    

    // MARK: - Initialization
    
    public convenience init() {
        self.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    public convenience init(viewControllers: [UIViewController]) {
        self.init()
        _viewControllers = viewControllers
    }
    
    public override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        _viewControllers = [UIViewController()]
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Standard Methods

    override open func viewDidLoad() {
        super.viewDidLoad()

        setupPageViewController()
        setupScrollView()
        updateNavigationBar()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if tabView?.superview == nil {
            tabView = configuredTabView()
        }

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
        view.setNeedsDisplay()
    }

    public func displayControllerWithIndex(_ index: Int, direction: UIPageViewControllerNavigationDirection, animated: Bool) {

        beforeIndex = index
        shouldScrollCurrentBar = false
        guard let viewControllers = _viewControllers else {
            return
        }
        let nextViewControllers: [UIViewController] = [viewControllers[index]]

        let completion: ((Bool) -> Void) = { [weak self] _ in
            self?.shouldScrollCurrentBar = true
            self?.beforeIndex = index
        }

        setViewControllers(
            nextViewControllers,
            direction: direction,
            animated: animated,
            completion: completion)

        guard isViewLoaded else { return }
        tabView?.updateCurrentIndex(index, shouldScroll: true)
    }
    
    fileprivate func setupPageViewController() {
        dataSource = self
        delegate = self
        automaticallyAdjustsScrollViewInsets = false
        
        
        guard let viewControllers = _viewControllers else {
            return
        }
        
        setViewControllers([viewControllers[beforeIndex]],
                           direction: .forward,
                           animated: false,
                           completion: nil)
    }

    fileprivate func setupScrollView() {
        // Disable PageViewController's ScrollView bounce
        let scrollView = view.subviews.flatMap { $0 as? UIScrollView }.first
        scrollView?.scrollsToTop = false
        scrollView?.delegate = self
        scrollView?.backgroundColor = Color.Default.Background.ViewController
    }


    fileprivate func updateNavigationBar() {
        if let navigationBar = navigationController?.navigationBar, tabBarPosition == .top {
            navigationBar.layer.shadowOpacity = 0
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
    }

    fileprivate func configuredTabView() -> NTScrollableTabBar {
        let tabView = NTScrollableTabBar(barHeight: currentTabBarHeight, barPosition: tabBarPosition, tabHeight: tabBarHeight)
        tabView.translatesAutoresizingMaskIntoConstraints = false

        let height = NSLayoutConstraint(item: tabView,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .height,
                                        multiplier: 1.0,
                                        constant: tabBarHeight)
        tabView.addConstraint(height)
        view.addSubview(tabView)
        
        if tabBarPosition == .top {
            tabView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        } else {
            tabView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        }
        
        let _ = (_viewControllers ?? []).map({ $0.viewDidLoad() })
      
        tabView.pageTabItems = (_viewControllers ?? []).map({ $0.title ?? String() })
        tabView.updateCurrentIndex(beforeIndex, shouldScroll: true)

        tabView.pageItemPressedBlock = { [weak self] (index: Int, direction: UIPageViewControllerNavigationDirection) in
            self?.displayControllerWithIndex(index, direction: direction, animated: true)
        }

        return tabView
    }

    private func updateTabBarOrigin(hidden: Bool) {
        guard let tabBarTopConstraint = tabBarTopConstraint else { return }

        tabBarTopConstraint.constant = hidden ? -(20.0 + tabBarHeight) : 0.0
        UIView.animate(withDuration: TimeInterval(UINavigationControllerHideShowBarDuration)) {
            self.view.layoutIfNeeded()
        }
    }
    
    public func refreshTitleView(withAlpha alpha: CGFloat) {
        if self.title != nil {
            self.setTitleView(title: self.title, subtitle: self.subtitle, titleColor: Color.Default.Text.Title.withAlphaComponent(alpha), subtitleColor: Color.Default.Text.Subtitle.withAlphaComponent(alpha))
        }
    }
    
    // MARK: - UIPageViewControllerDataSource

    fileprivate func nextViewController(_ viewController: UIViewController, isAfter: Bool) -> UIViewController? {

        guard var index = _viewControllers?.index(of: viewController) else {
            return nil
        }

        if isAfter {
            index += 1
        } else {
            index -= 1
        }

        if index >= 0 && index < (_viewControllers?.count ?? 0) {
            return _viewControllers?[index]
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
}
