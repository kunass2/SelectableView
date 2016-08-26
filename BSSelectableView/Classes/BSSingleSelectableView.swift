//
//  BSSingleSelectableView.swift
//  BSSelectableView
//
//  Created by Bartłomiej Semańczyk on 06/22/2016.
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

@IBDesignable public class BSSingleSelectableView: BSSelectableView, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet public var selectedOptionLabel: UILabel?
    
    public var selectedOption: BSSelectableOption? {
        
        didSet {
            setupLabel()
        }
    }
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        switchButton?.addTarget(self, action: #selector(switchButtonTapped), forControlEvents: .TouchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    func switchButtonTapped(sender: UIButton) {
        expanded = !expanded
    }
    
    //MARK: - Public
    
    //MARK: - Internal
    
    func setupLabel() {
        
        selectedOptionLabel?.numberOfLines = 0
        selectedOptionLabel?.adjustsFontSizeToFitWidth = true
        selectedOptionLabel?.minimumScaleFactor = 0.2
        tableView.reloadData()
        
        if selectedOption == nil {
            
            selectedOptionLabel?.text = placeholder
            selectedOptionLabel?.font = BSSelectableView.fontForPlaceholderText
            selectedOptionLabel?.textColor = BSSelectableView.textColorForPlaceholderText
            
        } else {
            
            selectedOptionLabel?.text = selectedOption?.title
            selectedOptionLabel?.font = BSSelectableView.fontForOption
            selectedOptionLabel?.textColor = BSSelectableView.titleColorForOption
        }
    }
    
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
        cell.titleLabel.font = BSSelectableView.fontForOption
        cell.titleLabel.textColor = option.identifier == selectedOption?.identifier ? BSSelectableView.titleColorForSelectedOption : BSSelectableView.titleColorForOption
        cell.leftPaddingConstraint.constant = CGFloat(BSSelectableView.leftPaddingForOption)
        
        cell.accessoryType = option.identifier == selectedOption?.identifier ? .Checkmark : .None
        cell.tintColor = BSSelectableView.tintColorForSelectedOption
        cell.layoutMargins = UIEdgeInsetsZero
        cell.selectionStyle = .None
        
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
