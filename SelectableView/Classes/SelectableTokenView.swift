//
//  SelectableTokenView.swift
//  SelectableView
//
//  Created by Amornchai Kanokpullwad on 10/11/2014.
//  Simplified and rewritten in Swift by Bartłomiej Semańczyk and Piotr Pawluś
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

open class VerticalTokenView: UIControl {
    
    var selectableView: MultiSelectableView?
    
    private var tokenViews = [UIView]()
    private var placeholderLabel = UILabel()
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    //MARK: - Open
    
    //MARK: - Internal
    
    func reloadData() {
        
        if let options = selectableView?.sortedSelectedOptions {
            
            for subview in subviews {
                subview.removeFromSuperview()
            }
            
            tokenViews.removeAll()
            
            for index in 0..<options.count {
                
                if let tokenView = selectableView?.tokenView(for: options[index]) {
                    
                    tokenView.autoresizingMask = UIView.AutoresizingMask()
                    addSubview(tokenView)
                    tokenViews.append(tokenView)
                }
            }
            
            invalidateIntrinsicContentSize()
            
            if options.isEmpty {
                
                setupPlaceholderLabel()
                addSubview(placeholderLabel)
            }
        }
    }
    
    func setupPlaceholderLabel() {
        
        if let selectableView = selectableView {
            
            placeholderLabel.frame = CGRect(x: CGFloat(selectableView.leftPaddingForPlaceholderText), y: 0, width: frame.size.width, height: selectableView.lineHeight)
            placeholderLabel.text = selectableView.placeholder
            placeholderLabel.textColor = selectableView.textColorForPlaceholderText
            placeholderLabel.font = selectableView.fontForPlaceholderText
        }
    }
    
    //MARK: - Private
    
    private func enumerateItemRectsUsingBlock(_ block: (CGRect) -> Void) {
        
        var x: CGFloat = 0
        var y: CGFloat = 0

        let lineHeight = selectableView?.lineHeight ?? 0
        let margin = selectableView?.margin ?? 0

        for token in tokenViews {

            let width = max(bounds.width, token.frame.width)
            let tokenWidth = min(bounds.width, token.frame.width)
            
            if x > (width - tokenWidth) {
                
                y += lineHeight + margin
                x = 0
            }
            
            block(CGRect(x: x, y: y, width: tokenWidth, height: token.frame.size.height))
            
            x += tokenWidth + margin
        }
    }
    
    //MARK: - Overridden
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        invalidateIntrinsicContentSize()

        var counter = 0
        
        enumerateItemRectsUsingBlock { frame in
            
            let token = self.tokenViews[counter]
            token.frame = frame
            counter += 1
        }
    }
    
    override open var intrinsicContentSize : CGSize {
        
        let lineHeight = selectableView?.lineHeight ?? 0
        
        if tokenViews.isEmpty {
            
            selectableView?.tokenViewHeightConstraint?.constant = lineHeight
            return CGSize.zero
        }

        var totalRect = CGRect.null
        
        enumerateItemRectsUsingBlock { itemRect in
            totalRect = itemRect.union(totalRect)
        }
        
        selectableView?.tokenViewHeightConstraint?.constant = max(totalRect.size.height, lineHeight)
        
        return totalRect.size
    }
}
