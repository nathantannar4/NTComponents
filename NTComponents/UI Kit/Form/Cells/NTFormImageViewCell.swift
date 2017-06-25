//
//  NTFormImageViewCell.swift
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

open class NTFormImageViewCell: NTFormCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    open override var datasourceItem: Any? {
        get {
            return self
        }
        set {
            guard let cell = newValue as? NTFormImageViewCell else { return }
            self.imageView.removeFromSuperview()
            self.actionButton.removeFromSuperview()
            self.imageView = cell.imageView
            self.actionButton = cell.actionButton
            self.imagePickerCompletion = cell.imagePickerCompletion
            self.setupViews()
            self.separatorLineView.isHidden = cell.separatorLineView.isHidden
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
        return imageView
    }()
    
    open var actionButton: NTButton = {
        let button = NTButton()
        button.isHidden = true
        button.alpha = 0.7
        button.title = "Edit"
        button.trackTouchLocation = false
        button.layer.cornerRadius = 5
        button.backgroundColor = .white
        button.titleColor = .black
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
        
        separatorLineView.isHidden = true
        
        addSubview(imageView)
        addSubview(actionButton)
        
        imageView.fillSuperview()
        actionButton.anchor(nil, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 8, rightConstant: 16, widthConstant: 60, heightConstant: 30)
    }
    
    open override class var cellSize: CGSize {
        get {
            return CGSize(width: UIScreen.main.bounds.width, height: 200)
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
