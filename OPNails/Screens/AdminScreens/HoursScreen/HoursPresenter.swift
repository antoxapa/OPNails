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
    
}

protocol HoursPresentereRouting {
    
    func presentDetailVC()
    
}

protocol PresenterViewUpdating {
    
    func update(with entries: [Entry])
    
}

typealias HoursPresenting = HoursPresenterTableViewPresenting & HoursPresentereRouting & PresenterLifecycle & PresenterViewUpdating

class HoursPresenter: PresenterLifecycle, PresenterViewUpdating {
    
    private lazy var dataManager = DataManager(presenter: self)
    private var view: AdminHoursViewable
    var entries = [Entry]()
    
    init(view: AdminHoursViewable) {
        
        self.view = view
        setup()
        
    }
    
    func setup() {
        
        dataManager.downloadItems()
        
    }
    
    func update(with entries: [Entry]) {
        
        self.entries = entries
        view.reload()
        
    }
    
}

extension HoursPresenter: HoursPresenterTableViewPresenting {
    
    func numberOfCells(in section: Int) -> Int {
        
        return entries.count
        
    }
    
}

extension HoursPresenter: HoursPresentereRouting {
    
    func presentDetailVC() {
        
        view.showDetail()
        
    }
}
