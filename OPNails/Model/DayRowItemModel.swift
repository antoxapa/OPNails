//
//  DayRowItemModel.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/18/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

struct DayRowItem {
    
    let year: String
    let month: String
    let day: String
    let monthNumber: Int
    let client: OPUser?
    let isWorkday: Bool?
    
}

struct EntryRowItem {
    
    let date: String
    let time: String
    var user: OPUser?
    let isWorkday: Bool?
    
}
