//
//  UserPresenter.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/30/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

protocol UserPresenterModelUpdating {
    
    func logout()
    
}

protocol UserPresenterUpdating {
    
    func changeProfileInfo(tag: Int, newValue: String)
    func setEditable()
    
}

protocol UserPresenterRouting {
    
    func showEditAC(tag: Int)
    
}

typealias UserPresenting = PresenterLifecycle & PresenterViewUpdating & UserPresenterUpdating & UserPresenterModelUpdating & UserPresenterRouting

class UserPresenter: PresenterLifecycle, PresenterViewUpdating {
    
    private lazy var dataManager = DataManager(presenter: self)
    private var view: UserViewable
    private var user: OPUser?
    private var editable: Bool = false
    
    init(view: UserViewable) {
        
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
        
        for user in dataManager.users {
            if user.uid == dataManager.returnCurrentUser()?.uid {
                self.user = user
                break
            }
        }
        
        guard let user = user else { return }
        view.update(user: user)
        
    }
    
}

extension UserPresenter: UserPresenterUpdating {
    
    func setEditable() {
        
        editable = !editable
        view.setEditable(editable)
        
    }
    
}

extension UserPresenter: UserPresenterModelUpdating {
    
    func changeProfileInfo(tag: Int, newValue: String) {
        print(tag)
        
//        switch tag {
//        case 0:
//            dataManager.changeUserName(name: newValue)
//        case 1:
//            dataManager.changeUserPhoneNumber(number: newValue)
//        case 2:
//            dataManager.changeEmail(email: newValue)
//        case 3:
//            dataManager.changePassword(password: newValue)
//        default:
//            print("error")
//        }
        if tag == 0 {
            dataManager.changeUserName(name: newValue)
        } else if tag == 1 {
            dataManager.changeUserPhoneNumber(number: newValue)
        } else if tag == 2 {
            dataManager.changeEmail(email: newValue)
        } else if tag == 3 {
            dataManager.changePassword(password: newValue)
        }
//        var name = user?.name
//        var email = user?.email
//        var phone = user?.phoneNumber
//        var password: String?
//
//        let info = view.changedUserInfo()
//        if info.name != nil {
//            name = info.name
//        }
//        if info.email != nil {
//            email = info.email
//        }
//        if info.phone != nil {
//            phone = info.phone
//        }
//        if info.password != nil {
//            password = info.password
//        }
//
//        dataManager.changeProfileInfo(name: name, phone: phone, email: email, password: password)
        
    }
    
    func logout() {
        
        if !editable {
            
            dataManager.signOut()
            view.pop()
            
        } else {
            
            setEditable()
            update()
            
        }
        
    }
    
}

extension UserPresenter : UserPresenterRouting {
    
    
    func showEditAC(tag: Int) {
    
       switch tag {
              case 0:
                  let title = "Change full name"
                  view.showEditAC(title: title, tag: tag)
              case 1:
                  let title = "Change phone number"
                  view.showEditAC(title: title, tag: tag)
              case 2:
                  let title = "Change email"
                  view.showEditAC(title: title, tag: tag)
              case 3:
                  let title = "Change password"
                  view.showEditAC(title: title, tag: tag)
              default:
                  print("No tag")
              }
        
        
    }
    
}
