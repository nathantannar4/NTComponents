//
//  FormViewController.swift
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
//  Created by Nathan Tannar on 6/6/17.
//

import NTComponents

class FormViewController: NTFormViewController, NTNavigationViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (parent as? NTNavigationViewController)?.delegate = self
        collectionView?.contentInset.bottom = 30
        
        let cellA = NTFormInputCell()
        cellA.title = "Input"
        cellA.onTextFieldUpdate { (textField) in
            print(textField.text ?? "")
        }
        
        let cellB = NTFormLongInputCell()
        cellB.title = "Long Input"
        cellB.onTextViewUpdate { (textView) in
            print(textView.text ?? "")
        }
        
        let cellC = NTFormControlCell<NTSwitch>()
        cellC.title = "Switch"
        cellC.onControlChanged { (isOn) in
            print(isOn)
        }
        
        let cellD = NTFormControlCell<NTCheckbox>()
        cellD.title = "Checkbox"
        cellD.onControlChanged { (isChecked) in
            print(isChecked)
        }
        
        let cellE = NTFormControlCell<NTSegmentedControl>()
        cellE.title = "Segmented Control"
        cellE.control.setSegmentItems(["One", "Two", "Three"])
        cellE.onControlChanged { (index) in
            print(index)
        }
        
        let cellF = NTFormImageViewCell()
        cellF.imageView.image = #imageLiteral(resourceName: "Background")
        cellF.actionButton.isHidden = false
        cellF.onImageViewTap { (imageView) in
            print("Tapped ImageView")
        }
        cellF.onTouchUpInsideActionButton { (button) in
            cellF.presentImagePicker(completion: { (image) in
                print(image)
            })
        }
        
        let cellG = NTFormProfileCell()
        cellG.image = #imageLiteral(resourceName: "Nathan")
        cellG.name = "Nathan Tannar"
        cellG.onTouchUpInsideActionButton { (button) in
            cellG.presentImagePicker(completion: { (image) in
                print(image)
            })
        }
        cellG.onTextFieldUpdate { (textField) in
            print(textField.text ?? "")
        }
        
        let cellH = NTFormTagInputCell()
        cellH.title = "Tag Input"
        cellH.onTagAdded { (tagView, tagListView) in
            print("Added \(tagView.titleLabel?.text ?? "")")
        }
        cellH.onTagDeleted { (tagView, tagListView) in
            tagListView.removeTagView(tagView)
        }
        
        
        let sectionA = NTFormSection(fromRows: [cellF, cellG, NTFormImageSelectorCell()])
        
        let sectionB = NTFormSection(fromRows: [cellA, cellB, NTFormAnimatedInputCell()], withHeaderTitle: "Header", withFooterTitle: nil)
        
        let sectionC = NTFormSection(fromRows: [cellC, cellD, cellE], withHeaderTitle: "Header", withFooterTitle: nil)
        
        let sectionD = NTFormSection(fromRows: [cellH], withHeaderTitle: "Header", withFooterTitle: "Footer")
        
        appendSections([sectionA, sectionB, sectionC, sectionD])
        reloadForm()
    }
    
//    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        if section == 3 {
//            return 10
//        }
//        return .leastNonzeroMagnitude
//    }
    
    func nextViewController(_ navigationViewController: NTNavigationViewController) -> UIViewController? {
        return nil
    }
    
    func navigationViewController(_ navigationViewController: NTNavigationViewController, shouldMoveTo viewController: UIViewController) -> Bool {
        return true
    }
}
