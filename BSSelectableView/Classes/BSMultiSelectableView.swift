//
//  BSMultiSelectableView.swift
//  BSSelectableView
//
//  Created by Bartłomiej Semańczyk on 06/22/2016.
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

@IBDesignable open class BSMultiSelectableView: BSSelectableView, UITableViewDataSource, UITableViewDelegate {
    
    @IBInspectable open var lineHeight: CGFloat = 30
    @IBInspectable open var margin: CGFloat = 0
    
    @IBOutlet open var tokenView: BSTokenView?
    @IBOutlet open var scrollTokenView: BSScrollTokenView?
    @IBOutlet open var tokenViewHeightConstraint: NSLayoutConstraint?
    
    open var selectedOptions = [BSSelectableOption]() {
        
        didSet {
            
            for selectedOption in selectedOptions {
                
                for (index, option) in options.enumerated() {
                    
                    if selectedOption.index == option.index {
                        options.remove(at: index)
                    }
                }
            }
            
            selectedOptions.sort { $0.index <= $1.index }
            tokenView?.reloadData()
            scrollTokenView?.reloadData()
        }
    }
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        switchButton?.addTarget(self, action: #selector(switchButtonTapped), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tokenView?.multiselectableView = self
        scrollTokenView?.multiselectableView = self
        
        tokenView?.reloadData()
        scrollTokenView?.reloadData()
    }
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    //MARK: - Open
    
    //MARK: - Internal
    
    func switchButtonTapped(_ sender: UIButton) {
        expanded = !expanded
    }
    
    func viewForTokenAtIndex(_ index: Int) -> UIView? {
        return delegate?.multiSelectableView?(self, tokenViewFor: selectedOptions[index], at: index)
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
        cell.titleLabel.textColor = BSSelectableView.titleColorForOption
        cell.leftPaddingConstraint.constant = CGFloat(BSSelectableView.leftPaddingForOption)
        
        cell.accessoryType = .none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = .none
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(BSSelectableView.heightForOption)
    }
    
    //MARK: - UITableViewDelegate
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedOption = options[(indexPath as NSIndexPath).row]
        selectedOptions.append(selectedOption)
        
        delegate?.multiSelectableView?(self, didSelect: selectedOption)
    }
}
