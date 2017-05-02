//
//  DemoAlertsViewController.swift
//  NTComponents
//
//  Created by Nathan Tannar on 4/16/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import NTComponents

class DemoAlertsViewController: NTViewController {
    
    
    let actionSheetButton: NTButton = {
        let button = NTButton()
        button.title = "Action Sheet"
        button.layer.cornerRadius = 5
        return button
    }()
    
    let alertButton: NTButton = {
        let button = NTButton()
        button.title = "Alert"
        button.layer.cornerRadius = 5
        return button
    }()
    
    let chimeButton: NTButton = {
        let button = NTButton()
        button.title = "Chime"
        button.titleColor = .white
        button.layer.cornerRadius = 5
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Alerts"
        
        view.addSubview(actionSheetButton)
        view.addSubview(alertButton)
        view.addSubview(chimeButton)
        
        actionSheetButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 100, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 30)
        alertButton.anchor(actionSheetButton.bottomAnchor, left: actionSheetButton.leftAnchor, bottom: nil, right: actionSheetButton.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        chimeButton.anchor(alertButton.bottomAnchor, left: alertButton.leftAnchor, bottom: nil, right: alertButton.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        actionSheetButton.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        alertButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        chimeButton.addTarget(self, action: #selector(showChime), for: .touchUpInside)
        
        
        let loader = NTActivityIndicator()
        view.addSubview(loader)
        loader.autoComplete(withDuration: 2)
    }
    
    
    func showActionSheet() {
        
        var actions = [NTActionSheetAction]()
        actions.append(NTActionSheetAction(title: "Google", icon: Icon.google, action: {
            NTToast(text: "Google").show(duration: 3.0)
        }))
        actions.append(NTActionSheetAction(title: "Facebook", icon: Icon.facebook, action: {
            NTToast(text: "Facebook").show(duration: 3.0)
        }))
        actions.append(NTActionSheetAction(title: "Twitter", icon: Icon.twitter, action: {
            NTToast(text: "Twitter").show(duration: 3.0)
        }))
        let actionSheet = NTActionSheetController(actions: actions)
        actionSheet.addDismissAction()
        present(actionSheet, animated: false, completion: nil)
        
    }
    
    func showAlert() {
        
        let alert = NTAlertViewController(title: "Are you sure?", subtitle: "This action cannot be undone")
        alert.onCancel = {
            NTToast(text: "Canceled").show(duration: 5.0)
        }
        alert.onConfirm = {
            NTToast(text: "Confirmed").show(duration: 5.0)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func showChime() {
        //let chime = NTChime(NTAlertType.isDanger, title: "Danger Alert", subtitle: "Reason", icon: nil)
//        let chime = NTChime(title: "Test", height: 20, color: Color.Default.Tint.NavigationBar, onTap: nil)
//        chime.show()
        NTPing(type: .isSuccess, title: "Login Successful").show()
    }
}
