//
//  NTEmailRegisterViewController.swift
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
//  Created by Nathan Tannar on 5/19/17.
//


open class NTEmailRegisterViewController: NTEmailAuthViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.isHidden = true
        titleLabel.text = "Email Sign Up"
        signInButton.title = "Sign Up"
        cancelButton.image = Icon.Arrow.Backward
    }
    
    open override func cancelAuth() {
        dismissViewController(to: .right, completion: nil)
    }
    
    open override func submitAuth() {
        guard let email = emailTextField.text else {
            NTPing(type: .isDanger, title: "Invalid Email").show()
            return
        }
        guard let password = passwordTextField.text else {
            NTPing(type: .isDanger, title: "Password is too weak").show()
            return
        }
        if email.isValidEmail {
            emailTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            if password.characters.count >= 8 {
                delegate?.authorize(self, email: email, password: passwordTextField.text ?? String())
            } else {
                NTPing(type: .isDanger, title: "Password is too weak").show()
                NTToast(text: "Passwords must be at least 8 characters long.", height: 52).show()
            }
        } else {
            NTPing(type: .isDanger, title: "Invalid Email").show()
        }
    }
}
