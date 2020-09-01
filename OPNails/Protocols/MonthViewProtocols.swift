//
//  MonthViewProtocols.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/22/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

protocol MonthViewUpdatable {
    
    func reload()
    func reloadItemAt(indexPath: [IndexPath]?)
    
}

protocol MonthViewRoutable {
    
    func routeWithItem(item: DayRowItem)
    func routeWithItems(items days: [DayRowItem])
    
}

protocol MonthViewPresentable {
    
    func showErrorAC(text: String)
    
}

typealias MonthViewable = MonthViewUpdatable & MonthViewRoutable & MonthViewPresentable
