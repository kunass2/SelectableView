//
//  ViewController.swift
//  SelectableView
//
//  Created by Bartłomiej Semańczyk on 06/22/2016.
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

class ViewController: UIViewController, SelectableViewDelegate {
    
    @IBOutlet var selectableView: SingleSelectableView!
    @IBOutlet var multiselectableView: MultiSelectableView!
    @IBOutlet var multiscrollselectableView: MultiSelectableView!
    @IBOutlet var searchselectableView: SearchSelectableView!
    
    private var options = [
        SelectableOption(index: 0, title: "First title", identifier: "a"),
        SelectableOption(index: 1, title: "aaa", identifier: "b"),
        SelectableOption(index: 2, title: "Second Title", identifier: "c"),
        SelectableOption(index: 3, title: "bbb super dlugi name oleeeeee hello super dluhi jestem gosc ole oeoeoeoeoeoeoeooe oeoeo eoe oeoe eoeooe hhh", identifier: "d"),
        SelectableOption(index: 4, title: "ccc", identifier: "e"),
        SelectableOption(index: 5, title: "ddd", identifier: "f"),
        SelectableOption(index: 6, title: "ee e", identifier: "g"),
        SelectableOption(index: 7, title: "Second Title", identifier: "h"),
        SelectableOption(index: 8, title: "Second Title", identifier: "i"),
        SelectableOption(index: 9, title: "Second Title", identifier: "j"),
        SelectableOption(index: 10, title: "tttttt", identifier: "k"),
        SelectableOption(index: 11, title: "Second Title", identifier: "l"),
        SelectableOption(index: 12, title: "Second Title", identifier: "m"),
        SelectableOption(index: 13, title: "Second Title", identifier: "n"),
        SelectableOption(index: 14, title: "Second Title", identifier: "o")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        selectableView.options = options
        selectableView.delegate = self
        
        multiselectableView.delegate = self
        multiselectableView.options = options
        
        multiscrollselectableView.options = options
        multiscrollselectableView.delegate = self
        
//        selectableView.selectedOption = SelectableOption(index: 0, title: "First title", identifier: "a")
        multiselectableView.selectedOptions = [options[0], options[2]]
        
        searchselectableView.options = options
        searchselectableView.delegate = self
    }
    
    func multiSelectableView(_ view: MultiSelectableView, tokenViewFor option: SelectableOption) -> UIView {
        
        let tokenView = Bundle.main.loadNibNamed("SelectedTokenFieldView", owner: self, options: nil)?.first as! SelectedTokenFieldView
        tokenView.titleLabel.text = option.title
        tokenView.titleLabel.sizeToFit()
        tokenView.frame = CGRect(x: 0, y: 0, width: min(tokenView.titleLabel.frame.size.width + 50, 200), height: 30)
        
        tokenView.performHandler = {
            view.deselect(option: option)
        }
        
        return tokenView
    }
}
