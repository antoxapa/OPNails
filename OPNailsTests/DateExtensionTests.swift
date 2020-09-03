//
//  DateExtensionTests.swift
//  OPNailsTests
//
//  Created by Антон Потапчик on 9/2/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import XCTest
@testable import OPNails


class DateExtensionTests: XCTestCase {
    
    var date: Date!
    
    override func setUp() {
        super.setUp()
        
        date = Date(timeIntervalSinceReferenceDate: 100)
        
    }
    
    override func tearDown() {
        
        date = nil
        super.tearDown()
        
    }
    
    func testDateConvertToLocalTime() {
        
        let newDate = date.toLocalTime()
        let correctDateInterval = date.addingTimeInterval(60*60*3)
        
        XCTAssertEqual(newDate, correctDateInterval)
        
    }
    
    func testGetDateInfo() {
        
        let year = 2001
        let month = 1
        let monthName = "Jan"
        
        let monthInfo = date.getDateInfo()
        
        XCTAssertEqual(year, monthInfo.year)
        XCTAssertEqual(month, monthInfo.month)
        XCTAssertEqual(monthName, monthInfo.name)
        
    }
    
    func testDateIsSameToDate() {
        
        let same = date.isSame(date)
        
        XCTAssertTrue(same)
        
        let newDate = Date(timeIntervalSince1970: 100)
        let different = date.isSame(newDate)
        
        XCTAssertFalse(different)
        
    }
    
    func testGetHoursAndMinutes() {
        
        
        //        this method should return time from Date with default locale , when print date we will get another time locale and this way we cant check it with "print", but dates will be same at all
        
        let time = date.timeString()
        let resultTime = "02:01"
        
        XCTAssertEqual(time, resultTime)
        
    }
    
}
