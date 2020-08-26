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
    
    func currentDays() -> [DayRowItem]
    func currentDate() -> String?
    func showAlert()
    
}

typealias NewEntryViewable = EntryViewRoutable & EntryViewPresenting

class NewEntryVC: UIViewController {
    
    @IBOutlet weak var daysList: UILabel!
    var date: String?
    var pickerDate = Date()
    var days = [DayRowItem]()
    
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
        
        daysList.text = presenter.showdaysString(days: days)
        presenter.load()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.cancel()
        
    }
    
    @IBAction func timePickerChanged(_ sender: UIDatePicker) {
        
        pickerDate = timePicker.date
        
    }
    
    @IBAction func okButtonPresssed(_ sender: UIButton) {
        
        let entryTime = pickerDate.timeString()
        if days.count > 0 {
            presenter.addEntries(time: entryTime)
        } else {
            presenter.addNewEntry(time: entryTime)
        }
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
    
    func currentDays() -> [DayRowItem] {
        
        return days
        
    }
    
    func showAlert() {
        
        let ac = UIAlertController(title: "Current entry already exist", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(action)
        self.present(ac, animated: true)
        
    }
    
}
