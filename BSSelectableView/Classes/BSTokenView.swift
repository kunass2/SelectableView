//
//  ZFTokenTextField.swift
//  BSSelectableView
//
//  Created by Amornchai Kanokpullwad on 10/11/2014.
//  Simplified and rewritten in Swift by Bartłomiej Semańczyk and Piotr Pawluś
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

public class BSTokenView: UIControl {
    
    var multiselectableView: BSMultiSelectableView?
    
    private var tokenViews = [UIView]()
    private var placeholderLabel = UILabel()
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    //MARK: - Public
    
    //MARK: - Internal
    
    func reloadData() {
        
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        tokenViews.removeAll()
        
        let count = multiselectableView?.selectedOptions.count ?? 0
        
        for index in 0..<count {
            
            if let tokenView = multiselectableView?.viewForTokenAtIndex(index) {
                
                tokenView.autoresizingMask = UIViewAutoresizing.None
                addSubview(tokenView)
                tokenViews.append(tokenView)
            }
        }
        
        invalidateIntrinsicContentSize()
        
        if count == 0 {
            
            setupPlaceholderLabel()
            addSubview(placeholderLabel)
        }
    }
    
    func setupPlaceholderLabel() {
        
        placeholderLabel.frame = CGRect(x: CGFloat(BSSelectableView.leftPaddingForPlaceholderText), y: 0, width: frame.size.width, height: multiselectableView?.lineHeight ?? 0)
        placeholderLabel.text = multiselectableView?.placeholder
        placeholderLabel.textColor = BSSelectableView.textColorForPlaceholderText
        placeholderLabel.font = BSSelectableView.fontForPlaceholderText
    }
    
    //MARK: - Private
    
    private func enumerateItemRectsUsingBlock(block: (CGRect) -> Void) {
        
        var x: CGFloat = 0
        var y: CGFloat = 0

        let lineHeight = multiselectableView?.lineHeight ?? 0
        let margin = multiselectableView?.margin ?? 0

        for token in tokenViews {

            let width = max(CGRectGetWidth(bounds), CGRectGetWidth(token.frame))
            let tokenWidth = min(CGRectGetWidth(bounds), CGRectGetWidth(token.frame))
            
            if x > (width - tokenWidth) {
                
                y += lineHeight + margin
                x = 0
            }
            
            block(CGRect(x: x, y: y, width: tokenWidth, height: token.frame.size.height))
            
            x += tokenWidth + margin
        }
    }
    
    //MARK: - Overridden
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        invalidateIntrinsicContentSize()

        var counter = 0
        
        enumerateItemRectsUsingBlock { frame in
            
            let token = self.tokenViews[counter]
            token.frame = frame
            counter += 1
        }
    }
    
    override public func intrinsicContentSize() -> CGSize {
        
        let lineHeight = multiselectableView?.lineHeight ?? 0
        
        if tokenViews.isEmpty {
            
            multiselectableView?.tokenViewHeightConstraint?.constant = lineHeight
            return CGSizeZero
        }

        var totalRect = CGRectNull
        
        enumerateItemRectsUsingBlock { itemRect in
            totalRect = CGRectUnion(itemRect, totalRect)
        }
        
        multiselectableView?.tokenViewHeightConstraint?.constant = max(totalRect.size.height, lineHeight)
        
        return totalRect.size
    }
}
