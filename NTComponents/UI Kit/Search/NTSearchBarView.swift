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

public protocol NTSearchBarViewDelegate {
    func searchBar(_ searchBar: NTTextField, didUpdateSearchFor query: String) -> Bool
    func searchBarDidBeginEditing(_ searchBar: NTTextField)
    func searchBarDidEndEditing(_ searchBar: NTTextField)
}

open class NTSearchBarView: NTView, UITextFieldDelegate {


    public var delegate: NTSearchBarViewDelegate?
    
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


        searchField.delegate = self
        searchField.addTarget(self, action: #selector(search), for: UIControlEvents.editingChanged)
        addSubview(searchField)
        searchField.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 2, leftConstant: 8, bottomConstant: 2, rightConstant: 8, widthConstant: 0, heightConstant: 0)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        searchField.removeAllConstraints()
        searchField.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 2, leftConstant: 8, bottomConstant: 2, rightConstant: 8, widthConstant: 0, heightConstant: 0)
    }

    // MARK: - UITextFieldDelegate

    open func textFieldDidBeginEditing(_ textField: UITextField) {
        Log.write(.status, "SearchBar editing began")
        delegate?.searchBarDidBeginEditing(searchField)
    }

    open func textFieldDidEndEditing(_ textField: UITextField) {
        Log.write(.status, "SearchBar editing ended")
        endSearchEditing()
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        Log.write(.status, "SearchBar text cleared")
        return delegate?.searchBar(searchField, didUpdateSearchFor: searchField.text ?? String()) ?? true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        endSearchEditing()
        return true
    }
    
    
    
    // MARK: - Search

    @objc open func search() {
        Log.write(.status, "SearchBar search executed")
        let _ = delegate?.searchBar(searchField, didUpdateSearchFor: searchField.text ?? String())
    }
    
    open func endSearchEditing() {
        delegate?.searchBarDidEndEditing(searchField)
        searchField.resignFirstResponder()
    }

    // MARK: - Menu

    open func menuButtonWasTapped(_ sender: NTButton) {
        endSearchEditing()
//        menuButtonAction?()
    }

//    open func setMenuButton(hidden: Bool, animated: Bool) {
//
//    }
}
