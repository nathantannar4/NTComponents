//
//  ContainerController.swift
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
//  Created by Nathan Tannar on 6/29/17.
//

import NTComponents

class ContainerController: NTDrawerController {
    
    var toggleButton: NTButton = {
        let button = NTButton()
        button.setIcon(icon: FAType.FANavicon, iconSize: 30, forState: .normal)
        button.layer.cornerRadius = 30
        button.trackTouchLocation = false
        button.ripplePercent = 1
        return button
    }()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rightViewProperties.width = 225
        rightViewProperties.overflowView.backgroundColor = .white
        rightViewProperties.additionalCloseAnimations = {
            UIApplication.shared.isStatusBarHidden = true
        }
        
        view.addSubview(toggleButton)
        toggleButton.addTarget(self, action: #selector(toggleRightViewController(_:)), for: .touchUpInside)
        toggleButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 48, leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 60, heightConstant: 60)
        toggleButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveLinear, animations: {
            self.toggleButton.transform = CGAffineTransform(translationX: 1.2, y: 1.2)
        }) { _ in
            self.toggleButton.transform = CGAffineTransform.identity
        }
    }
}
