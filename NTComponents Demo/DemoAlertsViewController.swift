//
//  DemoAlertsViewController.swift
//  NTComponents
//
//  Created by Nathan Tannar on 4/16/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import NTComponents

class DemoAlertsViewController: NTTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Alerts"
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "NTActionSheetViewController"
        case 1:
            return "NTAlertViewController"
        case 2:
            return "NTToast"
        case 3:
            return "NTChime"
        case 4:
            return "NTPing"
        case 5:
            return "NTActivityIndicator"
        default:
            return nil
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 4
        case 4:
            return 4
        case 5:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NTTableViewCell", for: indexPath) as! NTTableViewCell
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                cell.textLabel?.text = "Present with images"
            } else {
                cell.textLabel?.text = "Present without images"
            }
        case 1:
            cell.textLabel?.text = "Present"
        case 2:
            cell.textLabel?.text = "Present"
        case 3:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Info"
            case 1:
                cell.textLabel?.text = "Success"
            case 2:
                cell.textLabel?.text = "Warning"
            case 3:
                cell.textLabel?.text = "Danger"
            default:
                break
            }
        case 4:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Info"
            case 1:
                cell.textLabel?.text = "Success"
            case 2:
                cell.textLabel?.text = "Warning"
            case 3:
                cell.textLabel?.text = "Danger"
            default:
                break
            }
        case 5:
            cell.textLabel?.text = "Present with auto completion"
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                showActionSheet(withImages: true)
            } else {
                showActionSheet(withImages: false)
            }
        case 1:
            showAlert()
        case 2:
            showToast(withText: "This is a toast!")
        case 3:
            switch indexPath.row {
            case 0:
                showChime(type: .isInfo)
            case 1:
                showChime(type: .isSuccess)
            case 2:
                showChime(type: .isWarning)
            case 3:
                showChime(type: .isDanger)
            default:
                break
            }
        case 4:
            switch indexPath.row {
            case 0:
                showPing(type: .isInfo)
            case 1:
                showPing(type: .isSuccess)
            case 2:
                showPing(type: .isWarning)
            case 3:
                showPing(type: .isDanger)
            default:
                break
            }        case 5:
            showLoader()
        default:
            break
        }
    }
    
    func showActionSheet(withImages: Bool) {
        
        var actions = [NTActionSheetItem]()
        actions.append(NTActionSheetItem(title: "Google", icon: withImages ? Icon.google : nil, action: {
            NTToast(text: "Google").show(duration: 3.0)
        }))
        actions.append(NTActionSheetItem(title: "Facebook", icon: withImages ? Icon.facebook : nil, action: {
            NTToast(text: "Facebook").show(duration: 3.0)
        }))
        actions.append(NTActionSheetItem(title: "Twitter", icon: withImages ? Icon.twitter : nil, action: {
            NTToast(text: "Twitter").show(duration: 3.0)
        }))
        let actionSheet = NTActionSheetViewController(actions: actions)
        actionSheet.addDismissAction(withText: "Dismiss", icon: withImages ? Icon.Delete : nil)
        present(actionSheet, animated: false, completion: nil)
        
    }
    
    func showAlert() {
        
        let alert = NTAlertViewController(title: "Are you sure?", subtitle: "This action cannot be undone")
        alert.onCancel = {
            self.showToast(withText: "Canceled action")
        }
        alert.onConfirm = {
            self.showToast(withText: "Confirmed action")
        }
        present(alert, animated: true, completion: nil)
    }
    
    func showChime(type: NTAlertType) {
        let chime = NTChime(type: type, title: "Title", subtitle: "Subtile/Description", icon: Icon.email) {
            self.showToast(withText: "Chime completition action")
        }
        chime.show()
    }
    
    func showPing(type: NTAlertType) {
        let ping = NTPing(type: type, title: "Description")
        ping.show(duration: 2)
    }
    
    func showToast(withText text: String) {
        NTToast(text: text).show(duration: 3.0)
    }
    
    func showLoader() {
        let loader = NTActivityIndicator()
        view.addSubview(loader)
        loader.autoComplete(withDuration: 2)
    }
}
