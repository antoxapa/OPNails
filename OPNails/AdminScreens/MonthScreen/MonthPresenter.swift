//
//  MonthPresenter.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

struct DayRowItem {
    let month: String
    let day: String
    let client: String?
    let isWorkday: Bool?
}

protocol MonthPresenterCollectionViewPresenting {

    func numberOfCells(in section: Int) -> Int
    func didSelectCell(in section: Int, at row: Int) -> Void
    func data(at row: Int) -> DayRowItem?
    
}

class MonthPresenter: PresenterLifecycle {
    
    private var view: AdminMonthViewUpdatable?
    private var dateManager: DateManager
    private var monthModels: [CalendarMonth]
    
    init(view: AdminMonthViewUpdatable) {
        self.view = view
        self.dateManager = DateManager()
        self.monthModels = []
    }
    
    func setup() {
    }
    
    func load() {
        monthModels = dateManager.showMonth()
    }
    
}

extension MonthPresenter: MonthPresenterCollectionViewPresenting {
    
    func numberOfCells(in section: Int) -> Int {
        guard let count = monthModels.first?.days.count else { return 0 }
        return count
    }
    
    func data(at row: Int) -> DayRowItem? {
        if let month = monthModels.first {
            let day = month.days[row]
            let month = month.monthName
            let dayName = String(day.day)
            let user = day.isClient
            let isWorkday = day.isWorkDay
            return DayRowItem(month: month, day: dayName, client: user, isWorkday: isWorkday)
        }
        return nil
    }
    
    func didSelectCell(in section: Int, at row: Int) {
        
    }
}
