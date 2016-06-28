//
//  BSMultiSelectableView.swift
//  BSSelectableView
//
//  Created by Bartłomiej Semańczyk on 06/22/2016.
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

@IBDesignable public class BSMultiSelectableView: BSSelectableView, UITableViewDataSource, UITableViewDelegate, BSTokenViewDataSource {
    
    @IBOutlet public var tokenView: BSTokenView!
    @IBOutlet public var tokenViewHeightConstraint: NSLayoutConstraint?
    public var selectedOptions = [BSSelectableOption]() {
        
        didSet {
            
            setupDataSource()
            
            for selectedOption in selectedOptions {
                
                for (index, option) in options.enumerate() {
                    
                    if selectedOption.identifier == option.identifier {
                        options.removeAtIndex(index)
                    }
                }
            }
        }
    }
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    @IBAction public func switchButtonTapped(sender: UIButton) {
        
        setupDataSource()
        
        expanded = !expanded
        tableView.reloadData()
    }
    
    //MARK: - Public
    
    public override func updateView() {
        
        selectedOptions.sortInPlace { $0.identifier <= $1.identifier }
        tokenView.reloadData()
        super.updateView()
    }
    
    //MARK: - Internal
    
    //MARK: - Private
    
    private func setupDataSource() {
        
        setupViewAndDataSourceIfNeeded()
        tableView.delegate = self
        tableView.dataSource = self
        
        tokenView.dataSource = self
    }
    
    //MARK: - Overridden
    
    //MARK: - UITableViewDataSource
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(BSSelectableTableViewCellIdentifier, forIndexPath: indexPath) as! BSSelectableTableViewCell
        let option = options[indexPath.row]
        
        cell.titleLabel.text = option.title
        cell.accessoryType = .None
        cell.titleLabel.font = BSSelectableView.fontForOption
        cell.titleLabel.textColor = BSSelectableView.titleColorForOption
        cell.leftPaddingConstraint.constant = CGFloat(BSSelectableView.leftPaddingForOption)
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(BSSelectableView.heightForOption)
    }
    
    //MARK: - UITableViewDelegate
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedOption = options[indexPath.row]
            
        options.removeAtIndex(indexPath.row)
        selectedOptions.append(selectedOption)
        
        updateView()
        
        delegate?.multiSelectableView?(self, didSelectOption: selectedOption)
    }
    
    //MARK: - ZFTokenFieldDataSource
    
    func lineHeightForTokenInField(tokenField: BSTokenView) -> CGFloat {
        return delegate?.lineHeightForTokenInMultiSelectableView?() ?? 30
    }
    
    func numberOfTokenInField(tokenField: BSTokenView) -> Int {
        return selectedOptions.count
    }
    
    func tokenField(tokenField: BSTokenView, viewForTokenAtIndex index: Int) -> UIView? {
        return delegate?.multiSelectableView?(self, tokenViewForOption: selectedOptions[index], atIndex: index)
    }
    
    func tokenViewDidRefreshWithHeight(height: CGFloat) {
        tokenViewHeightConstraint?.constant = height
    }
}
