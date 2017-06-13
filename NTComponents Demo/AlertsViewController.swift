//
//  AlertsViewController.swift
//  NTComponents
//
//  Created by Nathan Tannar on 4/16/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import NTComponents

class AlertsViewController: NTTableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Alerts"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

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
            return "NTActivityIndicators"
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
            return 4
        case 2:
            return 1
        case 3:
            return 4
        case 4:
            return 4
        case 5:
            return 2
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
            if indexPath.row == 0 {
                cell.textLabel?.text = "Line Progress"
            } else {
                cell.textLabel?.text = "Activity"
            }
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
            switch indexPath.row {
            case 0:
                showAlert(type: .isInfo)
            case 1:
                showAlert(type: .isSuccess)
            case 2:
                showAlert(type: .isWarning)
            case 3:
                showAlert(type: .isDanger)
            default:
                break
            }
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
            }
        case 5:
            if indexPath.row == 0 {
                showLineLoader()
            } else {
                showWheelLoader()
            }
        default:
            break
        }
    }
    
    func showActionSheet(withImages: Bool) {
        
        var actions = [NTActionSheetItem]()
        actions.append(NTActionSheetItem(title: "Google", icon: withImages ? Icon.google : nil, action: {
            NTToast(text: "Google").show(duration: 3.0)
        }))
        actions.append(NTActionSheetItem(title: "Facebook", icon: withImages ? Icon.facebook : nil, iconTint: Color.FacebookBlue, action: {
            NTToast(text: "Facebook").show(duration: 3.0)
        }))
        actions.append(NTActionSheetItem(title: "Twitter", icon: withImages ? Icon.twitter : nil, iconTint: Color.TwitterBlue, action: {
            NTToast(text: "Twitter").show(duration: 3.0)
        }))
        let actionSheet = NTActionSheetViewController(title: "Title", subtitle: "Subtitle", actions: actions)
        actionSheet.addDismissAction(withText: "Dismiss", icon: withImages ? Icon.Delete : nil)
        actionSheet.show()
    }
    
    func showAlert(type: NTAlertType) {
        
        let alert = NTAlertViewController(title: "Are you sure?", subtitle: "This action cannot be undone", type: type)
        alert.onCancel = {
            self.showToast(withText: "Canceled action")
        }
        alert.onConfirm = {
            self.showToast(withText: "Confirmed action")
        }
        alert.show()
    }
    
    func showChime(type: NTAlertType) {
        let chime = NTChime(type: type, title: "Title", subtitle: "Subtile/Description", icon: Icon.NTLogo, detailViewController: AlertDetailViewController())
        chime.show()
    }
    
    func showPing(type: NTAlertType) {
        let ping = NTPing(type: type, title: "Description")
        ping.show(duration: 2)
    }
    
    func showToast(withText text: String) {
        NTToast(text: text, actionTitle: "Undo", target: self, selector: #selector(toastAction)).show(duration: 3)
    }
    
    func toastAction() {
        NTPing(title: "Toast Action", color: Color.Gray.P800).show()
    }
    
    func showLineLoader() {
        let loader = NTProgressLineIndicator()
        view.addSubview(loader)
        loader.autoComplete(withDuration: 2)
    }
    
    func showWheelLoader() {
        let loader = NTProgressHUD()
        loader.show(withTitle: "Loading...", duration: 3)
    }
}
