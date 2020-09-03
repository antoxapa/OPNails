//
//  UserPresenter.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/30/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

protocol UserPresenterModelUpdating {
    
    func changeProfileInfo(option: ProfileInfoOption, newValue: String, password: String)
    
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
        guard let email = fireManager.returnFirebaseUser()?.email else { return }
        view.update(user: user, email: email)
        
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
    
    func changeProfileInfo(option: ProfileInfoOption, newValue: String, password: String) {
        
        switch option {
        case .username:
            fireManager.changeUserName(to: newValue)
        case .phoneNumber:
            fireManager.changeUserPhoneNumber(to: newValue)
        case .email:
            fireManager.changeEmail(newEmail: newValue, password: password)
        case .password:
            fireManager.changePassword(newPassword: newValue, oldPassword: password)
        }
        
    }
    
}

extension UserPresenter : UserPresenterRouting {
    
    func showEditAC(tag: Int) {
        
        guard let option = ProfileInfoOption(rawValue: tag) else { return }
        var title: String
        switch option {
        case .username:
            title = "full name"
        case .phoneNumber:
            title = "phone number"
        case .email:
            title = "email"
        case .password:
            title = "password"
        }
        view.showEditAC(title: title, option: option)
        
    }
    
    func logout() {
        
        fireManager.signOut()
        view.pop()
        
    }
    
}
