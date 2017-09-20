//
//  NTPageViewController.swift
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

open class NTPageViewController: NTViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    open var viewControllers: [UIViewController] = []
    
    open var pageViewController: UIPageViewController = {
        let viewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        viewController.view.backgroundColor = Color.Default.Background.ViewController
        return viewController
    }()
    
    internal var currentIndex: Int = 0
    
    fileprivate var defaultContentOffsetX: CGFloat {
        return self.view.bounds.width
    }
    
    open weak var pageControl: UIPageControl?

    // MARK: - Initialization
    
    public convenience init(viewControllers: [UIViewController], initialIndex index: Int = 0) {
        self.init()
        self.viewControllers = viewControllers
        self.currentIndex = index
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Standard Methods

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
        pageViewController.view.fillSuperview()
        pageViewController.setViewControllers([viewControllers[currentIndex]], direction: .forward, animated: false, completion: nil)
        setupScrollView()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for subview in pageViewController.view.subviews {
            if let view = subview as? UIPageControl {
                pageControl = view
            }
        }
        
        pageControl?.backgroundColor = UIColor.clear
        pageControl?.pageIndicatorTintColor = Color.Default.Tint.NavigationBar
        pageControl?.currentPageIndicatorTintColor = Color.Default.Tint.NavigationBar.lighter(by: 20)
        pageControl?.isHidden = true
    }
    
    // MARK: - NTPageViewController Methods
    
    @objc open func slideToNextViewController() {
        displayControllerWithIndex(currentIndex + 1, direction: .forward, animated: true)
    }
    
    @objc open func slideToPreviousViewController() {
        displayControllerWithIndex(currentIndex - 1, direction: .reverse, animated: true)
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllers.index(of: viewController) else {
            return nil
        }
        if (currentIndex - 1) < 0 {
            return nil
        }
        return viewControllers[currentIndex - 1]
    }
    
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllers.index(of: viewController) else {
            return nil
        }
        if (currentIndex + 1) == viewControllers.count {
            return nil
        }
        return viewControllers[currentIndex + 1]
    }
    
    open func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllers.count
    }
    
    open func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
    
    fileprivate func nextViewController(_ viewController: UIViewController, isAfter: Bool) -> UIViewController? {
        
        guard var index = viewControllers.index(of: viewController) else {
            return nil
        }
        
        if isAfter {
            index += 1
        } else {
            index -= 1
        }
        
        if index >= 0 && index < viewControllers.count {
            return viewControllers[index]
        }
        return nil
    }
    
    // MARK: - UIPageViewControllerDelegate
    
    open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            currentIndex = viewControllers.index(of: pageViewController.viewControllers![0])!
        }
    }
    
    open func displayControllerWithIndex(_ index: Int, direction: UIPageViewControllerNavigationDirection, animated: Bool) {
        
        if index < 0 || index >= viewControllers.count {
            return
        }
        
        let nextViewControllers = [viewControllers[index]]
        
        let completion: ((Bool) -> Void) = { [weak self] _ in
            self?.currentIndex = index
        }
        
        pageViewController.setViewControllers(
            nextViewControllers,
            direction: direction,
            animated: animated,
            completion: completion)
    }
    
    // MARK: - UIScrollViewDelegate
    
    fileprivate func setupScrollView() {
        // Disable UIPageViewController's ScrollView bounce
        let scrollView = pageViewController.view.subviews.flatMap { $0 as? UIScrollView }.first
        scrollView?.scrollsToTop = false
        scrollView?.delegate = self
        scrollView?.backgroundColor = Color.Default.Background.ViewController
    }
}
