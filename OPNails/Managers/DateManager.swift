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

public enum WeekStartDay {
    
    case monday
    case sunday
    
}

class DateManager {
    
    private var currentMonth: Date = Today.todayDate
    
    private var monthModel: [CalendarMonth] = []
    
    init() {
        
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
    
    func showPreviosMonth() -> [CalendarMonth] {
        
        getPrevMonth()
        return monthModel
        
    }
    
    func getDateFrom(year: Int, month: Int, day: Int) -> Date? {
        
        let dateComponents = DateComponents(year: year, month: month, day: day)
        let calendar = Calendar.current
        if let date = calendar.date(from: dateComponents) {
            return date
        }
        return nil
        
    }
    
    func getValuesFromDate(date: Date) -> (year: Int, month: Int, name: String, day: Int) {
        
        return date.getTodayValues()
        
    }
    
    func compare(date: Date) -> Bool {
        
        if Today.todayDate.isSame(date) {
            return true
        }
        
        return false
        
    }
    
    func compareMonthYear(date: Date) -> Bool {
        
        let currentDate = Today.todayDate.getMonth()
        let currentYear = currentDate.year
        let currentMonth = currentDate.month
        
        let dateInfo = date.getMonth()
        let dateYear = dateInfo.year
        let dateMonth = dateInfo.month
        
        if (currentYear == dateYear) && (currentMonth == dateMonth) {
            return true
        }
        
        return false
        
    }
    
    private func fillMonthModel(fromDate date: Date) {
        
        monthModel = []
        let currentMonth = date.getMonth()
        let totalDaysInMonth = getNumberOfDaysInMonth(year: currentMonth.year, month: currentMonth.month)
        let days = createDaysArray(from: totalDaysInMonth, month: currentMonth.month, year: currentMonth.year)
        let weekDay = getMonthWeekDay(year: currentMonth.year, month: currentMonth.month)
        let skipCount = getSkipCount(weekDay, startDay: .monday)
        monthModel = [CalendarMonth(year: currentMonth.year, monthNumber: currentMonth.month, monthName: currentMonth.name, days: days, skipCount: skipCount)]
        
    }
    
    private func getMonthWeekDay(year: Int, month: Int) -> Int {
        
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
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
    
    func getCountForMonday(_ weekDayNo: Int) -> Int {
        
        switch weekDayNo {
        case 1:
            return 6
        case 2:
            return 0
        case 3:
            return 1
        case 4:
            return 2
        case 5:
            return 3
        case 6:
            return 4
        case 7:
            return 5
        default:
            return 0
        }
        
    }
    
    func getCountForSunday(_ weekDayNo: Int) -> Int {
        
        switch weekDayNo {
        case 1:
            return 0
        case 2:
            return 1
        case 3:
            return 2
        case 4:
            return 3
        case 5:
            return 4
        case 6:
            return 5
        case 7:
            return 6
        default:
            return 0
        }
        
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
    
    func getTodayValues() -> (year: Int, month: Int, name: String, day: Int) {
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLL"
        let monthName = dateFormatter.string(from: self)
        let day = calendar.component(.day, from: self)
        return (year, month, monthName, day)
        
    }
    
    func isSame(_ date: Date?) -> Bool {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        guard let date = date else { return false }
        if formatter.string(from: self) == formatter.string(from: date) {
            return true
        }
        return false
        
    }
}

extension Date {
    
    func timeString() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
        
    }
    
}

