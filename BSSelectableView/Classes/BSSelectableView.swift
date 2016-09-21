//
//  BSSelectableView.swift
//  BSSelectableView
//
//  Created by Bartłomiej Semańczyk on 06/22/2016.
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

open class BSSelectableOption: NSObject {
    
    open var index: Int
    open var identifier: String
    open var title: String
    open var userInfo: [String: AnyObject]?
    
    open var descendantOptions = [BSSelectableOption]()
    
    public init(index: Int, title: String, identifier: String, userInfo: [String: AnyObject]? = nil) {
        
        self.index = index
        self.identifier = identifier
        self.title = title
        self.userInfo = userInfo
    }
}

@objc public protocol BSSelectableViewDelegate {
    
    @objc optional func multiSelectableView(_ view: BSMultiSelectableView, tokenViewForOption option: BSSelectableOption, atIndex index: Int) -> UIView
    
    @objc optional func singleSelectableView(_ view: BSSingleSelectableView, didSelectOption option: BSSelectableOption)
    @objc optional func multiSelectableView(_ view: BSMultiSelectableView, didSelectOption option: BSSelectableOption)
    @objc optional func selectableViewToggledOptions(withButton: UIButton, expanded: Bool)
}

let BSSelectableTableViewCellIdentifier = "SelectableTableViewCellIdentifier"

open class BSSelectableView: UIView {
    
    static open var fontForOption = UIFont.systemFont(ofSize: 16)
    static open var fontForPlaceholderText = UIFont.systemFont(ofSize: 14)
    
    static open var leftPaddingForPlaceholderText = 0
    static open var leftPaddingForOption = 20
    static open var heightForOption = 40
    
    static open var tintColorForSelectedOption = UIColor.blue
    static open var titleColorForSelectedOption = UIColor.green
    static open var titleColorForOption = UIColor.black
    static open var textColorForPlaceholderText = UIColor.gray
    
    @IBInspectable open var identifier: String = ""
    @IBInspectable open var tableViewAccessibilityIdentifier: String = ""
    @IBInspectable open var maxNumberOfRows: Int = 6
    @IBInspectable open var placeholder: String = "" {
        
        didSet {
            
            (self as? BSMultiSelectableView)?.tokenView?.setupPlaceholderLabel()
            (self as? BSMultiSelectableView)?.scrollTokenView?.setupPlaceholderLabel()
            (self as? BSSingleSelectableView)?.setupLabel()
        }
    }
    
    @IBInspectable open var cornerRadius: CGFloat = 3 {
        
        didSet {
            
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
    @IBOutlet open var switchButton: UIButton?
    @IBOutlet open var contentOptionsHeightConstraint: NSLayoutConstraint?
    @IBOutlet open var contentOptionsView: UIView?
    
    weak open var delegate: BSSelectableViewDelegate?
    
    open var options = [BSSelectableOption]() {
        
        didSet {
            
            options.sort { $0.index <= $1.index }
            tableView.reloadData()
            updateContentOptionsHeight()
        }
    }
    
    var tableView = UITableView()
    var expanded = false {
        
        didSet {
            
            updateContentOptionsHeight()
            
            if let switchButton = switchButton {
                delegate?.selectableViewToggledOptions?(withButton: switchButton, expanded: expanded)
            }
        }
    }
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.bounces = false
        tableView.rowHeight = 40
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.accessibilityIdentifier = tableViewAccessibilityIdentifier
        
        let nib = UINib(nibName: "BSSelectableTableViewCell", bundle: Bundle(for: BSSelectableTableViewCell.classForCoder()))
        tableView.register(nib, forCellReuseIdentifier: BSSelectableTableViewCellIdentifier)
        
        if let contentOptionsView = contentOptionsView {
            
            contentOptionsView.addSubview(tableView)
            
            let topConstraint = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: contentOptionsView, attribute: .top, multiplier: 1, constant: 0)
            let trailingConstraint = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: contentOptionsView, attribute: .trailing, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: contentOptionsView, attribute: .bottom, multiplier: 1, constant: 0)
            let leadingConstraint = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: contentOptionsView, attribute: .leading, multiplier: 1, constant: 0)
            
            contentOptionsView.addConstraints([topConstraint, trailingConstraint, bottomConstraint, leadingConstraint])
            contentOptionsView.layoutIfNeeded()
        }
        
        (self as? BSMultiSelectableView)?.tokenView?.reloadData()
        (self as? BSMultiSelectableView)?.scrollTokenView?.reloadData()
        (self as? BSSingleSelectableView)?.setupLabel()
    }
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    //MARK: - Open
    
    open func hideOptions() {
        expanded = false
    }
    
    //MARK: - Internal
    
    func updateContentOptionsHeight() {
        contentOptionsHeightConstraint?.constant = expanded ? CGFloat(min((options.count) * BSSelectableView.heightForOption, maxNumberOfRows * BSSelectableView.heightForOption)) : 0
    }
    
    //MARK: - Private
    
    //MARK: - Overridden
}
