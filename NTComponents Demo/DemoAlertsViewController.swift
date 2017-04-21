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
        button.backgroundColor = Color.Defaults.buttonTint
        button.title = "Action Sheet"
        button.titleColor = .white
        button.layer.cornerRadius = 5
        return button
    }()
    
    let alertButton: NTButton = {
        let button = NTButton()
        button.backgroundColor = Color.Defaults.buttonTint
        button.title = "Alert"
        button.titleColor = .white
        button.layer.cornerRadius = 5
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(actionSheetButton)
        view.addSubview(alertButton)
        
        actionSheetButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 100, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 30)
        alertButton.anchor(actionSheetButton.bottomAnchor, left: actionSheetButton.leftAnchor, bottom: nil, right: actionSheetButton.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        
        actionSheetButton.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        alertButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
    }
    
    func showActionSheet() {
        
        var actions = [NTActionSheetAction]()
        actions.append(NTActionSheetAction(title: "Google", icon: Icon.google, action: {
            Toast(text: "Google").show(self.view, duration: 3.0)
        }))
        actions.append(NTActionSheetAction(title: "Facebook", icon: Icon.facebook, action: {
            Toast(text: "Facebook").show(self.view, duration: 3.0)
        }))
        actions.append(NTActionSheetAction(title: "Twitter", icon: Icon.twitter, action: {
            Toast(text: "Twitter").show(self.view, duration: 3.0)
        }))
        let actionSheet = NTActionSheetController(actions: actions)
        actionSheet.addDismissAction()
        present(actionSheet, animated: false, completion: nil)
        
    }
    
    func showAlert() {
        
        let alert = NTAlertViewController(title: "Are you sure?", subtitle: "This action cannot be undone")
        alert.onCancel = {
            Toast(text: "Canceled").show(duration: 5.0)
        }
        alert.onConfirm = {
            Toast(text: "Confirmed").show(duration: 5.0)
        }
        present(alert, animated: true, completion: nil)
    }
}
