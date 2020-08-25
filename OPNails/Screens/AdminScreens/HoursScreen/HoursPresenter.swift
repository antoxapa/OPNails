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
    
}

protocol HoursPresentereRouting {
    
    func presentDetailVC()
    
}

protocol PresenterViewUpdating {
    
    func update()
    
}

typealias HoursPresenting = HoursPresenterTableViewPresenting & HoursPresentereRouting & PresenterLifecycle & PresenterViewUpdating

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
}

extension HoursPresenter: HoursPresentereRouting {
    
    func presentDetailVC() {
        
        view.showDetail()
        
    }
}
