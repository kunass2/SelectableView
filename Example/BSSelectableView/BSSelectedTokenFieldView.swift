//
//  BSSelectedTokenFieldView.swift
//  Pods
//
//  Created by Bartłomiej Semańczyk on 23/06/16.
//
//

class BSSelectedTokenFieldView: UIView {
    
    @IBOutlet var titleLabel: UILabel!
    
    var performHandler: (() -> ())?
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    @IBAction func removeButtonTapped(sender: UIButton) {
        performHandler?()
    }
    
    //MARK: - Public
    
    //MARK: - Internal
    
    //MARK: - Private
    
    //MARK: - Overridden
}
