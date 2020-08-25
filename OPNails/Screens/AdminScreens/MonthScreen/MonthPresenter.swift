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
    func skipCount() -> Int
    
}

protocol MonthPresenterHeaderViewUpdating {
    
    func showNextMonth()
    func showPreviousMonth()
    func showCurrentMonth()
    func reloadView()
    func addNewEntries(forDays days: [IndexPath])
    
}

typealias MonthPresenting = MonthPresenterCollectionViewPresenting & MonthPresenterHeaderViewUpdating & PresenterLifecycle & PresenterViewUpdating

class MonthPresenter: PresenterLifecycle, PresenterViewUpdating {
    
    private var view: MonthViewable
    private var header: HeaderMonthViewUpdatable?
    private var dateManager: DateManager
    lazy private var dataManager = DataManager(presenter: self)
    private var monthModels: [CalendarMonth]
    private var entries: [Entry]?
    
    init(view: MonthViewable) {
        
        self.view = view
        dateManager = DateManager()
        monthModels = []
        
    }
    
    func setup() {
        
        monthModels = dateManager.showMonth()
        view.reload()
        
    }
    
    func load() {
        
        dataManager.downloadItems()
        
    }
    
    func update() {
        
        entries = dataManager.showEntries()
        view.reload()
        
    }
    
}

extension MonthPresenter: MonthPresenterCollectionViewPresenting {
    
    func numberOfCells(in section: Int) -> Int {
        
        guard let count = monthModels.first?.days.count else { return 0 }
        guard let skipCount = monthModels.first?.skipCount else { return 0 }
        return count + skipCount
        
    }
    
    func data(at row: Int) -> DayRowItem? {
        
        if row < 0 {
            return nil
        }
        if let monthDate = monthModels.first {
            let year = String(monthDate.year)
            let monthName = monthDate.monthName
            let monthNumber = monthDate.monthNumber
            let days = monthDate.days[row]
            let dayName = String(days.day)
            var isWorkday = days.isWorkDay
            let user = days.isClient
            
            if entries != nil {
                let date = "\(dayName)-\(monthNumber)-\(year)"
                for entry in entries! {
                    if entry.date == date {
                        isWorkday = true
                    }
                }
            }
            
            return DayRowItem(year: year, month: monthName, day: dayName, monthNumber: monthNumber, client: user, isWorkday: isWorkday)
        }
        return nil
        
    }
    
    func skipCount() -> Int {
        
        if let monthDate = monthModels.first {
            let skipCount = monthDate.skipCount
            return skipCount
        }
        return 0
        
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
    
    func reloadView() {
        
        view.reload()
        
    }
    
    func addNewEntries(forDays indexPaths: [IndexPath]) {
        
        var items = [DayRowItem]()
        if let month = monthModels.first {
            for index in indexPaths {
                let year = String(month.year)
                let monthName = month.monthName
                let monthNumber = month.monthNumber
                let newIndex = index.row - skipCount()
                let days = month.days[newIndex]
                let dayName = String(days.day)
                let isWorkday = days.isWorkDay
                let user = days.isClient
                
                let dayRowItem = DayRowItem(year: year, month: monthName, day: dayName, monthNumber: monthNumber, client: user, isWorkday: isWorkday)
                items.append(dayRowItem)
            }
        }
        view.routeWithItems(items: items)
        
    }
    
}
