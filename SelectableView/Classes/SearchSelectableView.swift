//
//  SearchSelectableView.swift
//  Pods
//
//  Created by Bartłomiej Semańczyk on 14/03/2017.
//
//

open class SearchSelectableView: SelectableView, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet open var textField: UITextField!
    
    open var selectedOption: SelectableOption? {
        
        didSet {
            
            textField.text = selectedOption?.title
            tableView.reloadData()
            expanded = false
            
            if let option = selectedOption {
                delegate?.searchSelectableView?(self, didSelect: option)
            }
        }
    }
    
    var filteredOptions: [SelectableOption] {
        return textField.text!.isEmpty ? options : options.filter { $0.title.lowercased().contains(textField.text!.lowercased()) }
    }
    
    override var expanded: Bool {
        
        didSet {
            
            super.expanded = expanded
            updateContentOptionsHeight(for: filteredOptions)
        }
    }
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    //MARK: - Open
    
    //MARK: - Internal
    
    func textFieldDidChange(_ sender: UITextField) {
        
        tableView.reloadData()
        expanded = true
        
        if sender.text!.isEmpty {
            selectedOption = nil
        }
    }
    
    //MARK: - Private
    
    //MARK: - Overridden
    
    //MARK: - UITableViewDataSource
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredOptions.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCellIdentifier, for: indexPath) as! SelectableTableViewCell
        let option = filteredOptions[indexPath.row]
        
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
    
    //MARK: - UITableViewDelegate
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOption = filteredOptions[indexPath.row]
    }
    
    //MARK: - UITextFieldDelegate
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        expanded = true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        selectedOption = nil
        
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        expanded = false
    }
}
