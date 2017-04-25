//
//  NTSearchBarView.swift
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

open class NTSearchBarView: NTView, UITextFieldDelegate {


    open var onSearch: ((query: String?) -> Void)?

    open var searchField: NTTextField = {
        let textField = NTTextField()
        textField.placeholder = "..."
        textField.backgroundColor = .clear
        textField.returnKeyType = .search
        return textField
    }()

    open var searchButton: NTButton = {
        let button = NTButton()
        button.title = "Search"
        button.titleFont = Font.Default.Callout
        return button()
    }()

    open var menuButton: NTButton = {
        let button = NTButton()
        button.trachTouchUpLocation = false
        return button()
    }()

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setDefaultShadow()

        addSubview(menuButton)
        addSubview(searchField)
        addSubview(searchButton)

        menuButton.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: searchField.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        let menuButtonWidth = NSLayoutConstraint(item: menuButton,
                                                   attribute: .width,
                                                   relatedBy: .lessThanOrEqual,
                                                   toItem: nil,
                                                   attribute: .width,
                                                   multiplier: 1.0,
                                                   constant: 30)
        menuButton.addConstraint(menuButtonWidth)

        searchField.anchor(topAnchor, left: menuButton.rightAnchor, bottom: bottomAnchor, right: searchButton.leftAnchor, topConstant: 5, leftConstant: 10, bottomConstant: 5, rightConstant: 10, widthConstant: 0, heightConstant: 0)

        searchButton.anchor(topAnchor, left: searchField.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        let searchButtonWidth = NSLayoutConstraint(item: searchButton,
                                                   attribute: .width,
                                                   relatedBy: .lessThanOrEqual,
                                                   toItem: nil,
                                                   attribute: .width,
                                                   multiplier: 1.0,
                                                   constant: 50)
        searchButton.addConstraint(searchButtonWidth)

        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
    }

    public convenience init(onSearch function: ((query: String?) -> Void)?) {
        self.init(frame: .zero)
        self.onSearch = function
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UITextFieldDelegate

    open func textFieldDidBeginEditing(_ textField: UITextField) {
        Log.write(.status, "SearchBar editing began")
    }

    open func textFieldDidEndEditing(_ textField: UITextField) {
        Log.write(.status, "SearchBar editing ended")
        endEditing()
    }

    open func textFieldShouldClear(_ textField: UITextField) {
        Log.write(.status, "SearchBar text cleared")
    }

    open func textFieldShouldReturn(_ textField: UITextField) {
        search()
    }

    // MARK: - Search Controller

    open func search() {
        Log.write(.status, "SearchBar search executed")
        endEditing()
        onSearch?(query: searchField.text)
    }

    open func endEditing() {
        searchField.resignFirstResponder()
    }
}
