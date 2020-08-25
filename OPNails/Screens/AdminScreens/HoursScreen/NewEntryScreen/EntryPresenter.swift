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
    //updates firebase
    func addNewEntry(time: String)

}

typealias EntryPresenting = EntryRouting & EntryUpdating

class EntryPresenter: PresenterLifecycle, PresenterViewUpdating {
    
    func update() {
        
    }
    
    
    private var view: NewEntryViewable
    lazy private var dataManager: DataManager = DataManager(presenter: self)
    
    init(view: NewEntryViewable) {
        self.view = view
        setup()
    }
    
    func setup() {
        
        dataManager.checkCurrentUser()
        
    }
    
    func load() {
        
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
        dataManager.addNewEntry(date: date , time: time)
        
    }
    
    func checkEntryAlreadyExist(time: String) {
        
        
        
    }
    
}
