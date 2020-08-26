//
//  HoursPresenter.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/18/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

protocol HoursPresenterTableViewPresenting {
    
    func numberOfCells(in section: Int) -> Int
    func data(at row: Int) -> EntryRowItem?
    func didSelectCell(at row: Int) -> Void
    
}

protocol HoursPresentereRouting {
    
    func presentDetailVC()
    
}

protocol PresenterViewUpdating {
    
    func update()
    
}

protocol PresenterModelUpdating {
    
    func setUserInEntry(index: Int)
    
}

typealias HoursPresenting = HoursPresenterTableViewPresenting & HoursPresentereRouting & PresenterLifecycle & PresenterViewUpdating & PresenterModelUpdating

class HoursPresenter: PresenterLifecycle, PresenterViewUpdating {
    
    private lazy var dataManager = DataManager(presenter: self)
    private var view: AdminHoursViewable
    var entries = [Entry]()
    var satisfEntries = [EntryRowItem]()
    var date: String = ""
    
    init(view: AdminHoursViewable) {
        
        self.view = view
        
    }
    
    func setup() {
        
        let day = view.presentDay()
        var workday = day.isWorkday
        date = "\(day.day)-\(day.monthNumber)-\(day.year)"
        satisfEntries = [EntryRowItem]()
        for entry in entries {
            if entry.date == date {
                workday = true
                let newEntry = EntryRowItem(date: date, time: entry.time, user: entry.userId, isWorkday: workday)
                satisfEntries.append(newEntry)
            }
        }
        
    }
    
    func load() {
        
        dataManager.downloadItems()
        dataManager.checkCurrentUser()
        
    }
    
    func cancel() {
        
        dataManager.removeObservers()
        
    }
    
    func update() {
        
        entries = dataManager.showEntries()
        setup()
        view.reload()
        
    }
    
}

extension HoursPresenter: HoursPresenterTableViewPresenting {
    
    func numberOfCells(in section: Int) -> Int {
        
        return satisfEntries.count
        
    }
    
    func data(at row: Int) -> EntryRowItem? {
        
        return satisfEntries[row]
        
    }
    
    func didSelectCell(at row: Int) {
        
        view.showSignInEntryUserAC(index: row)
        
    }
}

extension HoursPresenter: HoursPresentereRouting {
    
    func presentDetailVC() {
        
        view.showDetail()
        
    }

}

extension HoursPresenter: PresenterModelUpdating {
    
    func setUserInEntry(index: Int) {

        let entry = satisfEntries[index]
        dataManager.updateEntryWithUser(entry: entry)
        dataManager.downloadItems()
        
    }
    
}
