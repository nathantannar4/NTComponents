//
//  NTComponentsProtocols.swift
//  NTComponents
//
//  Created by Nathan Tannar on 12/28/16.
//  Copyright © 2016 Nathan Tannar. All rights reserved.
//

import UIKit

@objc public protocol NTTableViewDelegate: NSObjectProtocol {
    @objc optional func tableView(_ tableView: NTTableView, didSelectRowAt indexPath: IndexPath)
}

@objc public protocol NTTableViewDataSource: NSObjectProtocol {
    func tableView(_ tableView: NTTableView, cellForRowAt indexPath: IndexPath) -> NTTableViewCell
    func tableView(_ tableView: NTTableView, rowsInSection section: Int) -> Int
    func numberOfSections(in tableView: NTTableView) -> Int
    @objc optional func tableView(_ tableView: NTTableView, cellForHeaderInSection section: Int) -> NTHeaderCell?
    @objc optional func tableView(_ tableView: NTTableView, cellForFooterInSection section: Int) -> NTFooterCell?
    @objc optional func imageForStretchyView(in tableView: NTTableView) -> UIImage?
    @objc optional func tableView(_ tableView: NTTableView, heightForRowAt indexPath: IndexPath) -> CGFloat
}

public protocol NTNavigationContainerDelegate: NSObjectProtocol {
    func dismissOverlayTo(_ direction: NTPresentationDirection)
    func toggleLeftPanel()
    func toggleRightPanel()
    func replaceCenterViewWith(_ view: UIViewController)
}

