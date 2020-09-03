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

class LoginPresenter: PresenterLifecycle {
    
    private weak var view: LoginViewable?
    private var loginManager: LoginManager?
    private weak var registrationView: RegistrationViewable?
    lazy private var fireManager = FirebaseManager(presenter: self)
    private var entries = [Entry]()
    
    init(view: LoginViewable) {
        
        self.view = view
        setup()
        
    }
    
    func setup() {
        
        loginManager = LoginManager(presenter: self)
        
    }
    
    func load() {
        
        view?.showLoadScreen()
        fireManager.downloadItems()
        
    }
    
    func cancel() {
        
        fireManager.removeObservers()
        
    }
    
}

extension LoginPresenter: PresenterViewUpdating {
    
    func update() {
        
        guard let admin = loginManager?.checkAdminUser() else { return }
        routeToMainScreen(admin: admin, animated: false)
        
    }
    
    func showErrorAC(text: String) {
        
        let title = "Error"
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
        
        fireManager.downloadItems()
        
    }
    
}

extension LoginPresenter: LoginPresenting {
    
    func signIn(email: String?, password: String?) {
        
        guard
            let email = email, email != "",
            let password = password, password != ""
            else {
                let title = "Ooops!"
                let message = "Please enter correct login or password"
                showErrorAC(withTitle: title, message: message)
                return
        }
        loginManager?.signIn(withEmail: email, password: password)
        
    }
    
    func signOut() {
        
        loginManager?.signOut()
        
    }
    
    func registerUser(email: String, password: String, name: String, phoneNumber: String) {
        
        loginManager?.registerUser(withEmail: email, password: password, name: name, phoneNumber: phoneNumber)
        
    }
    
    func checkUserLogged() {
        
        loginManager?.checkUserLogged()
        
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
        
        guard email != nil, email != "", password != nil, password != "", name != nil, name != "", phoneNumber != nil, phoneNumber != "" else {
            
            let title = "Ooops!"
            let message = "Please enter correct login or password"
            showRegistrationErrorAC(withTitle: title, message: message)
            return
        }
        showLoadingAC()
        registerUser(email: email!, password: password!, name: name!, phoneNumber: phoneNumber!)
        
    }
    
}

