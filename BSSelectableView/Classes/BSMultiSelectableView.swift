//
//  BSMultiSelectableView.swift
//  Pods
//
//  Created by Bartłomiej Semańczyk on 23/06/16.
//
//

import ZFTokenField

@IBDesignable public class BSMultiSelectableView: BSView, UITableViewDataSource, UITableViewDelegate, ZFTokenFieldDataSource, ZFTokenFieldDelegate {
    
    @IBOutlet var tokenField: ZFTokenField!
    public var selectedOptions = [BSSelectableOption]()
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    @IBAction public func switchButtonTapped(sender: UIButton) {
        
        setupViewAndDataSourceIfNeeded()
        tableView.delegate = self
        tableView.dataSource = self
        
        tokenField.dataSource = self
        tokenField.delegate = self
        
        expanded = !expanded
        tableView.reloadData()
    }
    
    //MARK: - Public
    
    public func updateView() {
        
        sortOptions()
        selectedOptions.sortInPlace { $0.title.lowercaseString <= $1.title.lowercaseString }
        
        tokenField.reloadData()
        tableView.reloadData()
        updateContentOptionsHeight()
    }
    
    //MARK: - Internal
    
    //MARK: - Private
    
    //MARK: - Overridden
    
    //MARK: - UITableViewDataSource
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options?.count ?? 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(BSSelectableTableViewCellIdentifier, forIndexPath: indexPath) as! BSSelectableTableViewCell
        let option = options?[indexPath.row]
        
        cell.titleLabel.text = option?.title
        cell.accessoryType = .None
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let selectedOption = options?[indexPath.row] {
            
            options?.removeAtIndex(indexPath.row)
            selectedOptions.append(selectedOption)
            
            updateView()
            
            delegate?.multiSelectableView?(self, didSelectOption: selectedOption)
        }
    }
    
    //MARK: - ZFTokenFieldDataSource
    
    public func lineHeightForTokenInField(tokenField: ZFTokenField!) -> CGFloat {
        return 30
    }
    
    public func numberOfTokenInField(tokenField: ZFTokenField!) -> UInt {
        return UInt(selectedOptions.count)
    }
    
    public func tokenField(tokenField: ZFTokenField!, viewForTokenAtIndex index: UInt) -> UIView! {
        return delegate?.multiSelectableView?(self, tokenViewForOption: selectedOptions[Int(index)], atIndex: Int(index))
    }
}
