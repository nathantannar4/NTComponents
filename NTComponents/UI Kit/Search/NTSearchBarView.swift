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


    open var onSearch: ((_ query: String?) -> Void)?
//    open var menuButtonAction: (() -> Void)?

    open var searchField: NTTextField = {
        let textField = NTTextField()
        textField.placeholder = "Search"
        textField.backgroundColor = .clear
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        return textField
    }()

//    open var searchButton: NTButton = {
//        let button = NTButton()
//        button.setImage(Icon.icon("Search")?.scale(to: 30), for: .normal)
//        button.trackTouchLocation = false
//        button.layer.cornerRadius = 5
//        return button
//    }()
//
//    open var menuButton: NTButton = {
//        let button = NTButton()
//        button.setImage(Icon.icon("Menu_ffffff_100")?.scale(to: 30), for: .normal)
//        button.trackTouchLocation = false
//        button.layer.cornerRadius = 5
//        return button
//    }()

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setDefaultShadow()
        layer.cornerRadius = 5

//        addSubview(menuButton)
        addSubview(searchField)
//        addSubview(searchButton)

//        menuButton.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 44, heightConstant: 0)
        
        searchField.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)

//        searchButton.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 44, heightConstant: 0)

//        menuButton.addTarget(self, action: #selector(menuButtonWasTapped(_:)), for: .touchUpInside)
//        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
    }

    public convenience init(onSearch function: ((_ query: String?) -> Void)? = nil) {
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
        endSearhEditing()
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        Log.write(.status, "SearchBar text cleared")
        return true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return true
    }

    // MARK: - Search

    open func search() {
        Log.write(.status, "SearchBar search executed")
        endSearhEditing()
        onSearch?(searchField.text)
    }
    
    open func endSearhEditing() {
        searchField.resignFirstResponder()
    }

    // MARK: - Menu

    open func menuButtonWasTapped(_ sender: NTButton) {
        endSearhEditing()
//        menuButtonAction?()
    }

    open func setMenuButton(hidden: Bool, animated: Bool) {

    }
}
