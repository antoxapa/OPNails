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
    
    func pop(user: OPUser)
    
}

typealias UsersPresenting = UsersPresenterTableViewPresenting & UsersPresentereRouting  & PresenterLifecycle & PresenterViewUpdating

class UsersPresenter: PresenterLifecycle, PresenterViewUpdating {
    
    private lazy var dataManager = DataManager(presenter: self)
    private var view: UsersViewable
    private var users = [OPUser]()
    
    init(view: UsersViewable) {
        
        self.view = view
        
    }
    
    func setup() {
        
        
    }
    
    func load() {
        
        dataManager.downloadUsers()
        
    }
    
    func cancel() {
        
        dataManager.removeObservers()
        
    }
    
    func update() {
        
        users = dataManager.showUsers()
        users.removeAll { (user) -> Bool in
            user.email == "antoxapa@gmail.com"
        }
        view.reload()
        
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
        
        pop(user: users[row])
        
    }
    
}

extension UsersPresenter: UsersPresentereRouting {
    
    func pop(user: OPUser) {
        
        view.pop(user: user)
        
    }
    
}

