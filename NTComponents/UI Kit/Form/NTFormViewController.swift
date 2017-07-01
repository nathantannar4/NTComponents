//
//  NTFormViewController.swift
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
//  Created by Nathan Tannar on 6/5/17.
//

open class NTFormViewController: NTCollectionViewController {
    
    override open var title: String? {
        get {
            return parent?.title ?? super.title
        }
        set {
            if parent != nil {
                parent?.title = newValue
            } else {
                super.title = newValue
            }
            
        }
    }
    
    open var headerHeight: CGFloat = 30
    open var footerHeight: CGFloat = 20
    
    fileprivate var sections = [NTFormSection]()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if sections[section].header != nil {
            return CGSize(width: collectionView.frame.width, height: headerHeight)
        }
        return .zero
    }
    
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if sections[section].footer != nil {
            return CGSize(width: collectionView.frame.width, height: footerHeight)
        }
        return .zero
    }
    
    // MARK: - Sections
    
    open func appendSections(_ sections: [NTFormSection]) {
        for section in sections {
            appendSection(section)
        }
    }
    
    open func appendSection(_ section: NTFormSection) {
        insertSection(section, atIndex: sections.count)
    }
    
    open func insertSection(_ section: NTFormSection, atIndex index: Int, animated: Bool = false) {
        sections.insert(section, at: index)
    }
    
    open func reloadForm() {
        datasource = NTFormDatasource(sections: sections)
    }
    
    open override func handleRefresh() {
        super.handleRefresh()
        reloadForm()
    }
}
