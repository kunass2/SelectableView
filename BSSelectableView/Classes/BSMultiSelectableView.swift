//
//  BSMultiSelectableView.swift
//  BSSelectableView
//
//  Created by Bartłomiej Semańczyk on 06/22/2016.
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

@IBDesignable public class BSMultiSelectableView: BSSelectableView, UITableViewDataSource, UITableViewDelegate {
    
    @IBInspectable public var lineHeight: CGFloat = 30
    @IBInspectable public var margin: CGFloat = 0
    
    @IBOutlet public var tokenView: BSTokenView?
    @IBOutlet public var scrollTokenView: BSScrollTokenView?
    @IBOutlet public var tokenViewHeightConstraint: NSLayoutConstraint?
    
    public var selectedOptions = [BSSelectableOption]() {
        
        didSet {
            
            for selectedOption in selectedOptions {
                
                for (index, option) in options.enumerate() {
                    
                    if selectedOption.index == option.index {
                        options.removeAtIndex(index)
                    }
                }
            }
            
            selectedOptions.sortInPlace { $0.index <= $1.index }
            tokenView?.reloadData()
            scrollTokenView?.reloadData()
        }
    }
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        switchButton?.addTarget(self, action: #selector(switchButtonTapped), forControlEvents: .TouchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tokenView?.multiselectableView = self
        scrollTokenView?.multiselectableView = self
        
        tokenView?.reloadData()
        scrollTokenView?.reloadData()
    }
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    //MARK: - Public
    
    //MARK: - Internal
    
    func switchButtonTapped(sender: UIButton) {
        expanded = !expanded
    }
    
    func viewForTokenAtIndex(index: Int) -> UIView? {
        return delegate?.multiSelectableView?(self, tokenViewForOption: selectedOptions[index], atIndex: index)
    }
    
    //MARK: - Private
    
    //MARK: - Overridden
    
    //MARK: - UITableViewDataSource
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(BSSelectableTableViewCellIdentifier, forIndexPath: indexPath) as! BSSelectableTableViewCell
        let option = options[indexPath.row]
        
        cell.titleLabel.text = option.title
        cell.titleLabel.font = BSSelectableView.fontForOption
        cell.titleLabel.textColor = BSSelectableView.titleColorForOption
        cell.leftPaddingConstraint.constant = CGFloat(BSSelectableView.leftPaddingForOption)
        
        cell.accessoryType = .None
        cell.layoutMargins = UIEdgeInsetsZero
        cell.selectionStyle = .None
        
        return cell
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(BSSelectableView.heightForOption)
    }
    
    //MARK: - UITableViewDelegate
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedOption = options[indexPath.row]
        selectedOptions.append(selectedOption)
        
        delegate?.multiSelectableView?(self, didSelectOption: selectedOption)
    }
}
