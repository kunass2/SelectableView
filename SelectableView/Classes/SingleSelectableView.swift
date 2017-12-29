//
//  SingleSelectableView.swift
//  SelectableView
//
//  Created by Bartłomiej Semańczyk on 06/22/2016.
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

@IBDesignable open class SingleSelectableView: SelectableView, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet open var selectedOptionLabel: UILabel?
    
    @IBInspectable open var hideOnSelect: Bool = true
    
    open var selectedOption: SelectableOption? {
        
        didSet {
            setupLabel()
        }
    }
    
    override var expanded: Bool {
        
        didSet {
            
            super.expanded = expanded
            updateContentOptionsHeight(for: options)
        }
    }
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    //MARK: - Open
    
    //MARK: - Internal
    
    func setupLabel() {
        
        selectedOptionLabel?.numberOfLines = 0
        selectedOptionLabel?.adjustsFontSizeToFitWidth = true
        selectedOptionLabel?.minimumScaleFactor = 0.2
        tableView.reloadData()
        
        if selectedOption == nil {
            
            selectedOptionLabel?.text = placeholder
            selectedOptionLabel?.font = fontForPlaceholderText
            selectedOptionLabel?.textColor = textColorForPlaceholderText
            
        } else {
            
            selectedOptionLabel?.text = selectedOption?.title
            selectedOptionLabel?.font = fontForOption
            selectedOptionLabel?.textColor = titleColorForOption
        }
    }
    
    //MARK: - Private
    
    //MARK: - Overridden
    
    //MARK: - UITableViewDataSource
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedOptions.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCellIdentifier, for: indexPath) as! SelectableTableViewCell
        let option = sortedOptions[indexPath.row]
        
        cell.titleLabel.text = option.title
        cell.titleLabel.font = fontForOption
        cell.titleLabel.textColor = option.identifier == selectedOption?.identifier ? titleColorForSelectedOption : titleColorForOption
        cell.leftPaddingConstraint.constant = CGFloat(leftPaddingForOption)
        cell.layoutMargins = UIEdgeInsets.zero
        cell.accessoryType = option.identifier == selectedOption?.identifier ? .checkmark : .none
        cell.tintColor = tintColorForSelectedOption
        cell.selectionStyle = .none
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(heightForOption)
    }
    
    //MARK: - UITableViewDelegate
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedOption = sortedOptions[indexPath.row]
        if hideOnSelect {
            expanded = false
        }
        delegate?.singleSelectableView?(self, didSelect: selectedOption!)
    }
}
