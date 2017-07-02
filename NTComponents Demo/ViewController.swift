//
//  ViewController.swift
//  MagicView
//
//  Created by Nathan Tannar on 7/1/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit
import NTComponents

class ViewController: UIViewController, NTMagicViewDelegate {
    
    var magicView = NTMagicView(frame: CGRect(x: 16, y: 16, width: 100, height: 100))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let frames = [CGRect(x: 16, y: 16, width: 100, height: 100), CGRect(x: view.frame.width - 116, y: 16, width: 100, height: 100), CGRect(x: 16, y: view.frame.height - 116, width: 100, height: 100), CGRect(x: view.frame.width - 116, y: view.frame.height - 116, width: 100, height: 100)]
        
        for frame in frames {
            let referenceView = UIView()
            referenceView.frame = frame
            referenceView.layer.borderWidth = 2
            referenceView.layer.borderColor = UIColor.red.cgColor
            view.addSubview(referenceView)
            magicView.registerReferences(toViews: [referenceView])
        }
        
        magicView.backgroundColor = .blue
        magicView.delegate = self
        magicView.layer.cornerRadius = 50
        view.addSubview(magicView)
        magicView.shouldMoveBackIfNoReferenceFound = true
    }
    
    func magicView(_ magicView: NTMagicView, didChangePositionReferenceFrame frame: CGRect) {
        
    }
    
    func magicView(_ magicView: NTMagicView, didEnterReferenceFrame frame: CGRect) {
        print("Entered Reference")
    }
    
    func magicView(_ magicView: NTMagicView, shouldSnapToFrame frame: CGRect) -> Bool {
        return true
    }
    
    func magicView(_ magicView: NTMagicView, didChangeState state: UIGestureRecognizerState) {
        if state == .began {
            magicView.layer.shadowOffset = CGSize(width: 0, height: 20)
            magicView.layer.shadowOpacity = 0.3
            magicView.layer.shadowRadius = 6
        } else if state == .ended {
            magicView.layer.shadowOpacity = 0
        }
    }

    func magicView(_ magicView: NTMagicView, didExitReferenceFrame frame: CGRect) {
        print("Left Reference")
    }
    
}

