//
//  NTCarouselView.swift
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
//  Created by Nathan Tannar on 7/3/17.
//

open class NTCarouselView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public typealias CarouselItem = (image: UIImage, onTapAction: (()->Void)?)
    
    /// When not nil, the default will be used
    open var itemWidth: CGFloat? {
        didSet {
            collectionViewLayout.invalidateLayout()
        }
    }
    
    /// When not nil, the default will be used
    open var itemHeight: CGFloat? {
        didSet {
            collectionViewLayout.invalidateLayout()
        }
    }
    
    open var items: [CarouselItem] = [] {
        didSet {
            reloadData()
        }
    }
    
    open var isAutoScrollEnabled: Bool = false {
        didSet {
            if isAutoScrollEnabled {
                timer = Timer.scheduledTimer(timeInterval: autoScrollTimeInterval, target: self, selector: #selector(handleTimer(_:)), userInfo: nil, repeats: true)
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    open var isInfinite: Bool = false {
        didSet {
            reloadData()
            collectionViewLayout.invalidateLayout()
        }
    }
    
    open var autoScrollTimeInterval: TimeInterval = 3 {
        didSet {
            if isAutoScrollEnabled {
                timer = Timer.scheduledTimer(timeInterval: autoScrollTimeInterval, target: self, selector: #selector(handleTimer(_:)), userInfo: nil, repeats: true)
            }
        }
    }
    
    fileprivate var timer: Timer?
    fileprivate var currentIndex: Int = 0
    fileprivate var canAutoScroll: Bool = true
    fileprivate let cellId = "NTCarouselViewCell"
    
    // MARK: - Initialization
    
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = .leastNonzeroMagnitude
        layout.minimumLineSpacing = .leastNonzeroMagnitude
        self.init(frame: .zero, collectionViewLayout: layout)
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open func setup() {
        delegate = self
        dataSource = self
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        backgroundColor = Color.Default.Background.View
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(layoutItems), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let width = itemWidth ?? frame.width
        if items.count > 1 && isInfinite {
            currentIndex = 1
            if contentOffset.x == 0.0 {
                contentOffset = CGPoint(x: width, y: 0.0)
            }
        }
    }
    
    @objc open func layoutItems() {
        collectionViewLayout.invalidateLayout()
    }
  
    
    // MARK: - Timer
    
    @objc open func handleTimer(_ timer: Timer) {
        
        if !canAutoScroll {
            return
        }
        
        if isInfinite {
            var visibleRect = CGRect()
            visibleRect.origin = contentOffset
            visibleRect.size = bounds.size
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            currentIndex = indexPathForItem(at: visiblePoint)!.row + 1
            scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .left, animated: true)
        } else if (currentIndex + 1) >= items.count {
            currentIndex = 0
            scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .left, animated: true)
        } else {
            currentIndex += 1
            scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .left, animated: true)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if items.count <= 1 || !isInfinite {
            return items.count
        }
        return items.count + 2
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        let imageView: UIImageView
        
        // Load data in this arrangement [2] [0] [1] [2] [0] unless the array is less than or equal to 1 or !isInfinite
        if items.count <= 1  || !isInfinite {
            imageView = UIImageView(image: items[indexPath.row].image)
        } else if indexPath.row == 0 {
            // Last item in items array
            imageView = UIImageView(image: items[items.count - 1].image)
        } else if indexPath.row == items.count + 1 {
            // First item in items array
            imageView = UIImageView(image: items[0].image)
        } else {
            imageView = UIImageView(image: items[indexPath.row - 1].image)
        }
        imageView.contentMode = .scaleAspectFill
        cell.addSubview(imageView)
        imageView.fillSuperview()
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if items.count <= 1  || !isInfinite {
            items[indexPath.row].onTapAction?()
        } else if indexPath.row == 0 {
            // Last item in items array
            items[items.count - 1].onTapAction?()
        } else if indexPath.row == items.count + 1 {
            // First item in items array
            items[0].onTapAction?()
        } else {
            items[indexPath.row - 1].onTapAction?()
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = itemHeight ?? frame.height
        let width = itemWidth ?? frame.width
        return CGSize(width: width, height: height)
    }
    
    open func infinateLoop(_ scrollView: UIScrollView) {
        if !isInfinite {
            return
        }
        var index = Int((scrollView.contentOffset.x) / (scrollView.frame.width))
        if currentIndex == index && currentIndex != 0 {
            return
        }
        currentIndex = index
        if index <= 0 {
            index = items.count - 1
            scrollView.setContentOffset(CGPoint(x: (scrollView.frame.width + 60) * items.count.cgFloat, y: 0), animated: false)
        } else if index >= items.count + 1 {
            index = 0
            scrollView.setContentOffset(CGPoint(x: (scrollView.frame.width), y: 0), animated: false)
        } else {
            index -= 1
        }
        currentIndex = index
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        infinateLoop(scrollView)
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        infinateLoop(scrollView)
        canAutoScroll = false
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        canAutoScroll = true
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isInfinite {
            return
        }
        
        var visibleRect = CGRect()
        visibleRect.origin = contentOffset
        visibleRect.size = bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        currentIndex = indexPathForItem(at: visiblePoint)!.row
    }
}
