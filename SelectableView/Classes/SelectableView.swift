//
//  SelectableView.swift
//  SelectableView
//
//  Created by Bartłomiej Semańczyk on 06/22/2016.
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

open class SelectableOption: NSObject {
    
    open var index: Int
    open var identifier: String
    open var title: String
    open var userInfo: [AnyHashable: Any]?
    
    open var descendantOptions = [SelectableOption]()
    
    public init(index: Int, title: String, identifier: String, userInfo: [AnyHashable: Any]? = nil) {
        
        self.index = index
        self.identifier = identifier
        self.title = title
        self.userInfo = userInfo
    }
}

@objc public protocol SelectableViewDelegate {
    
    @objc optional func multiSelectableView(_ view: MultiSelectableView, tokenViewFor option: SelectableOption) -> UIView
    
    @objc optional func singleSelectableView(_ view: SingleSelectableView, didSelect option: SelectableOption)
    @objc optional func multiSelectableView(_ view: MultiSelectableView, didSelect option: SelectableOption)
    @objc optional func searchSelectableView(_ view: SearchSelectableView, didSelect option: SelectableOption)
    @objc optional func selectableViewDidToggleOptions(with button: UIButton, expanded: Bool)
}

let SelectableTableViewCellIdentifier = "SelectableTableViewCellIdentifier"

@IBDesignable open class SelectableView: UIView {
    
    var fontForOption = UIFont.systemFont(ofSize: 16)
    var fontForPlaceholderText = UIFont.systemFont(ofSize: 14)
    
    @IBInspectable open var leftPaddingForPlaceholderText: Int = 0
    @IBInspectable open var leftPaddingForOption: Int = 20
    @IBInspectable open var heightForOption: Int = 40
    
    @IBInspectable open var titleColorForSelectedOption: UIColor = UIColor.green
    @IBInspectable open var titleColorForOption: UIColor = UIColor.black
    @IBInspectable open var textColorForPlaceholderText: UIColor = UIColor.gray
    @IBInspectable open var tintColorForSelectedOption: UIColor = UIColor.blue
    
    @IBInspectable open var identifier: String = ""
    @IBInspectable open var tableViewAccessibilityIdentifier: String = ""
    @IBInspectable open var maxNumberOfRows: Int = 6
    @IBInspectable open var placeholder: String = "" {
        
        didSet {
            
            (self as? MultiSelectableView)?.verticalTokenView?.setupPlaceholderLabel()
            (self as? MultiSelectableView)?.horizontalTokenView?.setupPlaceholderLabel()
            (self as? SingleSelectableView)?.setupLabel()
        }
    }
    
    @IBInspectable open var cornerRadius: CGFloat = 3 {
        
        didSet {
            
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 0 {
        
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable open var borderColor: UIColor = UIColor.clear {
        
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBOutlet open var switchButton: UIButton?
    @IBOutlet open var contentOptionsHeightConstraint: NSLayoutConstraint?
    @IBOutlet open var contentOptionsView: UIView?
    
    weak open var delegate: SelectableViewDelegate?
    
    open var options = [SelectableOption]() {
        
        didSet {
            
            tableView.reloadData()
            updateContentOptionsHeight(for: sortedOptions)
        }
    }
    
    var sortedOptions: [SelectableOption] {
        return options.sorted { $0.index < $1.index }
    }
    
    var tableView = UITableView()
    var expanded = false {
        
        didSet {
            
            if let switchButton = switchButton {
                delegate?.selectableViewDidToggleOptions?(with: switchButton, expanded: expanded)
            }
        }
    }
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        switchButton?.addTarget(self, action: #selector(switchButtonTapped), for: .touchUpInside)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.bounces = false
        tableView.rowHeight = 40
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.accessibilityIdentifier = tableViewAccessibilityIdentifier
        
        let nib = UINib(nibName: "SelectableTableViewCell", bundle: Bundle(for: SelectableTableViewCell.classForCoder()))
        tableView.register(nib, forCellReuseIdentifier: SelectableTableViewCellIdentifier)
        
        if let contentOptionsView = contentOptionsView {
            
            contentOptionsView.addSubview(tableView)
            
            let topConstraint = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: contentOptionsView, attribute: .top, multiplier: 1, constant: 0)
            let trailingConstraint = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: contentOptionsView, attribute: .trailing, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: contentOptionsView, attribute: .bottom, multiplier: 1, constant: 0)
            let leadingConstraint = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: contentOptionsView, attribute: .leading, multiplier: 1, constant: 0)
            
            contentOptionsView.addConstraints([topConstraint, trailingConstraint, bottomConstraint, leadingConstraint])
            contentOptionsView.layoutIfNeeded()
        }
        
        (self as? MultiSelectableView)?.verticalTokenView?.reloadData()
        (self as? MultiSelectableView)?.horizontalTokenView?.reloadData()
        (self as? SingleSelectableView)?.setupLabel()
    }
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    //MARK: - Open
    
    open func hideOptions() {
        expanded = false
    }
    
    //MARK: - Internal
    
    func switchButtonTapped(_ sender: UIButton) {
        expanded = !expanded
    }
    
    func updateContentOptionsHeight(for options: [SelectableOption]) {
        contentOptionsHeightConstraint?.constant = expanded ? CGFloat(min((options.count) * heightForOption, maxNumberOfRows * heightForOption)) : 0
    }
    
    //MARK: - Private
    
    //MARK: - Overridden
}
