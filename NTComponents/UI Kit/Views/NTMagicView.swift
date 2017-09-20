//
//  NTMagicView.swift
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
//  Created by Nathan Tannar on 7/1/17.
//

import UIKit

@objc public protocol NTMagicViewDelegate: NSObjectProtocol {
    @objc optional func magicView(_ magicView: NTMagicView, didChangeState state: UIGestureRecognizerState)
    @objc optional func magicView(_ magicView: NTMagicView, didEnterReferenceFrame frame: CGRect)
    @objc optional func magicView(_ magicView: NTMagicView, didChangePositionReferenceFrame frame: CGRect)
    @objc optional func magicView(_ magicView: NTMagicView, didExitReferenceFrame frame: CGRect)
    @objc optional func magicView(_ magicView: NTMagicView, shouldSnapToFrame frame: CGRect) -> Bool
}

open class NTMagicView: NTView {
    
    open weak var delegate: NTMagicViewDelegate?
    open var panGestureRecognizer: UIPanGestureRecognizer?
    
    
    /// Determines if the view should move back to its initial center point if it never reaches a reference frame
    open var shouldMoveBackIfNoReferenceFound = false

    fileprivate var currentReferenceFrame: CGRect?
    fileprivate var referenceFrames: [CGRect] = [CGRect]()
    fileprivate var initialCenter: CGPoint?
    fileprivate var dragStartPositionRelativeToCenter: CGPoint?
    
    open override var center: CGPoint {
        didSet {
            for frame in referenceFrames {
                if frame.contains(center) {
                    
                    // View is inside reference frame
                    delegate?.magicView?(self, didChangePositionReferenceFrame: frame)
                    
                    if frame != currentReferenceFrame {
                        // View did enter reference frame
                        currentReferenceFrame = frame
                        delegate?.magicView?(self, didEnterReferenceFrame: frame)
                    }
                    
                } else if frame == currentReferenceFrame {
                    
                    // View did exit reference frame
                    delegate?.magicView?(self, didExitReferenceFrame: frame)
                    currentReferenceFrame = nil
                }
            }
        }
    }
    
    // MARK: - Initialization
    
    /// Initializes the view with a width and height of 100
    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    /// Sets up the views default properties
    open override func setup() {
        super.setup()
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGestureRecognizer!)
    }
    
    open func registerReferences(toViews views: [UIView]) {
        registerReferences(toFrames: views.map{ return $0.frame })
    }
    
    open func registerReferences(toFrames frames: [CGRect]) {
        referenceFrames.append(contentsOf: frames)
    }
    
    open func unregisterReferences(toViews views: [UIView]) {
        unregisterReferences(toFrames: views.map{ return $0.frame })
    }
    
    open func unregisterReferences(toFrames frames: [CGRect]) {
        for frame in referenceFrames {
            for frameToUnregister in frames {
                if frame == frameToUnregister {
                    if let index = referenceFrames.index(of: frame) {
                        referenceFrames.remove(at: index)
                    }
                }
            }
        }
    }
    
    open func unregisterAllReferences() {
        referenceFrames.removeAll()
    }
    
    /// Called when a pan gesture is sent to the view
    ///
    /// - Parameter gesture: UIPanGestureRecognizer
    @objc open func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        guard let superview = self.superview else {
            /// ERROR, NTMagicView must have a superview
            return
        }
        
        delegate?.magicView?(self, didChangeState: gesture.state)
        
        if gesture.state == UIGestureRecognizerState.began {
            let locationInView = gesture.location(in: superview)
            dragStartPositionRelativeToCenter = CGPoint(x: locationInView.x - center.x, y: locationInView.y - center.y)
            initialCenter = center
            return
        }
        
        if gesture.state == UIGestureRecognizerState.ended {
            
            var willSnap = false
            if let referenceFrame = currentReferenceFrame, let delegate = delegate {
                if delegate.magicView?(self, shouldSnapToFrame: referenceFrame) == true {
                    willSnap = true
                    UIView.animate(withDuration: 0.1, animations: {
                        self.center = CGPoint(x: referenceFrame.midX, y: referenceFrame.midY)
                    })
                }
            }
            if !willSnap, shouldMoveBackIfNoReferenceFound, let initialCenter = initialCenter {
                UIView.animate(withDuration: 0.3, animations: {
                    self.center = initialCenter
                }) { _ in
                    self.dragStartPositionRelativeToCenter = nil
                    self.initialCenter = nil
                }
            } else {
                dragStartPositionRelativeToCenter = nil
                initialCenter = nil
            }
            
            return
        }
        
        let locationInView = gesture.location(in: superview)
        
        
        UIView.animate(withDuration: 0.1, animations: { 
            self.center = CGPoint(x: locationInView.x - self.dragStartPositionRelativeToCenter!.x,
                                  y: locationInView.y - self.dragStartPositionRelativeToCenter!.y)
        }) { _ in
            
        }
    }
}
