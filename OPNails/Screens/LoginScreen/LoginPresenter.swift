//
//  LoginPresenter.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/20/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

protocol LoginPresenting {
    
    func signIn(email: String?, password: String?)
    func signOut()
    func registerUser(email: String, password: String, name: String, phoneNumber: String)
    func checkUserLogged()
    func showErrorAC(withTitle title:String, message: String)
    func showLoadingAC()
    func hideLoadingAC()
    func showRegistrationErrorAC(withTitle title:String, message: String)
    func registrationDelegate(view: RegistrationViewable)
    func checkTextValidation(email: String?, password: String?, name: String?, phoneNumber: String?)
    
}

protocol LoginRoutable {
    
    func routeToMainScreen(admin: Bool, animated: Bool)
    func routeToMainScreenAfterRegistration()
    func routeToRegisterScreen()
    
}

typealias LoginPresentable = PresenterLifecycle & LoginPresenting & LoginRoutable & PresenterViewUpdating

final class LoginPresenter: PresenterLifecycle {
    
    private weak var view: LoginViewable?
    private weak var registrationView: RegistrationViewable?
    private var fireManager: FirebaseManaging
    private var entries = [Entry]()
    
    init(view: LoginViewable) {
        
        self.view = view
        fireManager = FirebaseManager()
        setup()
        
    }
    
    func setup() {
        
    }
    
    func load() {
        
        view?.showLoadScreen()
        fireManager.downloadItems {
            self.update()
        }
        
    }
    
    func cancel() {
        
        fireManager.removeObservers()
        
    }
    
}

extension LoginPresenter: PresenterViewUpdating {
    
    func update() {
        
        let admin = fireManager.isCurrentUserAdmin()
        routeToMainScreen(admin: admin, animated: false)
        
    }
    
    func showErrorAC(text: String) {
        
        let title = i18n.errorTitle
        view?.showAlertController(withTitle: title, message: text)
        
    }
    
    func dismissAC() {
        
        
    }
    
}

extension LoginPresenter: LoginRoutable {
    
    func routeToMainScreen(admin: Bool, animated: Bool) {
        
        hideLoadingAC()
        view?.showMainScreen(admin: admin, animated: animated)
        
    }
    
    func routeToRegisterScreen() {
        
        view?.showRegistration()
        
    }
    
    func routeToMainScreenAfterRegistration() {
        
        fireManager.downloadItems {
            self.update()
        }
        
    }
    
}

extension LoginPresenter: LoginPresenting {
    
    func signIn(email: String?, password: String?) {
        
        guard
            let email = email, email != "",
            let password = password, password != ""
            else {
                let title = i18n.errorTitle
                let message = i18n.correct_title
                showErrorAC(withTitle: title, message: message)
                return
        }
        
        fireManager.signIn(withEmail: email, password: password, completion: {
            
            self.load()
            
        }, onError: { (error) in
            
            let title = i18n.errorTitle
            self.showErrorAC(withTitle: title, message: error.localizedDescription)
            
        })
        
    }
    
    func signOut() {
        
        fireManager.signOut { (error) in
            self.showErrorAC(text: error.localizedDescription)
        }
        
    }
    
    func registerUser(email: String, password: String, name: String, phoneNumber: String) {
        
        fireManager.registerUser(withEmail: email, password: password, name: name, phoneNumber: phoneNumber, completion: {
            
            self.routeToMainScreenAfterRegistration()
            
        }, onError: { (error) in
            
            self.hideLoadingAC()
            self.showRegistrationErrorAC(withTitle: i18n.errorTitle, message: error.localizedDescription)
            
        })
        
    }
    
    func checkUserLogged() {
        
        fireManager.checkUserLogged {
            self.load()
        }
        
    }
    
    func showErrorAC(withTitle title:String, message: String) {
        
        view?.showAlertController(withTitle: title, message: message)
        
    }
    
    func showRegistrationErrorAC(withTitle title:String, message: String) {
        
        registrationView?.showAlertController(withTitle: title, message: message)
        
    }
    
    func showLoadingAC() {
        
        registrationView?.showLoadingAlert()
        
    }
    
    func hideLoadingAC() {
        
        registrationView?.hideLoadingAlert()
        
    }
    
    func registrationDelegate(view: RegistrationViewable) {
        
        registrationView = view
        
    }
    
    func checkTextValidation(email: String?, password: String?, name: String?, phoneNumber: String?) {
        
        guard
            email != nil,
            email != "",
            password != nil,
            password != "",
            name != nil,
            name != "",
            phoneNumber != nil,
            phoneNumber != ""
            else {
            
            let title = i18n.errorTitle
            let message = i18n.correct_title
            showRegistrationErrorAC(withTitle: title, message: message)
            return
                
        }
        showLoadingAC()
        registerUser(email: email!, password: password!, name: name!, phoneNumber: phoneNumber!)
        
    }
    
}

