//
//  StandardViewControllers.swift
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

import NTComponents

class StandardViewControllers: NTTableViewController {
    
    var rootControllers: [UIViewController] = {
        var vcs = [UIViewController]()
        for index in 0...4 {
            let vc = NTViewController()
            vc.title = "Item \(index + 1)"
            vc.tabBarItem.image = Icon.NTLogo
            vc.view.backgroundColor = Color.Default.Background.ViewController.darker(by: CGFloat(index * 2))
            vcs.append(vc)
        }
        return vcs
    }()
    
    var controllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controllers = [
            NTTabBarController(viewControllers: rootControllers),
            NTScrollableTabBarController(viewControllers: rootControllers),
            FeedViewController()
        ]
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Container Controllers"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controllers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NTTableViewCell()
        cell.textLabel?.text = String(describing: type(of: controllers[indexPath.row]))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navVC = NTNavigationController(rootViewController: controllers[indexPath.row].addDismissalBarButtonItem())
        present(navVC, animated: true, completion: nil)
    }
    
}
