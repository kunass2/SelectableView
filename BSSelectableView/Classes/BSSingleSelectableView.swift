//
//  BSSingleSelectableView.swift
//  BSSelectableView
//
//  Created by Bartłomiej Semańczyk on 06/22/2016.
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

@IBDesignable public class BSSingleSelectableView: BSSelectableView, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet public var textField: UITextField!
    
    public var selectedOption: BSSelectableOption? {
        
        didSet {
            textField.text = selectedOption?.title
        }
    }
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    @IBAction public func switchButtonTapped(sender: UIButton) {
        
        setupViewAndDataSourceIfNeeded()
        tableView.delegate = self
        tableView.dataSource = self
        
        expanded = !expanded
        tableView.reloadData()
    }
    
    //MARK: - Public
    
    //MARK: - Internal
    
    //MARK: - Private
    
    //MARK: - Overridden
    
    //MARK: - UITableViewDataSource
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count ?? 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(BSSelectableTableViewCellIdentifier, forIndexPath: indexPath) as! BSSelectableTableViewCell
        let option = options[indexPath.row]
        
        cell.titleLabel.text = option.title
        cell.accessoryType = option.identifier == selectedOption?.identifier ? .Checkmark : .None
        cell.tintColor = BSSelectableView.tintColorForSelectedOption
        cell.titleLabel.font = BSSelectableView.fontForOption
        cell.titleLabel.textColor = option.identifier == selectedOption?.identifier ? BSSelectableView.titleColorForSelectedOption : BSSelectableView.titleColorForOption
        cell.leftPaddingConstraint.constant = CGFloat(BSSelectableView.leftPaddingForOption)
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(BSSelectableView.heightForOption)
    }
    
    //MARK: - UITableViewDelegate
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedOption = options[indexPath.row]
        expanded = false
        delegate?.singleSelectableView?(self, didSelectOption: selectedOption!)
    }
}
