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
    func checkDayAvailable(item: DayRowItem) -> Bool
    func checkClientEntryDay(item: DayRowItem) -> Bool
    
}

protocol MonthPresenterHeaderViewUpdating {
    
    func showNextMonth()
    func showPreviousMonth()
    func showCurrentMonth()
    func reloadView()
    func addNewEntries(forDays days: [IndexPath])
    
}

typealias MonthPresenting = MonthPresenterCollectionViewPresenting & MonthPresenterHeaderViewUpdating & PresenterLifecycle & PresenterViewUpdating

class MonthPresenter: PresenterLifecycle {
    
    private var view: MonthViewable
    private var header: HeaderMonthViewUpdatable?
    private var dateManager: DateManager
    lazy private var fireManager = FirebaseManager(presenter: self)
    private var monthModels: [CalendarMonth]
    private var entries: [Entry]?
    private var users: [OPUser]?
    
    init(view: MonthViewable) {
        
        self.view = view
        dateManager = DateManager()
        monthModels = []
        
    }
    
    func setup() {
        
        self.fireManager.reloadCurrentUser()
        monthModels = dateManager.showMonth()
        view.reload()
        
    }
    
    func load() {
        
        fireManager.downloadItems()
        
    }
    
    func cancel() {
        
        fireManager.removeObservers()
        
    }
    
}

extension MonthPresenter: PresenterViewUpdating {
    
    func update() {
        
        entries = fireManager.showEntries()
        users = fireManager.showUsers()
        view.reload()
        
    }
    
    func showErrorAC(text: String) {
        
        view.showErrorAC(text: text)
        
    }
    
    func dismissAC() {
        
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
            var user: OPUser? = nil
            
            if entries != nil {
                let date = "\(dayName)-\(monthNumber)-\(year)"
                for entry in entries! {
                    guard entry.date == date else { continue }
                    isWorkday = true
                    guard let item = fireManager.getEntryUser(entry: entry),
                        entry.userId == fireManager.returnCurrentUser()?.uid else { continue }
                    user = item
                    isWorkday = false
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
        
        guard let date = dateManager.getDate(fromYear: Int(item.year)!, month: item.monthNumber, day: Int(item.day)!) else {
            return false
        }
        return dateManager.isToday(date: date)
        
    }
    
    func compareMonthYear(item: DayRowItem) -> Bool {
        
        guard let date = dateManager.getDate(fromYear: Int(item.year)!, month: item.monthNumber, day: Int(item.day)!) else {
            return false
        }
        return dateManager.compareMonthYear(date: date)
        
    }
    
    func didSelectCell(at row: Int) {
        
        guard let day = data(at: row) else { return }
        openDayTimesList(withItem: day)
        
    }
    
    func checkClientEntryDay(item: DayRowItem) -> Bool {
        
        return item.client?.uid == fireManager.returnCurrentUser()?.uid
        
    }
    
    func checkDayAvailable(item: DayRowItem) -> Bool {
        
        if let date = dateManager.getDate(fromYear: Int(item.year)!, month: item.monthNumber, day: Int(item.day)!) {
            let localDate = date.toLocalTime()
            return dateManager.compareDate(localDate, to: Today.todayDate)
        }
        return false
        
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
        
        monthModels = dateManager.showPreviousMonth()
        view.reload()
        
    }
    
    func showCurrentMonth() {
        
        if monthModels.first == dateManager.showCurrentMonth().first {
            let item = dateManager.getValues(from: Today.todayDate)
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
                let user: OPUser? = nil
                
                let dayRowItem = DayRowItem(year: year, month: monthName, day: dayName, monthNumber: monthNumber, client: user, isWorkday: isWorkday)
                items.append(dayRowItem)
            }
        }
        view.routeWithItems(items: items)
        
    }
    
}
