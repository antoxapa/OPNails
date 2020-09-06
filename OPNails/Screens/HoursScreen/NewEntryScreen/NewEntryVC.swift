//
//  NewEntryVC.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/18/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

protocol EntryViewRoutable: AnyObject {
    
    func popToPrevVC()
    
}

protocol EntryViewPresenting: AnyObject {
    
    func currentDays() -> [DayRowItem]
    func currentDate() -> String?
    func showErrorAC(title: String?, message: String?)
    
}

typealias NewEntryViewable = EntryViewRoutable & EntryViewPresenting

class NewEntryVC: UIViewController {
    
    @IBOutlet weak var selectedDaysLabel: UILabel!
    @IBOutlet weak var daysList: UILabel!
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
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.layer.cornerRadius = 25
            cancelButton.clipsToBounds = true
        }
    }
    
    var date: String?
    var pickerDate = Date()
    var days = [DayRowItem]()
    lazy var presenter: EntryPresenting = EntryPresenter(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        daysList.text = presenter.showdaysString(days: days)
        presenter.load()
        
        localizeViews()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.cancel()
        
    }
    
    private func localizeViews() {
        
        selectedDaysLabel.text = i18n.selectedDays_title
        okButton.setTitle(i18n.buttonOk, for: .normal)
        cancelButton.setTitle(i18n.buttonCancel, for: .normal)
        
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
            presenter.postNotification(info: nil)
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        presenter.pop()
        
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
    
    func showErrorAC(title: String?, message: String?) {
        
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: i18n.buttonOk, style: .default, handler: nil)
        ac.addAction(action)
        self.present(ac, animated: true)
        
    }
    
}


