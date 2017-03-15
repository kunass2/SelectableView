//
//  SelectedTokenFieldView.swift
//  Pods
//
//  Created by Bartłomiej Semańczyk on 23/06/16.
//
//

class SelectedTokenFieldView: UIView {
    
    @IBOutlet var titleLabel: UILabel!
    
    var performHandler: (() -> ())?
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    @IBAction func removeButtonTapped(sender: UIButton) {
        performHandler?()
    }
    
    //MARK: - Open
    
    //MARK: - Internal
    
    //MARK: - Private
    
    //MARK: - Overridden
}
