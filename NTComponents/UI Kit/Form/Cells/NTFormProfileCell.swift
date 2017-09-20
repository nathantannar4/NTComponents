//
//  NTFormProfileCell.swift
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
//  Created by Nathan Tannar on 6/7/17.
//

open class NTFormProfileCell: NTFormCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    open override var datasourceItem: Any? {
        get {
            return self
        }
        set {
            guard let cell = newValue as? NTFormProfileCell else { return }
            self.textField.removeFromSuperview()
            self.imageView.removeFromSuperview()
            self.actionButton.removeFromSuperview()
            self.textField = cell.textField
            self.imageView = cell.imageView
            self.imagePickerCompletion = cell.imagePickerCompletion
            self.actionButton = cell.actionButton
            self.setupViews()
        }
    }
    
    open var image: UIImage? {
        set {
            imageView.image = newValue
        }
        get {
            return imageView.image
        }
    }
    
    open var name: String? {
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
    
    open var imageView: NTImageView = {
        let imageView = NTImageView()
        imageView.backgroundColor = Color.Gray.P100
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = NTFormProfileCell.cellSize.height * 1.5 / 2
        imageView.layer.borderColor = Color.Gray.P100.cgColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    open var actionButton: NTButton = {
        let button = NTButton()
        button.alpha = 0.7
        button.title = "Edit"
        button.trackTouchLocation = false
        button.backgroundColor = .white
        button.titleColor = .black
        return button
    }()
    
    open var textField: NTTextField = {
        let textField = NTTextField(style: .body)
        textField.placeholder = "Name"
        textField.layer.cornerRadius = 5
        textField.backgroundColor = Color.Gray.P100
        textField.addLeftPadding(8)
        return textField
    }()
    
    open var imagePickerCompletion: ((UIImage) -> Void)?
    
    // MARK: - Handlers
    
    @discardableResult
    open func onImageViewTap(_ handler: @escaping ((_ imageView: NTImageView) -> Void)) -> Self {
        imageView.onTap = handler
        return self
    }
    
    @discardableResult
    open func onTextFieldUpdate(_ handler: @escaping ((NTTextField) -> Void)) -> Self {
        textField.onTextFieldUpdate = handler
        return self
    }
    
    @discardableResult
    open func onTouchUpInsideActionButton(_ handler: @escaping ((NTButton) -> Void)) -> Self {
        actionButton.onTouchUpInside = handler
        return self
    }
    
    open override func setupViews() {
        super.setupViews()
        
        clipsToBounds = false
        addSubview(imageView)
        imageView.addSubview(actionButton)
        addSubview(textField)
        
        imageView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 8, rightConstant: 0, widthConstant: NTFormProfileCell.cellSize.height * 1.5, heightConstant: NTFormProfileCell.cellSize.height * 1.5)
        actionButton.anchor(nil, left: imageView.leftAnchor, bottom: imageView.bottomAnchor, right: imageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        textField.anchor(topAnchor, left: imageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 6, leftConstant: 16, bottomConstant: 6, rightConstant: 16, widthConstant: 0, heightConstant: 0)
    
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        textField.addToolBar(withItems: [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton])
    }
    
    @objc open func dismissKeyboard() {
        textField.resignFirstResponder()
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    open func presentImagePicker(completion: @escaping ((UIImage) -> Void)) {
        let imagePicker = NTImagePickerController()
        imagePicker.delegate = self
        imagePickerCompletion = completion
        UIApplication.presentedController?.present(imagePicker, animated: true, completion: nil)
    }
    
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = newImage
            imagePickerCompletion?(newImage)
        } else {
            Log.write(.error, "Failed to create UIImage from selected photo")
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
