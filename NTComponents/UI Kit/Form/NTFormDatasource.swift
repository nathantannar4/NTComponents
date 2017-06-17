//
//  NTFormDatasource.swift
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

open class NTFormDatasource: NTCollectionDatasource {
    
    open var sections: [NTFormSection]
    
    public init(sections: [NTFormSection]) {
        self.sections = sections
        super.init()
    }
    
    open func cell(forIndexPath indexPath: IndexPath) -> NTFormCell {
        return sections[indexPath.section].rows[indexPath.row]
    }
    
    open override func cellClasses() -> [NTCollectionViewCell.Type] {
        var classes = [NTCollectionViewCell.Type] ()
        for section in 0...(numberOfSections() - 1) {
            let rows = (numberOfItems(section) - 1)
            if rows >= 0 {
                for row in 0...rows {
                    if let currentClass = cellClass(IndexPath(row: row, section: section)) {
                        classes.append(currentClass)
                    }
                }
            }
        }
        return classes
    }
    
    open override func cellClass(_ indexPath: IndexPath) -> NTCollectionViewCell.Type? {
        return object_getClass(sections[indexPath.section].rows[indexPath.row]) as? NTCollectionViewCell.Type
    }
    
    open override func headerClasses() -> [NTCollectionViewCell.Type]? {
        var headerClasses = [NTCollectionViewCell.Type]()
        for section in sections {
            if let header = section.header {
                if let headerClass = object_getClass(header) as? NTCollectionViewCell.Type {
                    headerClasses.append(headerClass)
                } else {
                    Log.write(.error, "Could not get header class")
                }
            }
        }
        return headerClasses
    }
    
    open override func footerClasses() -> [NTCollectionViewCell.Type]? {
        var footerClasses = [NTCollectionViewCell.Type]()
        for section in sections {
            if let footer = section.footer {
                if let footerClass = object_getClass(footer) as? NTCollectionViewCell.Type {
                    footerClasses.append(footerClass)
                } else {
                    Log.write(.error, "Could not get header class")
                }
            }
        }
        return footerClasses
    }
    
    open override func numberOfItems(_ section: Int) -> Int {
        return sections[section].rows.count
    }
    
    open override func numberOfSections() -> Int {
        return sections.count
    }
    
    open override func item(_ indexPath: IndexPath) -> Any? {
        return sections[indexPath.section].rows[indexPath.row].datasourceItem
    }
    
    open override func headerItem(_ section: Int) -> Any? {
        return sections[section].header?.label.text
    }
    
    open override func footerItem(_ section: Int) -> Any? {
        return sections[section].footer?.label.text
    }
}
