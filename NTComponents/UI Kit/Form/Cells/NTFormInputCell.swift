//
//  NTFormInputCell.swift
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


open class NTFormInputCell: NTFormCell {
    
    open override var datasourceItem: Any? {
        get {
            return self
        }
        set {
            guard let cell = newValue as? NTFormInputCell else { return }
            self.textField.removeFromSuperview()
            self.label.removeFromSuperview()
            self.label = cell.label
            self.textField = cell.textField
            self.setupViews()
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
    
    open var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    open var placeholder: String? {
        get {
            return textField.placeholder
        }
        set {
            textField.placeholder = newValue
        }
    }
    
    open var label: NTLabel = {
        let label = NTLabel(style: .callout)
        label.text = "Label"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    open var textField: NTTextField = {
        let textField = NTTextField(style: .body)
        textField.placeholder = "Edit.."
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    // MARK: - Handlers
    
    @discardableResult
    open func onTextFieldUpdate(_ handler: @escaping ((NTTextField) -> Void)) -> Self {
        textField.onTextFieldUpdate = handler
        return self
    }
    
    // MARK: - Setup
    
    open override func setupViews() {
        super.setupViews()
        
        addSubview(textField)
        addSubview(label)
        
        label.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 2, leftConstant: 16, bottomConstant: 2, rightConstant: 0, widthConstant: 80, heightConstant: 0)
        textField.anchor(topAnchor, left: label.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 2, leftConstant: 2, bottomConstant: 2, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        textField.addToolBar(withItems: [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton])
    }
    
    @objc open func dismissKeyboard() {
        textField.resignFirstResponder()
    }
}
