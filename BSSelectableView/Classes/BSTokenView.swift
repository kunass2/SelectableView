//
//  ZFTokenTextField.swift
//  BSSelectableView
//
//  Created by Amornchai Kanokpullwad on 10/11/2014.
//  Simplified and rewritten in Swift by Bartłomiej Semańczyk and Piotr Pawluś
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

@objc protocol BSTokenViewDataSource: class {
    
    optional func tokenMarginInTokenInField(tokenField: BSTokenView) -> CGFloat
    func lineHeightForTokenInField(tokenField: BSTokenView) -> CGFloat
    func numberOfTokenInField(tokenField: BSTokenView) -> Int
    func tokenField(tokenField: BSTokenView, viewForTokenAtIndex index: Int) -> UIView?
    func tokenViewDidRefreshWithHeight(height: CGFloat)
}

public class BSTokenView: UIControl {
    
    weak var dataSource: BSTokenViewDataSource?
    
    private var tokenViews = [UIView]()
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        reloadData()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        reloadData()
    }
  
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        reloadData()
    }
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    //MARK: - Public
    
    //MARK: - Internal
    
    func reloadData() {
        
        for token in tokenViews {
            token.removeFromSuperview()
        }
        
        tokenViews.removeAll()
        
        if let dataSource = dataSource {
            
            let count = dataSource.numberOfTokenInField(self)
            
            for index in 0..<count {
                
                if let tokenView = dataSource.tokenField(self, viewForTokenAtIndex: index) {

                    tokenView.autoresizingMask = UIViewAutoresizing.None
                    addSubview(tokenView)
                    tokenViews.append(tokenView)
                }
            }
        }

        invalidateIntrinsicContentSize()
    }
    
    //MARK: - Private
    
    private func enumerateItemRectsUsingBlock(block: (CGRect) -> Void) {
        
        var x: CGFloat = 0
        var y: CGFloat = 0

        let lineHeight = dataSource?.lineHeightForTokenInField(self) ?? 0
        let margin = dataSource?.tokenMarginInTokenInField?(self) ?? 0

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
        
        let lineHeight = dataSource?.lineHeightForTokenInField(self) ?? 30
        
        if tokenViews.isEmpty {
            
            dataSource?.tokenViewDidRefreshWithHeight(lineHeight)
            return CGSizeZero
        }

        var totalRect = CGRectNull
        
        enumerateItemRectsUsingBlock { itemRect in
            totalRect = CGRectUnion(itemRect, totalRect)
        }
        
        dataSource?.tokenViewDidRefreshWithHeight(max(totalRect.size.height, lineHeight))
        
        return totalRect.size
    }
}
