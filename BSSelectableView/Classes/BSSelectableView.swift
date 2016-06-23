//
//  AppDelegate.swift
//  BSSelectableView
//
//  Created by Bartłomiej Semańczyk on 06/22/2016.
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

@IBDesignable public class BSSelectableView: BSView, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet public var textField: UITextField!
    
    public var selectedOption: BSSelectableOption? {
        
        didSet {
            
            textField.text = selectedOption?.title
            expanded = !expanded
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
        return options?.count ?? 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(BSSelectableTableViewCellIdentifier, forIndexPath: indexPath) as! BSSelectableTableViewCell
        let option = options?[indexPath.row]
        
        cell.titleLabel.text = option?.title
        cell.accessoryType = option?.identifier == selectedOption?.identifier ? .Checkmark : .None
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedOption = options?[indexPath.row]
        delegate?.selectableView?(self, didSelectOption: selectedOption!)
    }
}
