//
//  UsersPresenter.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/29/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

protocol UsersPresenterTableViewPresenting {
    
    func numberOfCells(in section: Int) -> Int
    func data(at row: Int) -> OPUser?
    func didSelectCell(at row: Int) -> Void
    
}

protocol UsersPresentereRouting {
    
    func pop()
    
}

typealias UsersPresenting = UsersPresenterTableViewPresenting & UsersPresentereRouting & PresenterLifecycle & PresenterViewUpdating

final class UsersPresenter: PresenterLifecycle {
    
    private var fireManager: FirebaseManaging
    private weak var view: UsersViewable?
    private var users = [OPUser]()
    private var entry: EntryRowItem?
    
    init(view: UsersViewable) {
        
        self.view = view
        fireManager = FirebaseManager()
        
    }
    
    func setup() {
        
        entry = view?.returnEntry()
        
    }
    
    func load() {
        
        fireManager.downloadItems {
            self.update()
        }
        
    }
    
    func cancel() {
        
        fireManager.removeObservers()
        
    }
    
}

extension UsersPresenter: PresenterViewUpdating {
    
    func update() {
        
        users = fireManager.showUsers().filter { $0.uid != Constants.API.USER_ID  }
        view?.reload()
        
    }
    
    func showErrorAC(text: String) {
        
    }
    
    func dismissAC() {
        
    }
    
}

extension UsersPresenter: UsersPresenterTableViewPresenting {
    
    func numberOfCells(in section: Int) -> Int {
        
        return users.count
        
    }
    
    func data(at row: Int) -> OPUser? {
        
        let user = users[row]
        return user
        
    }
    
    func didSelectCell(at row: Int) {
        
        let user = users[row]
        guard let entry = entry else { return }
        fireManager.add(user: user, to: entry)
        pop()
        
    }
    
}

extension UsersPresenter: UsersPresentereRouting {
    
    func pop() {
        
        view?.pop()
        
    }
    
}

