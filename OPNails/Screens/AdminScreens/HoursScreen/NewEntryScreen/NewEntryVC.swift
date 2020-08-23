//
//  NewEntryVC.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/18/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

protocol EntryViewRoutable {
    func popToPrevVC()
}

typealias NewEntryViewable = EntryViewRoutable

class NewEntryVC: UIViewController {
    
    @IBOutlet weak var clientTF: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var okButton: UIButton! {
        didSet {
            okButton.layer.cornerRadius = 25
            okButton.clipsToBounds = true
        }
    }
    
    lazy var presenter: EntryPresenting = EntryPresenter(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func okButtonPresssed(_ sender: UIButton) {
        presenter.pop()
    }
}

extension NewEntryVC: EntryViewRoutable {
    func popToPrevVC() {
        self.dismiss(animated: true) {
            
        }
    }
}
