//
//  NTOnboardingViewController.swift
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
//  Created by Nathan Tannar on 5/15/17.
//

public struct NTOnboardingDataSet {
    
    public var image: UIImage?
    public var title: String?
    public var subtitle: String?
    public var body: String?
    
    public init(image: UIImage?, title: String?, subtitle: String?, body: String?) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.body = body
    }
}

open class NTOnboardingDatasource {

    open var items: [NTOnboardingDataSet]
    
    public init(withValues items: [NTOnboardingDataSet]) {
        self.items = items
    }
}

open class NTOnboardingViewController: NTPageViewController {
    
    open var datasource: NTOnboardingDatasource?
    
    /**
     The view controller presented after the slide show has completed. If left nil NTOnboardingViewController will attempt to dismiss itself
     */
    open var completionViewController: UIViewController?
    
    open var nextButton: NTButton = {
        let button = NTButton()
        button.trackTouchLocation = false
        button.ripplePercent = 0
        button.image = Icon.Arrow.Forward
        button.tintColor = .white
        button.addTarget(self, action: #selector(slideToNextViewController), for: .touchUpInside)
        return button
    }()
    
    open var prevButton: NTButton = {
        let button = NTButton()
        button.trackTouchLocation = false
        button.image = Icon.Arrow.Backward
        button.tintColor = Color.Gray.P700
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(slideToPreviousViewController), for: .touchUpInside)
        return button
    }()
    
    open var buttonContainer: UIView = {
        let view = UIView()
        view.setDefaultShadow()
        view.layer.shadowOffset = CGSize(width: 0, height: -Color.Default.Shadow.Offset.height)
        return view
    }()
    
    override var currentIndex: Int {
        didSet {
            if currentIndex == 0 {
                nextButton.ripplePercent = 0
                nextButton.title = nil
                nextButton.image = Icon.Arrow.Forward
            } else if currentIndex < viewControllers.count - 1 {
                nextButton.title = nil
                nextButton.image = Icon.Arrow.Forward
                DispatchQueue.executeAfter(0.3, closure: {
                    self.nextButton.ripplePercent = 0.8
                })
            } else {
                nextButton.title = "Get Started"
                nextButton.image = nil
            }
        }
    }

    // MARK: - Initialization
 
    public convenience init(dataSource: NTOnboardingDatasource?) {
        self.init()
 
        guard let items = dataSource?.items else {
            self.viewControllers = [NTViewController()]
            return
        }
        createContentViewControllers(withItems: items)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Standard Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController.view.removeAllConstraints()
        pageViewController.view.backgroundColor = Color.Default.Background.ViewController
        statusBarHidden = true
        
        view.addSubview(buttonContainer)
        buttonContainer.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        pageViewController.view.anchor(view.topAnchor, left: view.leftAnchor, bottom: buttonContainer.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        buttonContainer.addSubview(nextButton)
        buttonContainer.addSubview(prevButton)
        
        
        prevButton.anchor(buttonContainer.topAnchor, left: buttonContainer.leftAnchor, bottom: buttonContainer.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        nextButton.anchor(buttonContainer.topAnchor, left: prevButton.rightAnchor, bottom: buttonContainer.bottomAnchor, right: buttonContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        prevButton.widthAnchor.constraint(equalToConstant: 0).isActive = true
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        statusBarHidden = true
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        statusBarHidden = false
    }
    
    // MARK: - NTOnboarding Methods
    
    @objc open override func slideToNextViewController() {
        if currentIndex == viewControllers.count - 1 {
            
            statusBarHidden = false
            guard let completion = completionViewController else {
                dismissViewController(to: .left, completion: nil)
                return
            }
            presentViewController(completion, from: .right, completion: nil)
        } else {
            super.slideToNextViewController()
        }
    }
    
    open func createContentViewControllers(withItems items: [NTOnboardingDataSet]) {
        for item in items {
            let imageView = NTImageView(image: item.image)
            imageView.contentMode = .scaleAspectFit
            let titleLabel = NTLabel(style: .headline)
            titleLabel.text = item.title
            titleLabel.textAlignment = .center
            titleLabel.font = Font.Default.Title.withSize(26)
            let subtitleLabel = NTLabel(style: .subhead)
            subtitleLabel.text = item.subtitle
            subtitleLabel.textAlignment = .center
            let bodyLabel = NTLabel(style: .body)
            bodyLabel.text = item.body
            bodyLabel.textAlignment = .center
            let viewController = UIViewController()
            viewController.view.addSubview(imageView)
            viewController.view.addSubview(titleLabel)
            viewController.view.addSubview(subtitleLabel)
            viewController.view.addSubview(bodyLabel)
            
            imageView.anchor(viewController.view.topAnchor, left: viewController.view.leftAnchor, bottom: nil, right: viewController.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: UIScreen.main.bounds.height * 2 / 5)
            titleLabel.anchor(imageView.bottomAnchor, left: viewController.view.leftAnchor, bottom: nil, right: viewController.view.rightAnchor, topConstant: 12, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            subtitleLabel.anchor(titleLabel.bottomAnchor, left: viewController.view.leftAnchor, bottom: nil, right: viewController.view.rightAnchor, topConstant: 6, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            bodyLabel.anchor(subtitleLabel.bottomAnchor, left: viewController.view.leftAnchor, bottom: nil, right: viewController.view.rightAnchor, topConstant: 12, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            
            self.viewControllers.append(viewController)
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x - scrollView.frame.width
        let maxWidth = buttonContainer.frame.width / 2
        var width = (offset / scrollView.frame.width) * maxWidth
        
        if width == 0 { return }
        
        prevButton.removeAllConstraints()
        prevButton.anchor(buttonContainer.topAnchor, left: buttonContainer.leftAnchor, bottom: buttonContainer.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        nextButton.removeAllConstraints()
        nextButton.anchor(buttonContainer.topAnchor, left: nil, bottom: buttonContainer.bottomAnchor, right: buttonContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        if width < 0 {
            
            width = width + maxWidth
            
            if currentIndex == 1 {
                
                prevButton.widthAnchor.constraint(equalToConstant: width).isActive = true
                nextButton.widthAnchor.constraint(equalToConstant: buttonContainer.frame.width - width).isActive = true
                
            } else if currentIndex > 1 {
                
                prevButton.widthAnchor.constraint(equalToConstant: maxWidth).isActive = true
                nextButton.widthAnchor.constraint(equalToConstant: maxWidth).isActive = true
                
            } else {
                
                prevButton.widthAnchor.constraint(equalToConstant: 0).isActive = true
                nextButton.widthAnchor.constraint(equalToConstant: maxWidth * 2).isActive = true
                
            }
        } else {
            if currentIndex == 0 {
            
                prevButton.widthAnchor.constraint(equalToConstant: width).isActive = true
                nextButton.widthAnchor.constraint(equalToConstant: buttonContainer.frame.width - width).isActive = true
                
            } else {
                
                prevButton.widthAnchor.constraint(equalToConstant: maxWidth).isActive = true
                nextButton.widthAnchor.constraint(equalToConstant: maxWidth).isActive = true
                
            }
        }
    
    }
}
