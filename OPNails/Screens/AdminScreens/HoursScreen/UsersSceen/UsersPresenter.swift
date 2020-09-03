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

typealias UsersPresenting = UsersPresenterTableViewPresenting & UsersPresentereRouting & PresenterLifecycle & PresenterViewUpdating & PresenterViewNotificationSending

class UsersPresenter: PresenterLifecycle {
    
    private lazy var fireManager = FirebaseManager(presenter: self)
    private var view: UsersViewable
    private var users = [OPUser]()
    
    init(view: UsersViewable) {
        
        self.view = view
        
    }
    
    func setup() {
        
        
    }
    
    func load() {
        
        fireManager.downloadUsers()
        
    }
    
    func cancel() {
        
        fireManager.removeObservers()
        
    }
    
}

extension UsersPresenter: PresenterViewUpdating {
    
    func update() {
        
        users = fireManager.showUsers().filter { $0.uid != Constants.API.USER_ID  }
        view.reload()
        
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
        
        pop(user: users[row])
        
    }
    
}

extension UsersPresenter: UsersPresentereRouting {
    
    func pop(user: OPUser) {
        
        view.pop(user: user)
        
    }
    
}

extension UsersPresenter: PresenterViewNotificationSending {
    
    func postNotification(info: [String : AnyObject]?) {
        
        guard let info = info else { return }
        NotificationCenter.default.post(name: .userSelected, object: nil, userInfo: info)
        
    }
    
}

