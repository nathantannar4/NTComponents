//
//  NTTextField.swift
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
//  Created by Nathan Tannar on 4/25/17.
//

open class NTTextField: UITextField {
    
    open var onTextFieldUpdate: ((NTTextField) -> Void)?
    open var onBeginEditing: ((NTTextField) -> Void)?
    open var onEndEditing: ((NTTextField) -> Void)?
    
    @discardableResult
    open func onTextFieldUpdate(_ handler: @escaping ((NTTextField) -> Void)) -> Self {
        onTextFieldUpdate = handler
        return self
    }
    
    @discardableResult
    open func onBeginEditing(_ handler: @escaping ((NTTextField) -> Void)) -> Self {
        onBeginEditing = handler
        return self
    }
    
    @discardableResult
    open func onEndEditing(_ handler: @escaping ((NTTextField) -> Void)) -> Self {
        onEndEditing = handler
        return self
    }

    // MARK: - Initialization

    public convenience init(style: NTPreferredFontStyle) {
        self.init()
        self.setPreferredFontStyle(to: style)
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setPreferredFontStyle(to: .body)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {
        
        tintColor = Color.Default.Tint.View
        addTarget(self, action: #selector(textFieldDidUpdate(textField:)), for: .allEditingEvents)
        addTarget(self, action: #selector(textFieldDidBeginEditing(textField:)), for: .editingDidBegin)
        addTarget(self, action: #selector(textFieldDidEndEditing(textField:)), for: .editingDidEnd)
    }
    
    @objc open func textFieldDidUpdate(textField: NTTextField) {
        onTextFieldUpdate?(textField)
    }
    
    @objc open func textFieldDidBeginEditing(textField: NTTextField) {
        onBeginEditing?(textField)
    }
    
    @objc open func textFieldDidEndEditing(textField: NTTextField) {
        onEndEditing?(textField)
    }
}
