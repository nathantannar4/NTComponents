//
//  NTFormImageSelectorCell.swift
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
//  Created by Nathan Tannar on 6/8/17.
//


open class NTFormImageSelectorCell: NTFormCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    open override var datasourceItem: Any? {
        get {
            return self
        }
        set {
            guard let cell = newValue as? NTFormImageSelectorCell else { return }
            self.imageView.removeFromSuperview()
            self.actionButton.removeFromSuperview()
            self.imageView = cell.imageView
            self.actionButton = cell.actionButton
            self.imagePickerCompletion = cell.imagePickerCompletion
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
    
    open var imageView: NTImageView = {
        let imageView = NTImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Color.Gray.P100
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor = Color.Gray.P100.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    open var actionButton: NTButton = {
        let button = NTButton()
        button.ripplePercent = 0.15
        button.rippleOverBounds = true
        button.title = "Select Image from Library"
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .right
        button.tintColor = Color.Gray.P500
        button.image = Icon.Arrow.Forward?.scale(to: 20)
        button.setPreferredFontStyle(to: .callout)
        button.pullImageToRight()
        return button
    }()
    
    open var imagePickerCompletion: ((UIImage) -> Void)?
    
    // MARK: - Handlers
    
    @discardableResult
    open func onImageViewTap(_ handler: @escaping ((_ imageView: NTImageView) -> Void)) -> Self {
        imageView.onTap = handler
        return self
    }
    
    @discardableResult
    open func onTouchUpInsideActionButton(_ handler: @escaping ((NTButton) -> Void)) -> Self {
        actionButton.onTouchUpInside = handler
        return self
    }
    
    open override func setupViews() {
        super.setupViews()
        
        separatorLineView.isHidden = false
        
        addSubview(imageView)
        addSubview(actionButton)
        
        imageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 4, leftConstant: 16, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        imageView.anchorAspectRatio()
        actionButton.anchor(topAnchor, left: imageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)
    }
    
    open override class var cellSize: CGSize {
        get {
            return CGSize(width: UIScreen.main.bounds.width, height: 60)
        }
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
