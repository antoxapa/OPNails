//
//  DateFunctions.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

final class DateManager {
    
    private var currentMonth: Date = Today.todayDate
    private var monthModel: [CalendarMonth] = []
    private var calendar: Calendar
    
    init() {
        
        calendar = Calendar.current
        fillMonthModel(fromDate: Today.todayDate)
        
    }
    
    func showCurrentMonth() -> [CalendarMonth] {
        
        currentMonth = Today.todayDate
        fillMonthModel(fromDate: Today.todayDate)
        return monthModel
        
    }
    
    func showMonth() -> [CalendarMonth] {
        
        return monthModel
        
    }
    
    func showNextMonth() -> [CalendarMonth] {
        
        getNextMonth()
        return monthModel
        
    }
    
    func showPreviousMonth() -> [CalendarMonth] {
        
        getPreviousMonth()
        return monthModel
        
    }
    
    func getDate(fromYear year: Int, month: Int, day: Int) -> Date? {
        
        let dateComponents = DateComponents(calendar: calendar, timeZone: .current,  year: year, month: month, day: day, hour: 0, minute: 0, second: 0, nanosecond: 0)
        if let date = calendar.date(from: dateComponents) {
            return date
        }
        return nil
        
    }
    
    func compareDate(_ date1: Date, to date2: Date) -> Bool {
        
        let order = calendar.compare(date1, to: date2, toGranularity: .day)
        switch order {
        case .orderedAscending:
            return false
        default:
            return true
        }
        
    }
    
    func getValues(from date: Date) -> (year: Int, month: Int, name: String, day: Int) {
        
        return date.getDateInfo()
        
    }
    
    func isToday(date: Date) -> Bool {
        
        return Today.todayDate.isSame(date)
        
    }
    
    func compareMonthYear(date: Date) -> Bool {
        
        let currentDate = Today.todayDate.getDateInfo()
        let currentYear = currentDate.year
        let currentMonth = currentDate.month
        
        let dateInfo = date.getDateInfo()
        let dateYear = dateInfo.year
        let dateMonth = dateInfo.month
        
        if (currentYear == dateYear) && (currentMonth == dateMonth) {
            return true
        }
        return false
        
    }
    
    private func fillMonthModel(fromDate date: Date) {
        
        monthModel = []
        let currentMonth = date.getDateInfo()
        let totalDaysInMonth = getNumberOfDaysInMonth(year: currentMonth.year, month: currentMonth.month)
        let days = createDaysArray(from: totalDaysInMonth, month: currentMonth.month, year: currentMonth.year)
        let weekDay = getMonthWeekDay(year: currentMonth.year, month: currentMonth.month)
        let skipCount = getSkipCount(weekDay, startDay: .monday)
        monthModel = [CalendarMonth(year: currentMonth.year, monthNumber: currentMonth.month, monthName: currentMonth.name, days: days, skipCount: skipCount)]
        
    }
    
    private func getMonthWeekDay(year: Int, month: Int) -> Int {
        
        let dateComponents = DateComponents(year: year, month: month)
        if let date = calendar.date(from: dateComponents) {
            let day = calendar.component(.weekday, from: date)
            return day
        }
        return 0
        
    }
    
    private func getSkipCount(_ weekDayNo: Int, startDay: WeekStartDay) -> Int {
        
        switch startDay {
        case .monday:
            return getCountForMonday(weekDayNo)
        case .sunday:
            return getCountForSunday(weekDayNo)
        }
        
    }
    
    private func getCountForMonday(_ weekDayNo: Int) -> Int {
        
        switch weekDayNo {
        case 1:
            return 6
        case 2...7:
            return weekDayNo - 2
        default:
            return 0
        }
        
    }
    
    private func getCountForSunday(_ weekDayNo: Int) -> Int {
        
        switch weekDayNo {
        case 1...7:
            return weekDayNo - 1
        default:
            return 0
        }
        
    }
    
    private func getNumberOfDaysInMonth(year: Int, month: Int) -> Int {
        
        let dateComponents = DateComponents(year: year, month: month)
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
    
    private func getPreviousMonth() {
        
        guard let prevMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) else { return }
        currentMonth = prevMonth
        fillMonthModel(fromDate: prevMonth)
        
    }
}
