//
//  BSSingleSelectableView.swift
//  BSSelectableView
//
//  Created by Bartłomiej Semańczyk on 06/22/2016.
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

@IBDesignable open class BSSingleSelectableView: BSSelectableView, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet open var selectedOptionLabel: UILabel?
    
    open var selectedOption: BSSelectableOption? {
        
        didSet {
            setupLabel()
        }
    }
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        switchButton?.addTarget(self, action: #selector(switchButtonTapped), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    func switchButtonTapped(_ sender: UIButton) {
        expanded = !expanded
    }
    
    //MARK: - Open
    
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
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BSSelectableTableViewCellIdentifier, for: indexPath) as! BSSelectableTableViewCell
        let option = options[(indexPath as NSIndexPath).row]
        
        cell.titleLabel.text = option.title
        cell.titleLabel.font = BSSelectableView.fontForOption
        cell.titleLabel.textColor = option.identifier == selectedOption?.identifier ? BSSelectableView.titleColorForSelectedOption : BSSelectableView.titleColorForOption
        cell.leftPaddingConstraint.constant = CGFloat(BSSelectableView.leftPaddingForOption)
        
        cell.accessoryType = option.identifier == selectedOption?.identifier ? .checkmark : .none
        cell.tintColor = BSSelectableView.tintColorForSelectedOption
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = .none
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(BSSelectableView.heightForOption)
    }
    
    //MARK: - UITableViewDelegate
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedOption = options[(indexPath as NSIndexPath).row]
        expanded = false
        delegate?.singleSelectableView?(self, didSelectOption: selectedOption!)
    }
}
