//
//  NTInfoLinkCell.swift
//  NTComponents
//
//  Created by Nathan Tannar on 12/31/16.
//  Copyright © 2016 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTInfoLinkCell: NTTableViewCell {
    
    
    @IBOutlet public weak var leftLinkButton: UIButton!
    @IBOutlet public weak var leftSubtitleLabel: UILabel!
    @IBOutlet public weak var rightLinkButton: UIButton!
    @IBOutlet public weak var rightSubtitleLabel: UILabel!
    @IBOutlet public weak var dividerLabel: UILabel!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public var leftTitle: String? {
        set {
            self.leftLinkButton.setTitle(newValue, for: .normal)
        }
        get {
            return self.leftLinkButton.title(for: .normal)
        }
    }
    
    public var leftSubtitle: String? {
        set {
            self.leftSubtitleLabel.text = newValue
        }
        get {
            return self.leftSubtitleLabel.text
        }
    }
    
    
    public var rightTitle: String? {
        set {
            self.rightLinkButton.setTitle(newValue, for: .normal)
        }
        get {
            return self.rightLinkButton.title(for: .normal)
        }
    }
    
    public var rightSubtitle: String? {
        set {
            self.rightSubtitleLabel.text = newValue
        }
        get {
            return self.rightSubtitleLabel.text
        }
    }
    
    public class func initFromNib() -> NTInfoLinkCell {
        return UINib(nibName: "NTInfoLinkCell", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: nil, options: nil)[0] as! NTInfoLinkCell
    }
}
