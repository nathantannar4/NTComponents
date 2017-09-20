//
//  NTFormLongInputCell.swift
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

open class NTFormLongInputCell: NTFormCell {
    
    open override var datasourceItem: Any? {
        get {
            return self
        }
        set {
            guard let cell = newValue as? NTFormLongInputCell else { return }
            self.textView.removeFromSuperview()
            self.label.removeFromSuperview()
            self.label = cell.label
            self.textView = cell.textView
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
            return textView.text
        }
        set {
            textView.text = newValue
        }
    }
    
    open var placeholder: String? {
        get {
            return textView.placeholder
        }
        set {
            textView.placeholder = newValue
        }
    }
    
    open var label: NTLabel = {
        let label = NTLabel(style: .callout)
        label.text = "Label"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    open var textView: NTTextView = {
        let textView = NTTextView()
        textView.placeholder = "Edit.."
        return textView
    }()
    
    // MARK: - Handlers
    
    @discardableResult
    open func onTextViewUpdate(_ handler: @escaping ((NTTextView) -> Void)) -> Self {
        textView.onTextViewUpdate = handler
        return self
    }
    
    // MARK: - Setup
    
    open override func setupViews() {
        super.setupViews()
        
        addSubview(label)
        addSubview(textView)
    
        label.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 2, leftConstant: 16, bottomConstant: 2, rightConstant: 0, widthConstant: 80, heightConstant: 40)
        textView.anchor(topAnchor, left: label.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 14, leftConstant: 2, bottomConstant: 2, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        textView.addToolBar(withItems: [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton])
    }
    
    @objc open func dismissKeyboard() {
        textView.resignFirstResponder()
    }
    
    open override class var cellSize: CGSize {
        get {
            return CGSize(width: UIScreen.main.bounds.width, height: 120)
        }
    }
}
