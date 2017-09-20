//
//  NTFormTagInputCell.swift
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
//  Created by Nathan Tannar on 6/13/17.
//


open class NTFormTagInputCell: NTFormCell, NTTagListViewDelegate, UITextFieldDelegate {
    
    open override var datasourceItem: Any? {
        get {
            return self
        }
        set {
            guard let cell = newValue as? NTFormTagInputCell else { return }
            self.textField.removeFromSuperview()
            self.label.removeFromSuperview()
            self.tagListView.removeFromSuperview()
            self.textField = cell.textField
            self.label = cell.label
            self.tagListView = cell.tagListView
            self.onTagAdded = cell.onTagAdded
            self.onTagDeleted = cell.onTagDeleted
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
    
    open var tagListView: NTTagListView = {
        let tagListView = NTTagListView()
        tagListView.contentInset.top = 4
        tagListView.showsVerticalScrollIndicator = false
        return tagListView
    }()
    
    open var label: NTLabel = {
        let label = NTLabel(style: .callout)
        label.text = "Label"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    open var textField: NTTextField = {
        let textField = NTTextField(style: .body)
        textField.clearButtonMode = .whileEditing
        textField.placeholder = "Separated with commas"
        textField.returnKeyType = .continue
        return textField
    }()
    
    // MARK: - Handlers
    
    open var onTagAdded: ((NTTagView, NTTagListView) -> Void)?
    open var onTagDeleted: ((NTTagView, NTTagListView) -> Void)?
    
    @discardableResult
    open func onTagAdded(_ handler: @escaping ((NTTagView, NTTagListView) -> Void)) -> Self {
        onTagAdded = handler
        return self
    }
    
    @discardableResult
    open func onTagDeleted(_ handler: @escaping ((NTTagView, NTTagListView) -> Void)) -> Self {
        onTagDeleted = handler
        return self
    }
    
    // MARK: - Setup
    
    open override func setupViews() {
        super.setupViews()
        
        addSubview(textField)
        addSubview(label)
        addSubview(tagListView)
        
        tagListView.tagDelegate = self
        textField.delegate = self
        textField.onTextFieldUpdate { (textField) in
            guard var text = textField.text else {
                return
            }
            if text.characters.last == "," {
                //.substring(to: text.index(before: text.endIndex))
                let tagText = String(text[..<text.endIndex])
                if !tagText.isEmpty {
                    self.tagListView.addTag(tagText)
                    textField.text = String()
                    DispatchQueue.executeAfter(0.1, closure: {
                        var offset = self.tagListView.contentOffset
                        offset.y = self.tagListView.contentSize.height + self.tagListView.contentInset.bottom - self.tagListView.bounds.size.height
                        self.tagListView.setContentOffset(offset, animated: true)
                    })
                }
            }
        }
        
        tagListView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: NTFormTagInputCell.cellSize.height - 44)
        
        label.anchor(tagListView.bottomAnchor, left: tagListView.leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 2, leftConstant: 0, bottomConstant: 2, rightConstant: 0, widthConstant: 80, heightConstant: 0)
        
        textField.anchor(tagListView.bottomAnchor, left: label.rightAnchor, bottom: bottomAnchor, right: tagListView.rightAnchor, topConstant: 2, leftConstant: 2, bottomConstant: 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        textField.addToolBar(withItems: [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton])
    }
    
    @objc open func dismissKeyboard() {
        textField.resignFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return true
        }
        if !text.isEmpty {
            self.tagListView.addTag(text)
            textField.text = String()
            DispatchQueue.executeAfter(0.1, closure: {
                var offset = self.tagListView.contentOffset
                offset.y = self.tagListView.contentSize.height + self.tagListView.contentInset.bottom - self.tagListView.bounds.size.height
                self.tagListView.setContentOffset(offset, animated: true)
            })
            return false
        }
        return true
    }
    
    // MARK: NTTagListViewDelegate
    
    open func tagAdded(_ tagView: NTTagView, sender: NTTagListView) {
        onTagAdded?(tagView, sender)
    }
    
    open func tagDeleted(_ tagView: NTTagView, sender: NTTagListView) {
        onTagDeleted?(tagView, sender)
    }
    
    open override class var cellSize: CGSize {
        get {
            return CGSize(width: UIScreen.main.bounds.width, height: 120)
        }
    }
}
