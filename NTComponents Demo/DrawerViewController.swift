//
//  DrawerViewController.swift
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
//  Created by Nathan Tannar on 6/20/17.
//

import NTComponents

class DrawerViewController: NTFormViewController {
    
    var side: NTDrawerSide = .left
    
    var properties: NTDrawerViewProperties {
        get {
            if side == .left {
                return self.drawerController!.leftViewProperties
            } else {
                return self.drawerController!.rightViewProperties
            }
        }
        set {
            if side == .left {
                self.drawerController!.leftViewProperties = newValue
            } else {
                self.drawerController!.rightViewProperties = newValue
            }
        }
    }
    
    convenience init(side: NTDrawerSide) {
        self.init()
        self.side = side
    }
    
    public override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let widthCell = NTFormInputCell()
        widthCell.title = "Width"
        widthCell.text = String(describing: properties.width)
        widthCell.textField.keyboardType = .numberPad
        widthCell.onTextFieldUpdate { (textField) in
            if let number = Float(textField.text!) {
                self.properties.width = CGFloat(number)
            }
        }
        
        let visabilityCell = NTFormControlCell<NTSwitch>()
        visabilityCell.title = "Visible on Top"
        visabilityCell.control.setOn(on: properties.isVisibleOnTop, animated: true)
        visabilityCell.onControlChanged { (control) in
            self.properties.isVisibleOnTop = control.isOn
        }

        
        let durationCell = NTFormInputCell()
        durationCell.title = "Duration"
        durationCell.text = String(describing: properties.drawerAnimationDuration)
        durationCell.textField.keyboardType = .numberPad
        durationCell.onTextFieldUpdate { (textField) in
            if let number = Float(textField.text!) {
                self.properties.drawerAnimationDuration = TimeInterval(number)
            }
        }
        
        let delayCell = NTFormInputCell()
        delayCell.title = "Delay"
        delayCell.text = String(describing: properties.drawerAnimationDelay)
        delayCell.textField.keyboardType = .numberPad
        delayCell.onTextFieldUpdate { (textField) in
            if let number = Float(textField.text!) {
                self.properties.drawerAnimationDelay = TimeInterval(number)
            }
        }
        
        let springCell = NTFormInputCell()
        springCell.title = "Spring Velocity"
        springCell.text = String(describing: properties.drawerAnimationSpringVelocity)
        springCell.textField.keyboardType = .numberPad
        springCell.onTextFieldUpdate { (textField) in
            if let number = Float(textField.text!) {
                self.properties.drawerAnimationSpringVelocity = CGFloat(number)
            }
        }

        
        let dampCell = NTFormInputCell()
        dampCell.title = "Spring Damping"
        dampCell.text = String(describing: properties.drawerAnimationSpringDamping)
        dampCell.textField.keyboardType = .numberPad
        dampCell.onTextFieldUpdate { (textField) in
            if let number = Float(textField.text!) {
                self.properties.drawerAnimationSpringDamping = CGFloat(number)
            }
        }
        
        let sectionA = NTFormSection(fromRows: [visabilityCell, widthCell], withHeaderTitle: "Drawer view properties for \(side) side", withFooterTitle: nil)
        
        let sectionB = NTFormSection(fromRows: [durationCell, delayCell, springCell, dampCell], withHeaderTitle: "Drawer animation properties for \(side) side", withFooterTitle: nil)
        
        appendSections([sectionA, sectionB])
        reloadForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = datasource?.cellClass(indexPath)?.cellSize.height ?? 44
        return CGSize(width: properties.width, height: height)
    }
}
