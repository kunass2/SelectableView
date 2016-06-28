//
//  ViewController.swift
//  BSSelectableView
//
//  Created by Bartłomiej Semańczyk on 06/22/2016.
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

class ViewController: UIViewController, BSSelectableViewDelegate {
    
    @IBOutlet var selectableView: BSSelectableView!
    @IBOutlet var multiselectableView: BSMultiSelectableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BSSelectableView.titleColorForSelectedOption = UIColor.redColor()
        
        selectableView.delegate = self
        multiselectableView.delegate = self
    }
    
    func selectableOptionsForSelectableViewWithIdentifier(identifier: String) -> [BSSelectableOption] {
        
        return [
            BSSelectableOption(identifier: 0, title: "First title"),
            BSSelectableOption(identifier: 1, title: "aaa"),
            BSSelectableOption(identifier: 2, title: "Second Title"),
            BSSelectableOption(identifier: 3, title: "bbb super dlugi name oleeeeee hello super dluhi jestem gosc ole oeoeoeoeoeoeoeooe oeoeo eoe oeoe eoeooe hhh"),
            BSSelectableOption(identifier: 4, title: "ccc"),
            BSSelectableOption(identifier: 5, title: "ddd"),
            BSSelectableOption(identifier: 6, title: "ee e"),
            BSSelectableOption(identifier: 7, title: "Second Title"),
            BSSelectableOption(identifier: 8, title: "Second Title"),
            BSSelectableOption(identifier: 9, title: "Second Title"),
            BSSelectableOption(identifier: 10, title: "tttttt"),
            BSSelectableOption(identifier: 11, title: "Second Title"),
            BSSelectableOption(identifier: 12, title: "Second Title"),
            BSSelectableOption(identifier: 13, title: "Second Title"),
            BSSelectableOption(identifier: 14, title: "Second Title")
        ]
    }
    
    func multiSelectableView(view: BSMultiSelectableView, tokenViewForOption option: BSSelectableOption, atIndex index: Int) -> UIView {
        
        let tokenView = NSBundle.mainBundle().loadNibNamed("BSSelectedTokenFieldView", owner: self, options: nil).first as! BSSelectedTokenFieldView
        tokenView.titleLabel.text = option.title
        tokenView.titleLabel.sizeToFit()
        tokenView.frame = CGRectMake(0, 0, min(tokenView.titleLabel.frame.size.width + 50, 200), 30)
        
        tokenView.performHandler = {
            
            view.options?.append(option)
            view.selectedOptions.removeAtIndex(index)
            view.updateView()
        }
        
        return tokenView
    }
}
