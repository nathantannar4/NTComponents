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
        self.pageViewController.view.fillSuperview()
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
