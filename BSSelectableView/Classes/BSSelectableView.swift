//
//  BSSelectableView.swift
//  BSSelectableView
//
//  Created by Bartłomiej Semańczyk on 06/22/2016.
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

public class BSSelectableOption: NSObject {
    
    public var identifier = 0
    public var title = ""
    
    public init(identifier: Int, title: String) {
        
        self.identifier = identifier
        self.title = title
    }
}

@objc public protocol BSSelectableViewDelegate {
    
    func selectableOptionsForSelectableViewWithIdentifier(identifier: String) -> [BSSelectableOption]
    optional func singleSelectableView(view: BSSingleSelectableView, didSelectOption option: BSSelectableOption)
    optional func multiSelectableView(view: BSMultiSelectableView, didSelectOption option: BSSelectableOption)
    optional func multiSelectableView(view: BSMultiSelectableView, didRemoveOption option: BSSelectableOption)
    optional func multiSelectableView(view: BSMultiSelectableView, tokenViewForOption option: BSSelectableOption, atIndex index: Int) -> UIView
    optional func lineHeightForTokenInMultiSelectableView() -> CGFloat
}

let BSSelectableTableViewCellIdentifier = "SelectableTableViewCellIdentifier"

public class BSSelectableView: UIView {
    
    static public var tintColorForSelectedOption = UIColor.blueColor()
    static public var titleColorForSelectedOption = UIColor.greenColor()
    static public var titleColorForOption = UIColor.blackColor()
    static public var fontForOption = UIFont.systemFontOfSize(16)
    static public var leftPaddingForOption = 20
    static public var heightForOption = 40
    
    @IBInspectable public var identifier: String = ""
    @IBInspectable public var maxNumberOfRows: Int = 6
    @IBInspectable public var cornerRadius: CGFloat = 3 {
        
        didSet {
            
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
    @IBOutlet public var contentOptionsHeightConstraint: NSLayoutConstraint!
    @IBOutlet public var contentOptionsView: UIView!
    
    weak public var delegate: BSSelectableViewDelegate?
    
    public var options: [BSSelectableOption]?
    
    var tableView = UITableView()
    var expanded = false {
        
        didSet {
            updateContentOptionsHeight()
        }
    }
    
    private var optionsFetched = false
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    //MARK: - Public
    
    public func hideOptions() {
        expanded = false
    }
    
    public func updateView() {
        
        sortOptions()
        tableView.reloadData()
        updateContentOptionsHeight()
    }
    
    //MARK: - Internal
    
    func updateContentOptionsHeight() {
        contentOptionsHeightConstraint.constant = expanded ? CGFloat(min((options?.count ?? 0) * BSSelectableView.heightForOption, maxNumberOfRows * BSSelectableView.heightForOption)) : 0
    }
    
    func setupViewAndDataSourceIfNeeded() {
        
        if !optionsFetched {
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.bounces = false
            tableView.rowHeight = 40
            tableView.separatorInset = UIEdgeInsetsZero
            tableView.layoutMargins = UIEdgeInsetsZero
            tableView.accessibilityIdentifier = identifier
            
            let nib = UINib(nibName: "BSSelectableTableViewCell", bundle: NSBundle(forClass: BSSelectableTableViewCell.classForCoder()))
            tableView.registerNib(nib, forCellReuseIdentifier: BSSelectableTableViewCellIdentifier)
            
            contentOptionsView.addSubview(tableView)
            
            let topConstraint = NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: contentOptionsView, attribute: .Top, multiplier: 1, constant: 0)
            let trailingConstraint = NSLayoutConstraint(item: tableView, attribute: .Trailing, relatedBy: .Equal, toItem: contentOptionsView, attribute: .Trailing, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: contentOptionsView, attribute: .Bottom, multiplier: 1, constant: 0)
            let leadingConstraint = NSLayoutConstraint(item: tableView, attribute: .Leading, relatedBy: .Equal, toItem: contentOptionsView, attribute: .Leading, multiplier: 1, constant: 0)
            
            contentOptionsView.addConstraints([topConstraint, trailingConstraint, bottomConstraint, leadingConstraint])
            contentOptionsView.layoutIfNeeded()
            
            options = delegate?.selectableOptionsForSelectableViewWithIdentifier(identifier)
            sortOptions()
            optionsFetched = true
        }
    }
    
    func sortOptions() {
        options?.sortInPlace { $0.title.lowercaseString <= $1.title.lowercaseString }
    }
    
    //MARK: - Private
    
    //MARK: - Overridden
}
