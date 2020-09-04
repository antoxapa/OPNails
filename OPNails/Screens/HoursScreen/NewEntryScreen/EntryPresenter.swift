//
//  EntryPresenter.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/19/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

protocol EntryRouting {
    
    func pop()
    
}

protocol PresenterViewNotificationSending {
    
    func postNotification(info: [String:AnyObject]?)
    
}

protocol EntryUpdating {
    
    func addNewEntry(time: String)
    func addEntries(time: String)
    func showdaysString(days: [DayRowItem]) -> String
    
}

typealias EntryPresenting = EntryRouting & EntryUpdating & PresenterLifecycle & PresenterViewNotificationSending

final class EntryPresenter: PresenterLifecycle {
    
    private var view: NewEntryViewable
    private var fireManager: FirebaseManaging
    var entries = [Entry]()
    
    init(view: NewEntryViewable) {
        
        self.view = view
        fireManager = FirebaseManager()
        setup()
        
    }
    
    func setup() {
        
        fireManager.updateCurrentUser()
        
    }
    
    func load() {
        
        fireManager.downloadItems {
            self.update()
        }
        
    }
    
    func cancel() {
        
        fireManager.removeObservers()
        
    }
    
}

extension EntryPresenter: PresenterViewUpdating {
    
    func update() {
        
        entries = fireManager.showEntries()
        
    }
    
    func showErrorAC(text: String) {
        
        
    }
    
    func dismissAC() {
        
    }
    
}

extension EntryPresenter: EntryRouting {
    
    func pop() {
        
        view.popToPrevVC()
        
    }
    
}

extension EntryPresenter: EntryUpdating {
    
    func addNewEntry(time: String) {
        
        guard let date = view.currentDate() else { return }
        if entries.contains(where: { $0.date == date && $0.time == time }) {
            let title = "Current entry already exist"
            view.showErrorAC(title: title, message: nil)
            return
        }
        fireManager.addNewEntry(date: date , time: time)
        pop()
        
    }
    
    func addEntries(time: String) {
        
        let days = view.currentDays()
        for day in days {
            let date = "\(day.day)-\(day.monthNumber)-\(day.year)"
            if entries.contains(where: { $0.date == date && $0.time == time }) {
                let title = "Current entry already exist"
                view.showErrorAC(title: title, message: nil)
                return
            }
            fireManager.addNewEntry(date: date, time: time)
        }
        pop()
        
    }
    
    func showdaysString(days: [DayRowItem]) -> String {
        
        var daysString = ""
        var daysArray = [String]()
        for day in days {
            daysArray.append(day.day)
        }
        daysString = daysArray.sorted().joined(separator: ", ")
        return daysString
        
    }
    
}

extension EntryPresenter: PresenterViewNotificationSending {
    
    func postNotification(info: [String : AnyObject]?) {
        
        NotificationCenter.default.post(name: .entriesEdited, object: nil)
        
    }
    
}
