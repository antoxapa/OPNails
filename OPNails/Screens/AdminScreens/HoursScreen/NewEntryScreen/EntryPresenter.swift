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
    
}
