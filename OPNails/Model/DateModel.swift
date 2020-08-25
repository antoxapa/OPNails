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

struct CalendarMonth: Equatable {
    
    var monthName: String
    var monthNumber: Int
    var year: Int
    var days: [CalendarDay] = [CalendarDay]()
    var skipCount: Int
    
    init(year: Int, monthNumber: Int, monthName: String, days: [CalendarDay], skipCount: Int) {
        
        self.year = year
        self.monthNumber = monthNumber
        self.monthName = monthName
        self.days = days
        self.skipCount = skipCount
        
    }
    
    static func == (lhs: CalendarMonth, rhs: CalendarMonth) -> Bool {
        
        return lhs.monthName == rhs.monthName && lhs.year == rhs.year
        
    }
    
}


