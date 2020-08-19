//
//  MonthPresenter.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

protocol MonthPresenterCollectionViewPresenting {
    
    func numberOfCells(in section: Int) -> Int
    func didSelectCell(at row: Int) -> Void
    func data(at row: Int) -> DayRowItem?
    func compare(item: DayRowItem) -> Bool
    func compareMonthYear(item: DayRowItem) -> Bool
    
}

protocol MonthPresenterHeaderViewUpdating {
    
    func showNextMonth()
    func showPreviousMonth()
    func showCurrentMonth()
    
}

typealias MonthPresenting = MonthPresenterCollectionViewPresenting & MonthPresenterHeaderViewUpdating & PresenterLifecycle

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
    
}

extension MonthPresenter: MonthPresenterCollectionViewPresenting {
    
    func numberOfCells(in section: Int) -> Int {
        guard let count = monthModels.first?.days.count else { return 0 }
        return count
    }
    
    func data(at row: Int) -> DayRowItem? {
        if let monthDate = monthModels.first {
            
            let year = String(monthDate.year)
            let monthName = monthDate.monthName
            let monthNumber = monthDate.monthNumber
            
            let days = monthDate.days[row]
            let dayName = String(days.day)
            
            let user = days.isClient
            let isWorkday = days.isWorkDay
            return DayRowItem(year: year, month: monthName, day: dayName, monthNumber: monthNumber, client: user, isWorkday: isWorkday)
        }
        return nil
    }
    
    func compare(item: DayRowItem) -> Bool {
        guard let date = dateManager.getDateFrom(year: Int(item.year)!, month: item.monthNumber, day: Int(item.day)!) else {
            return false
        }
        return dateManager.compare(date: date)
    }
    
    func compareMonthYear(item: DayRowItem) -> Bool {
        guard let date = dateManager.getDateFrom(year: Int(item.year)!, month: item.monthNumber, day: Int(item.day)!) else {
            return false
        }
        return dateManager.compareMonthYear(date: date)
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
    
    func showCurrentMonth() {
        
        if monthModels.first == dateManager.showCurrentMonth().first {
            let item = dateManager.getValuesFromDate(date: Today.todayDate)
            let rowItem = DayRowItem(year: String(item.year), month: item.name, day: String(item.day), monthNumber: item.month, client: nil, isWorkday: nil)
            view.routeWithItem(item: rowItem)
        } else {
            monthModels = dateManager.showCurrentMonth()
        }
        view.reload()
        
    }
}
