//
//  Presenter.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

protocol PresenterLifecycle {
    
    func setup()
    func load()
    func cancel()
    
}

protocol PresenterViewUpdating {
    
    func update()
    func showErrorAC(text: String)
    func dismissAC()
    
}
