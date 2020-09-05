//
//  MonthViewProtocols.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/22/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation
import UIKit

protocol MonthViewUpdatable: AnyObject {
    
    func reload()
    func reloadItemAt(indexPath: [IndexPath]?)
    
}

protocol MonthViewRoutable: AnyObject {
    
    func routeWithItem(item: DayRowItem)
    func routeWithItems(items days: [DayRowItem])
    func showPriceList()
    
}

protocol MonthViewPresentable: AnyObject {
    
    func showErrorAC(text: String)
    
}

typealias MonthViewable = MonthViewUpdatable & MonthViewRoutable & MonthViewPresentable
