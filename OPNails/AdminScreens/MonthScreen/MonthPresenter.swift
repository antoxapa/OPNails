//
//  MonthPresenter.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

struct DayRowItem {
    let year: String
    let month: String
    let day: String
    
    let monthNumber: Int
    let client: String?
    let isWorkday: Bool?
}

protocol MonthPresenterCollectionViewPresenting {
    
    func numberOfCells(in section: Int) -> Int
    func didSelectCell(at row: Int) -> Void
    func data(at row: Int) -> DayRowItem?
    
}

protocol MonthPresenterHeaderViewUpdating {
    
    func showNextMonth()
    func showPreviousMonth()
    
}

class MonthPresenter: PresenterLifecycle {
    
    private var view: AdminMonthViewable
    private var header: HeaderMonthViewUpdatable?
    private var dateManager: DateManager
    private var monthModels: [CalendarMonth]
    
    init(view: AdminMonthViewable) {
        self.view = view
        self.dateManager = DateManager()
        self.monthModels = []
    }
    
    func setup() {
        monthModels = dateManager.showMonth()
    }
    
    func load() {
        
    }
    
}

extension MonthPresenter: MonthPresenterCollectionViewPresenting {
    
    func numberOfCells(in section: Int) -> Int {
        guard let count = monthModels.first?.days.count else { return 0 }
        return count
    }
    
    func data(at row: Int) -> DayRowItem? {
        if let monthDate = monthModels.first {
            let year = String(monthDate.year)
            let days = monthDate.days[row]
            let monthName = monthDate.monthName
            let monthNumber = monthDate.monthNumber
            let dayName = String(days.day)
            let user = days.isClient
            let isWorkday = days.isWorkDay
            return DayRowItem(year: year, month: monthName, day: dayName, monthNumber: monthNumber, client: user, isWorkday: isWorkday)
        }
        return nil
    }
    
    func didSelectCell(at row: Int) {
        
        guard let day = data(at: row) else { return }
        
        openDayTimesList(withItem: day)
    }
}

extension MonthPresenter {
    
    private func openDayTimesList(withItem item: DayRowItem) {
        view.routeWithItem(item: item)
    }
}

extension MonthPresenter: MonthPresenterHeaderViewUpdating {
    
    func showNextMonth() {
        
        monthModels = dateManager.showNextMonth()
        view.reload()
        
    }
    
    func showPreviousMonth() {
        
        monthModels = dateManager.showPreviosMonth()
        view.reload()
        
    }
}
