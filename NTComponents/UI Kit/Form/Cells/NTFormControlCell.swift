//
//  NTFormControlCell.swift
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
//  Created by Nathan Tannar on 6/6/17.
//

open class NTFormControlCell<T: UIControl>: NTFormCell {
    
    open override var datasourceItem: Any? {
        get {
            return self
        }
        set {
            guard let cell = newValue as? NTFormControlCell<T> else { return }
            self.control.removeFromSuperview()
            self.label.removeFromSuperview()
            self.label = cell.label
            self.control = cell.control
            self.onControlChanged = cell.onControlChanged
            self.setupViews()
            self.control.addTarget(self, action: #selector(controlDidChange), for: UIControlEvents.valueChanged)
        }
    }
    
    open var title: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    
    open var control: T = {
        let control = T()
        return control
    }()

    open var label: NTLabel = {
        let label = NTLabel(style: .callout)
        label.text = "Label"
        return label
    }()
    
    // MARK: - Handlers
    
    open var onControlChanged: ((T) -> Void)?
    
    @discardableResult
    open func onControlChanged(_ handler: @escaping ((AnyObject) -> Void)) -> Self {
        if control is NTSwitch {
            (control as! NTSwitch).onSwitchChanged = handler
        } else if control is NTCheckbox {
            (control as! NTCheckbox).onCheckboxChanged = handler
        } else if control is NTSegmentedControl {
            (control as! NTSegmentedControl).onSelectionChanged = handler
        } else {
            onControlChanged = handler
        }
        return self
    }
    
    @objc open func controlDidChange() {
        onControlChanged?(control)
    }
    
    // MARK: - Setup
    
    open override func setupViews() {
        super.setupViews()
        
        addSubview(label)
        addSubview(control)
        
        label.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: control.leftAnchor, topConstant: 2, leftConstant: 16, bottomConstant: 2, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        if control is NTSwitch {
            control.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 12, rightConstant: 16, widthConstant: 40, heightConstant: 0)
        } else if control is NTSegmentedControl {
            let width = (control as! NTSegmentedControl).numberOfSegments * 50
            control.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 2, rightConstant: 16, widthConstant: CGFloat(width), heightConstant: 0)
            
        } else {
            control.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 8, rightConstant: 22, widthConstant: 28, heightConstant: 0)
        }
    }
}
