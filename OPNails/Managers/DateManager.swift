//
//  DateFunctions.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

public struct Today {
    public static let todayDate = Date()
}

class DateManager {
    
    private var currentMonth: Date = Today.todayDate
    
    private var monthModel: [CalendarMonth] = []
    
    init() {
        fillMonthModel(fromDate: Today.todayDate)
    }
    
    func showMonth() -> [CalendarMonth] {
        
        return monthModel
        
    }
    
    func showNextMonth() -> [CalendarMonth] {
        
        getNextMonth()
        return monthModel
        
    }
    
    func showPreviosMonth() -> [CalendarMonth] {
        
        getPrevMonth()
        return monthModel
        
    }
    
    private func fillMonthModel(fromDate date: Date) {
        monthModel = []
        let currentMonth = date.getMonth()
        let totalDaysInMonth = getNumberOfDaysInMonth(year: currentMonth.year, month: currentMonth.month)
        let days = createDaysArray(from: totalDaysInMonth, month: currentMonth.month, year: currentMonth.year)
        monthModel = [CalendarMonth(year: currentMonth.year, monthNumber: currentMonth.month, monthName: currentMonth.name, days: days)]
    }
    
    private func getNumberOfDaysInMonth(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        if let date = calendar.date(from: dateComponents), let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: date) {
            return numberOfDaysInMonth.count
        }
        return 0
    }
    
    private func createDaysArray(from days: Int, month: Int, year: Int) -> [CalendarDay] {
        var dayArray = [CalendarDay]()
        for i in 1...days {
            dayArray.append(CalendarDay(day: i))
        }
        return dayArray
    }
    
    private func getNextMonth() {
        
        guard let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) else { return }
        currentMonth = nextMonth
        fillMonthModel(fromDate: nextMonth)
        
    }
    
    private func getPrevMonth() {
        guard let prevMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) else { return }
        currentMonth = prevMonth
        fillMonthModel(fromDate: prevMonth)
        
    }
}


// MARK: - Date extension
extension Date {
    
    func getMonth() -> (year: Int, month: Int, name: String) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLL"
        let monthName = dateFormatter.string(from: self)
        return (year, month, monthName)
    }
    //
    //    func getEventInfo() -> (year: Int, month: Int, day: Int) {
    //        let calendar = Calendar.current
    //        let year = calendar.component(.year, from: self)
    //        let month = calendar.component(.month, from: self)
    //        let day = calendar.component(.day, from: self)
    //        return (year, month, day)
    //    }
    //
    //    func isSame(_ date: Date?) -> Bool {
    //        let formatter = DateFormatter()
    //        formatter.dateFormat = "ddMMyyyy"
    //        guard let date = date else { return false }
    //        if formatter.string(from: self) == formatter.string(from: date) {
    //            return true
    //        }
    //        return false
    //    }
}
