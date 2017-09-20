//
//  NTFormActionCell.swift
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
//  Created by Nathan Tannar on 6/23/17.
//

open class NTFormActionCell: NTFormCell {
    
    open override var datasourceItem: Any? {
        get {
            return self
        }
        set {
            guard let cell = newValue as? NTFormActionCell else { return }
            self.button.removeFromSuperview()
            self.button = cell.button
            self.onTap = cell.onTap
            self.setupViews()
        }
    }
    
    open var title: String? {
        get {
            return button.title
        }
        set {
            button.title = newValue
        }
    }
    
    open var button: NTButton = {
        let button = NTButton()
        button.backgroundColor = .white
        return button
    }()
    
    open var onTap: (() -> Void)?
    
    @discardableResult
    open func onTap(_ handler: @escaping (() -> Void)) -> Self {
        onTap = handler
        return self
    }

    open override func setupViews() {
        super.setupViews()
        
        addSubview(button)
        button.fillSuperview()
        button.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
    }
    
    @objc open func didTap(_ sender: AnyObject) {
        onTap?()
    }
}
