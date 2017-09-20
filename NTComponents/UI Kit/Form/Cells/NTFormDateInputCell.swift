//
//  NTFormDateInputCell.swift
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
//  Created by Nathan Tannar on 6/25/17.
//

open class NTFormDateInputCell: NTFormCell {
    
    open override var datasourceItem: Any? {
        get {
            return self
        }
        set {
            guard let cell = newValue as? NTFormDateInputCell else { return }
            self.dateField.removeFromSuperview()
            self.label.removeFromSuperview()
            self.label = cell.label
            self.dateField = cell.dateField
            self.setupViews()
            self.datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
            self.dateField.addTarget(self, action: #selector(presentDatePicker(sender:)), for: .editingDidBegin)
        }
    }
    
    open var dateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.timeZone = Calendar.current.timeZone
        format.locale = Calendar.current.locale
        format.dateFormat = "MMMM dd yyyy hh:MM"
        format.dateStyle = .medium
        format.timeStyle = .medium
        return format
    }()
    
    open var title: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    
    open var date: Date? {
        didSet {
            guard let date = date else {
                return
            }
            dateField.text = dateFormatter.string(from: date)
        }
    }
    
    open var label: NTLabel = {
        let label = NTLabel(style: .callout)
        label.text = "Label"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    open var dateField: NTTextField = {
        let textField = NTTextField()
        return textField
    }()
    
    open var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.timeZone = Calendar.current.timeZone
        datePicker.backgroundColor = Color.Gray.P100
        return datePicker
    }()
    
    // MARK: - Handlers
    
    open var onDateChanged: ((Date) -> Void)?
    
    @discardableResult
    open func onDateChanged(_ handler: @escaping ((Date) -> Void)) -> Self {
        onDateChanged = handler
        return self
    }
    
    
    // MARK: - Setup
    
    open override func setupViews() {
        super.setupViews()
        
        addSubview(dateField)
        addSubview(label)
        
        label.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 2, leftConstant: 16, bottomConstant: 2, rightConstant: 0, widthConstant: 80, heightConstant: 0)
        dateField.anchor(topAnchor, left: label.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 2, leftConstant: 2, bottomConstant: 2, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissDatePicker))
        dateField.addToolBar(withItems: [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton])
    }
    
    @objc open func presentDatePicker(sender: NTTextField) {
        sender.inputView = datePicker
    }
    
    @objc open func dismissDatePicker() {
        dateField.resignFirstResponder()
    }
    
    @objc open func datePickerValueChanged(_ sender: UIDatePicker) {
        date = sender.date
        onDateChanged?(sender.date)
    }
}

