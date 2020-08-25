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

protocol EntryViewPresenting {
    
    func currentDate() -> String?
    func showAlert()
    
}

typealias NewEntryViewable = EntryViewRoutable & EntryViewPresenting

class NewEntryVC: UIViewController {
    
    var pickerDate = Date()
    var date: String?
    
    @IBOutlet weak var clientTF: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker! {
        didSet {
            timePicker.datePickerMode = .time
        }
    }
    
    @IBOutlet weak var okButton: UIButton! {
        didSet {
            okButton.layer.cornerRadius = 25
            okButton.clipsToBounds = true
        }
    }
    
    lazy var presenter: EntryPresenting = EntryPresenter(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.load()
        
    }
    
    @IBAction func timePickerChanged(_ sender: UIDatePicker) {
        
        pickerDate = timePicker.date
        
    }
    
    @IBAction func okButtonPresssed(_ sender: UIButton) {
        
        let entryTime = pickerDate.timeString()
        presenter.addNewEntry(time: entryTime)
        
    }
}

extension NewEntryVC: EntryViewRoutable {
    
    func popToPrevVC() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

extension NewEntryVC: EntryViewPresenting {
    
    func currentDate() -> String? {
        
        return date
        
    }
    
    func showAlert() {
        
        let ac = UIAlertController(title: "Current entry already exist", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(action)
        self.present(ac, animated: true)
        
    }
    
}
