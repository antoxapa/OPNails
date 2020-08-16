//
//  MonthModel+DayModel.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

struct CalendarDay {
    var day: Int
    var isClient: String?
    var isWorkDay: Bool?
    
    init(day: Int) {
        self.day = day
    }
}

struct CalendarMonth {
    var monthName: String
    var monthNumber: Int
    var year: Int
    var days: [CalendarDay] = [CalendarDay]()
    
    init(year: Int, monthNumber: Int, monthName: String, days: [CalendarDay]) {
        self.year = year
        self.monthNumber = monthNumber
        self.monthName = monthName
        self.days = days
    }
}


