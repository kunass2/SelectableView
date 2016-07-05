//
//  ViewController.swift
//  BSSelectableView
//
//  Created by Bartłomiej Semańczyk on 06/22/2016.
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

class ViewController: UIViewController, BSSelectableViewDelegate {
    
    @IBOutlet var selectableView: BSSingleSelectableView!
    @IBOutlet var multiselectableView: BSMultiSelectableView!
    @IBOutlet var multiscrollselectableView: BSMultiSelectableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BSSelectableView.titleColorForSelectedOption = UIColor.redColor()
        BSSelectableView.leftPaddingForOption = 10
    
        selectableView.delegate = self
        multiselectableView.delegate = self
        multiscrollselectableView.delegate = self
        
//        selectableView.selectedOption = BSSelectableOption(index: 0, title: "First title", identifier: "a")
        multiselectableView.selectedOptions = [BSSelectableOption(index: 0, title: "First title", identifier: "a"), BSSelectableOption(index: 1, title: "aaa", identifier: "b")]
    }
    
    func selectableOptionsForSelectableViewWithIdentifier(identifier: String) -> [BSSelectableOption] {
        
        return [
            BSSelectableOption(index: 0, title: "First title", identifier: "a"),
            BSSelectableOption(index: 1, title: "aaa", identifier: "b"),
            BSSelectableOption(index: 2, title: "Second Title", identifier: "c"),
            BSSelectableOption(index: 3, title: "bbb super dlugi name oleeeeee hello super dluhi jestem gosc ole oeoeoeoeoeoeoeooe oeoeo eoe oeoe eoeooe hhh", identifier: "d"),
            BSSelectableOption(index: 4, title: "ccc", identifier: "e"),
            BSSelectableOption(index: 5, title: "ddd", identifier: "f"),
            BSSelectableOption(index: 6, title: "ee e", identifier: "g"),
            BSSelectableOption(index: 7, title: "Second Title", identifier: "h"),
            BSSelectableOption(index: 8, title: "Second Title", identifier: "i"),
            BSSelectableOption(index: 9, title: "Second Title", identifier: "j"),
            BSSelectableOption(index: 10, title: "tttttt", identifier: "k"),
            BSSelectableOption(index: 11, title: "Second Title", identifier: "l"),
            BSSelectableOption(index: 12, title: "Second Title", identifier: "m"),
            BSSelectableOption(index: 13, title: "Second Title", identifier: "n"),
            BSSelectableOption(index: 14, title: "Second Title", identifier: "o")
        ]
    }
    
    func multiSelectableView(view: BSMultiSelectableView, tokenViewForOption option: BSSelectableOption, atIndex index: Int) -> UIView {
        
        let tokenView = NSBundle.mainBundle().loadNibNamed("BSSelectedTokenFieldView", owner: self, options: nil).first as! BSSelectedTokenFieldView
        tokenView.titleLabel.text = option.title
        tokenView.titleLabel.sizeToFit()
        tokenView.frame = CGRectMake(0, 0, min(tokenView.titleLabel.frame.size.width + 50, 200), 30)
        
        tokenView.performHandler = {
            
            view.options.append(option)
            view.selectedOptions.removeAtIndex(index)
        }
        
        return tokenView
    }
}
