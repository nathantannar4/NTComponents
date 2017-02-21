//
//  NTPageViewController.swift
//  NTUIKit
//
//  Created by Nathan Tannar on 2/12/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTPageViewController: NTViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    public var viewControllers: [UIViewController] = []
    
    private var pageViewController: UIPageViewController!
    private var initialIndex: Int!

    
    // MARK: Initialization
    
    public convenience init(viewControllers: [UIViewController], initialIndex index: Int) {
        self.init()
        self.viewControllers = viewControllers
        self.initialIndex = index
        
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
        self.pageViewController.view.bindFrameToSuperviewBounds()
        self.pageViewController.setViewControllers([self.viewControllers[index]], direction: .forward, animated: false, completion: nil)
        
        self.pageViewController.view.backgroundColor = UIColor.groupTableViewBackground
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = self.viewControllers.index(of: viewController) else {
            return nil
        }
        if (currentIndex - 1) < 0 {
            return nil
        }
        return self.viewControllers[currentIndex - 1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = self.viewControllers.index(of: viewController) else {
            return nil
        }
        if (currentIndex + 1) == self.viewControllers.count {
            return nil
        }
        return self.viewControllers[currentIndex + 1]
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.viewControllers.count
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.initialIndex
    }
}
