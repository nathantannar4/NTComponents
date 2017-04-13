//
//  NTAlertController.swift
//  NTComponents
//
//  Created by Nathan Tannar on 4/12/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTAlertViewController: UIViewController {
    
    public var didSetupConstraints = false
    open let titleLabel: NTLabel = {
        let label = NTLabel(type: .title)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let buttonContainer: NTView = {
        let view = NTView()
        view.backgroundColor = .white
        view.setDefaultShadow()
        return view
    }()
    
    fileprivate let cancelButton: NTButton = {
        let button = NTButton()
        button.title = "Cancel"
        button.titleColor = .white
        button.backgroundColor = Color.Red.P500
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()
    
    fileprivate let confirmButton: NTButton = {
        let button = NTButton()
        button.title = "Confirm"
        button.titleColor = .white
        button.backgroundColor = Color.Defaults.tint
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(confirmButtonPresssed), for: .touchUpInside)
        return button
    }()
    
    public var onCancel : (() -> Void)?
    public var onConfirm : (() -> Void)?
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        view.addSubview(buttonContainer)
        buttonContainer.addSubview(cancelButton)
        buttonContainer.addSubview(confirmationButton)
        updateViewConstraints()
    }
    
    func cancelButtonPressed() {
        dismiss(animated: false, completion: nil)
    }
    
    func confirmButtonPresssed() {
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func setTitleLabel(text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Center
        paragraphStyle.lineSpacing = 4.5
        titleLabel.attributedText = NSMutableAttributedString(
            string: text,
            attributes: [
                NSFontAttributeName: UIFont(name: "AvenirNextLTPro-Regular", size: 14)!,
                NSForegroundColorAttributeName: UIColor.colorFromCode(0x151515),
                NSKernAttributeName: 0.5,
                NSParagraphStyleAttributeName: paragraphStyle
            ]
        )
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            titleLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10), excludingEdge: .Bottom)
            titleLabel.autoAlignAxisToSuperviewAxis(.Vertical)
            
            buttonContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: 3)
            buttonContainer.autoAlignAxisToSuperviewAxis(.Vertical)
            buttonContainer.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10)
            
            let contactViews: NSArray = [cancelButton, confirmationButton]
            contactViews.autoDistributeViewsAlongAxis(.Horizontal, alignedTo: .Horizontal, withFixedSpacing: 7, insetSpacing: true, matchedSizes: false)
            
            cancelButton.autoPinEdgeToSuperviewEdge(.Top)
            cancelButton.autoPinEdgeToSuperviewEdge(.Bottom)
            cancelButton.autoSetDimensionsToSize(CGSize(width: 100, height: 50))
            
            confirmationButton.autoPinEdgeToSuperviewEdge(.Top)
            confirmationButton.autoPinEdgeToSuperviewEdge(.Bottom)
            confirmationButton.autoSetDimensionsToSize(CGSize(width: 100, height: 50))
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
