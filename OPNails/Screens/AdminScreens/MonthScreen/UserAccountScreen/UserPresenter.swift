//
//  UserPresenter.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/30/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

protocol UserPresenterModelUpdating {
    
    
    func changeProfileInfo(tag: Int, newValue: String, password: String)
    
}

protocol UserPresenterRouting {
    
    func showEditAC(tag: Int)
    func logout()
    
}

typealias UserPresenting = PresenterLifecycle & PresenterViewUpdating & UserPresenterModelUpdating & UserPresenterRouting

class UserPresenter: PresenterLifecycle {
    
    private lazy var fireManager = FirebaseManager(presenter: self)
    private var view: UserViewable
    private var user: OPUser?
    private var editable: Bool = false
    
    init(view: UserViewable) {
        
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

extension UserPresenter: PresenterViewUpdating {
    
    func update() {
        
        for user in fireManager.users {
            if user.uid == fireManager.returnCurrentUser()?.uid {
                self.user = user
                break
            }
        }
        
        guard let user = user else { return }
        view.update(user: user)
        
    }
    
    func showErrorAC(text: String) {
        
        dismissAC()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.view.showErrorAC(text: text)
            
        }
        
    }
    
    func dismissAC() {
        
        view.dissmisAC()
        
    }
    
}

extension UserPresenter: UserPresenterModelUpdating {
    
    func changeProfileInfo(tag: Int, newValue: String, password: String) {
        
        switch tag {
        case 0:
            fireManager.changeUserName(name: newValue)
        case 1:
            fireManager.changeUserPhoneNumber(number: newValue)
        case 2:
            fireManager.changeEmail(newEmail: newValue, password: password)
        case 3:
            fireManager.changePassword(newPassword: newValue, oldPassword: password)
        default:
            print("error")
        }
        
    }
    
}

extension UserPresenter : UserPresenterRouting {
    
    func showEditAC(tag: Int) {
        
        switch tag {
        case 0:
            let title = "full name"
            view.showEditAC(title: title, tag: tag)
        case 1:
            let title = "phone number"
            view.showEditAC(title: title, tag: tag)
        case 2:
            let title = "email"
            view.showEditAC(title: title, tag: tag)
        case 3:
            let title = "password"
            view.showEditAC(title: title, tag: tag)
        default:
            print("No tag")
        }
    }
    
    func logout() {
        
        fireManager.signOut()
        view.pop()
        
    }
    
}
