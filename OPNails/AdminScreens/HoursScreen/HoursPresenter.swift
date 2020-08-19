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

typealias HoursPresenting = HoursPresenterTableViewPresenting & HoursPresentereRouting & PresenterLifecycle

class HoursPresenter: PresenterLifecycle {
    
    private var view: AdminHoursViewable
    
    init(view: AdminHoursViewable) {
        self.view = view
    }
    
    func setup() {
        
    }
}

extension HoursPresenter: HoursPresenterTableViewPresenting {
    func numberOfCells(in section: Int) -> Int {
        return 0
    }
    
}

extension HoursPresenter: HoursPresentereRouting {
    func presentDetailVC() {
        view.showDetail()
    }
}
