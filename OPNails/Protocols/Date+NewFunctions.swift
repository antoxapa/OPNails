//
//  Date+NewFunctions.swift
//  OPNails
//
//  Created by Антон Потапчик on 9/2/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

extension Date {
    
    func toLocalTime() -> Date {
        
        let timezone = TimeZone(abbreviation: "MSK")!
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
        
    }
    
    func getDateInfo() -> (year: Int, month: Int, name: String, day: Int) {
        
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
    
    func timeString() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
        
    }
    
}
