//
//  MultiSelectableView.swift
//  SelectableView
//
//  Created by Bartłomiej Semańczyk on 06/22/2016.
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

@IBDesignable open class MultiSelectableView: SelectableView, UITableViewDataSource, UITableViewDelegate {
    
    @IBInspectable open var lineHeight: CGFloat = 30
    @IBInspectable open var margin: CGFloat = 0
    
    @IBOutlet open var verticalTokenView: VerticalTokenView?
    @IBOutlet open var horizontalTokenView: HorizontalTokenView?
    @IBOutlet open var tokenViewHeightConstraint: NSLayoutConstraint?
    
    open var selectedOptions = Set<SelectableOption>() {
        
        didSet {
            
            verticalTokenView?.reloadData()
            horizontalTokenView?.reloadData()
            tableView.reloadData()
            updateContentOptionsHeight(for: filteredSortedOptions)
        }
    }
    
    var sortedSelectedOptions: [SelectableOption] {
        return selectedOptions.sorted { $0.index < $1.index }
    }
    
    private var filteredSortedOptions: [SelectableOption] {
        return options.filter({ !selectedOptions.contains($0) }).sorted { $0.index < $1.index }
    }
    
    override var expanded: Bool {
        
        didSet {
            
            super.expanded = expanded
            updateContentOptionsHeight(for: filteredSortedOptions)
        }
    }
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        verticalTokenView?.selectableView = self
        horizontalTokenView?.selectableView = self
        
        verticalTokenView?.reloadData()
        horizontalTokenView?.reloadData()
    }
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    //MARK: - Open
    
    open func deselect(option: SelectableOption) {
        selectedOptions.remove(option)
    }
    
    open func select(option: SelectableOption) {
        
        selectedOptions.insert(option)
        delegate?.multiSelectableView?(self, didSelect: option)
    }
    
    //MARK: - Internal
    
    func tokenView(for option: SelectableOption) -> UIView? {
        return delegate?.multiSelectableView?(self, tokenViewFor: option)
    }
    
    //MARK: - Private
    
    //MARK: - Overridden
    
    //MARK: - UITableViewDataSource
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSortedOptions.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCellIdentifier, for: indexPath) as! SelectableTableViewCell
        let option = filteredSortedOptions[indexPath.row]
        
        cell.titleLabel.text = option.title
        cell.titleLabel.font = fontForOption
        cell.titleLabel.textColor = titleColorForOption
        cell.leftPaddingConstraint.constant = CGFloat(leftPaddingForOption)
        cell.layoutMargins = .zero
        cell.accessoryType = .none
        cell.selectionStyle = .none
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(heightForOption)
    }
    
    //MARK: - UITableViewDelegate
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        select(option: filteredSortedOptions[indexPath.row])
    }
}
