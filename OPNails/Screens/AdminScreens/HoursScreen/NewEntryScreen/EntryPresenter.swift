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

protocol EntryUpdating {
    
    func addNewEntry(time: String)
    func addEntries(time: String)
    func showdaysString(days: [DayRowItem]) -> String
    
}

typealias EntryPresenting = EntryRouting & EntryUpdating & PresenterLifecycle

class EntryPresenter: PresenterLifecycle, PresenterViewUpdating {
    
    private var view: NewEntryViewable
    lazy private var dataManager: DataManager = DataManager(presenter: self)
    var entries = [Entry]()
    
    init(view: NewEntryViewable) {
        
        self.view = view
        setup()
        
    }
    
    func setup() {
        
        dataManager.checkCurrentUser()
        
    }
    
    func load() {
        
        dataManager.downloadItems()
        
    }
    
    func cancel() {
        
        dataManager.removeObservers()
        
    }
    
    func update() {
        
        entries = dataManager.showEntries()
        
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
        for entry in entries {
            if entry.date == date && entry.time == time {
                view.showAlert()
                return
            }
        }
        dataManager.addNewEntry(date: date , time: time)
        pop()
        
    }
    
    func addEntries(time: String) {
        
        let days = view.currentDays()
        for day in days {
            let date = "\(day.day)-\(day.monthNumber)-\(day.year)"
            for entry in entries {
                if entry.date == date && entry.time == time {
                    view.showAlert()
                    return
                }
                
            }
            
            dataManager.addNewEntry(date: date, time: time)
        }
        pop()
    }
    
    func showdaysString(days: [DayRowItem]) -> String {
        var daysString = ""
        var daysArray = [String]()
        for day in days {
            daysArray.append(day.day)
        }
        for item in daysArray.sorted() {
            daysString += "\(item), "
        }
        return daysString
    }
    
}
