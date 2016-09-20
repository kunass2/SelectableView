//
//  BSSelectableView.swift
//  BSSelectableView
//
//  Created by Bartłomiej Semańczyk on 06/22/2016.
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

public class BSSelectableOption: NSObject {
    
    public var index: Int
    public var identifier: String
    public var title: String
    public var userInfo: [String: AnyObject]?
    
    public var descendantOptions = [BSSelectableOption]()
    
    public init(index: Int, title: String, identifier: String, userInfo: [String: AnyObject]? = nil) {
        
        self.index = index
        self.identifier = identifier
        self.title = title
        self.userInfo = userInfo
    }
}

@objc public protocol BSSelectableViewDelegate {
    
    optional func multiSelectableView(view: BSMultiSelectableView, tokenViewForOption option: BSSelectableOption, atIndex index: Int) -> UIView
    
    optional func singleSelectableView(view: BSSingleSelectableView, didSelectOption option: BSSelectableOption)
    optional func multiSelectableView(view: BSMultiSelectableView, didSelectOption option: BSSelectableOption)
    optional func selectableViewToggledOptionsWithButton(button: UIButton, expanded: Bool)
}

let BSSelectableTableViewCellIdentifier = "SelectableTableViewCellIdentifier"

public class BSSelectableView: UIView {
    
    static public var fontForOption = UIFont.systemFontOfSize(16)
    static public var fontForPlaceholderText = UIFont.systemFontOfSize(14)
    
    static public var leftPaddingForPlaceholderText = 0
    static public var leftPaddingForOption = 20
    static public var heightForOption = 40
    
    static public var tintColorForSelectedOption = UIColor.blueColor()
    static public var titleColorForSelectedOption = UIColor.greenColor()
    static public var titleColorForOption = UIColor.blackColor()
    static public var textColorForPlaceholderText = UIColor.grayColor()
    
    @IBInspectable public var identifier: String = ""
    @IBInspectable public var tableViewAccessibilityIdentifier: String = ""
    @IBInspectable public var maxNumberOfRows: Int = 6
    @IBInspectable public var placeholder: String = "" {
        
        didSet {
            
            (self as? BSMultiSelectableView)?.tokenView?.setupPlaceholderLabel()
            (self as? BSMultiSelectableView)?.scrollTokenView?.setupPlaceholderLabel()
            (self as? BSSingleSelectableView)?.setupLabel()
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 3 {
        
        didSet {
            
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
    @IBOutlet public var switchButton: UIButton?
    @IBOutlet public var contentOptionsHeightConstraint: NSLayoutConstraint?
    @IBOutlet public var contentOptionsView: UIView?
    
    weak public var delegate: BSSelectableViewDelegate?
    
    public var options = [BSSelectableOption]() {
        
        didSet {
            
            options.sortInPlace { $0.index <= $1.index }
            tableView.reloadData()
            updateContentOptionsHeight()
        }
    }
    
    var tableView = UITableView()
    var expanded = false {
        
        didSet {
            
            updateContentOptionsHeight()
            
            if let switchButton = switchButton {
                delegate?.selectableViewToggledOptionsWithButton?(switchButton, expanded: expanded)
            }
        }
    }
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.bounces = false
        tableView.rowHeight = 40
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.accessibilityIdentifier = tableViewAccessibilityIdentifier
        
        let nib = UINib(nibName: "BSSelectableTableViewCell", bundle: NSBundle(forClass: BSSelectableTableViewCell.classForCoder()))
        tableView.registerNib(nib, forCellReuseIdentifier: BSSelectableTableViewCellIdentifier)
        
        if let contentOptionsView = contentOptionsView {
            
            contentOptionsView.addSubview(tableView)
            
            let topConstraint = NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: contentOptionsView, attribute: .Top, multiplier: 1, constant: 0)
            let trailingConstraint = NSLayoutConstraint(item: tableView, attribute: .Trailing, relatedBy: .Equal, toItem: contentOptionsView, attribute: .Trailing, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: contentOptionsView, attribute: .Bottom, multiplier: 1, constant: 0)
            let leadingConstraint = NSLayoutConstraint(item: tableView, attribute: .Leading, relatedBy: .Equal, toItem: contentOptionsView, attribute: .Leading, multiplier: 1, constant: 0)
            
            contentOptionsView.addConstraints([topConstraint, trailingConstraint, bottomConstraint, leadingConstraint])
            contentOptionsView.layoutIfNeeded()
        }
        
        (self as? BSMultiSelectableView)?.tokenView?.reloadData()
        (self as? BSMultiSelectableView)?.scrollTokenView?.reloadData()
        (self as? BSSingleSelectableView)?.setupLabel()
    }
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    //MARK: - Public
    
    public func hideOptions() {
        expanded = false
    }
    
    //MARK: - Internal
    
    func updateContentOptionsHeight() {
        contentOptionsHeightConstraint?.constant = expanded ? CGFloat(min((options.count) * BSSelectableView.heightForOption, maxNumberOfRows * BSSelectableView.heightForOption)) : 0
    }
    
    //MARK: - Private
    
    //MARK: - Overridden
}
