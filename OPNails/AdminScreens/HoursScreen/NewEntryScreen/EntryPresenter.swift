//
//  EntryPresenter.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/19/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

protocol EntryRouting {
    func pop()
}

protocol EntryUpdating {
    //updates firebase
}

typealias EntryPresenting = EntryRouting & EntryUpdating

class EntryPresenter: PresenterLifecycle {
    
    private var view: NewEntryViewable
    
    init(view: NewEntryViewable) {
        self.view = view
    }
    
    func setup() {
        // init firebase
    }
    
}

extension EntryPresenter: EntryRouting {
    func pop() {
        view.popToPrevVC()
    }
}

extension EntryPresenter: EntryUpdating {
    
}
