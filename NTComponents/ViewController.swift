//
//  ViewController.swift
//  NTComponents
//
//  Created by Nathan Tannar on 12/28/16.
//  Copyright © 2016 Nathan Tannar. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    public func setTitleView(title: String? = nil, subtitle: String? = nil, titleColor: UIColor? = Color.Defaults.titleTextColor, subtitleColor: UIColor? = Color.Defaults.subtitleTextColor) {
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = titleColor ?? Color.Defaults.titleTextColor
        titleLabel.font = Font.Defaults.title.withSize(18)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.textColor = subtitleColor ?? Color.Defaults.subtitleTextColor
        subtitleLabel.font = Font.Defaults.subtitle.withSize(14)
        subtitleLabel.text = subtitle
        subtitleLabel.textAlignment = .center
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        if subtitle != nil {
            titleView.addSubview(subtitleLabel)
        } else {
            titleLabel.frame = titleView.frame
        }
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        navigationItem.titleView = titleView
        
    }
    
    public func presentViewController(_ viewController: UIViewController, from: NTPresentationDirection, completion:  (() -> Void)?) {
        viewController.view.alpha = 0.0
        viewController.modalPresentationStyle = .overCurrentContext
        let windowFrame = self.view.window!.frame
        let viewFrame = viewController.view.frame
        let finalFrame = viewFrame
        self.present(viewController, animated: false) { () -> Void in
            switch from {
            case .top:
                viewController.view.frame = CGRect(x: viewFrame.origin.x, y: -windowFrame.height, width: viewFrame.width, height: viewFrame.height)
            case .right:
                viewController.view.frame = CGRect(x: windowFrame.width, y: viewFrame.origin.y, width: viewFrame.width, height: viewFrame.height)
            case .bottom:
                viewController.view.frame = CGRect(x: viewFrame.origin.x, y: windowFrame.height, width: viewFrame.width, height: viewFrame.height)
            case .left:
                viewController.view.frame = CGRect(x: -windowFrame.width, y: viewFrame.origin.y, width: viewFrame.width, height: viewFrame.height)
            }
            viewController.view.alpha = 1.0
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                viewController.view.frame = finalFrame
            }, completion: { (success) -> Void in
                if success && (completion != nil) {
                    completion!()
                }
            })
        }
    }
    
    func dismissViewController(to: NTPresentationDirection, completion:  (() -> Void)?) {
        let frame = self.view.frame
        guard let windowFrame = self.view.window?.frame else {
            return
        }
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            switch to {
            case .top:
                self.view.frame = CGRect(x: frame.origin.x, y: -windowFrame.height, width: frame.width, height: frame.height)
            case .right:
                self.view.frame = CGRect(x: windowFrame.width, y: frame.origin.y, width: frame.width, height: frame.height)
            case .bottom:
                self.view.frame = CGRect(x: frame.origin.x, y: windowFrame.height, width: frame.width, height: frame.height)
            case .left:
                self.view.frame = CGRect(x: -windowFrame.width, y: frame.origin.y, width: frame.width, height: frame.height)
            }
        }, completion: { (success) -> Void in
            if success == true {
                self.dismiss(animated: false, completion: {
                    if completion != nil {
                        completion!()
                    }
                })
            }
        })
    }
}

