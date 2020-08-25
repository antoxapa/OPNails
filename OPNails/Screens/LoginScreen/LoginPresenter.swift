//
//  LoginPresenter.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/20/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

protocol LoginPresenting {
    
    func signIn(email: String, password: String)
    func signOut()
    func registerUser(email: String, password: String)
    func checkUserLogged()
    func showErrorAC(withTitle title:String, message: String)
    func showLoadingAC()
    func hideLoadingAC()
    func showRegistrationErrorAC(withTitle title:String, message: String)
    func registrationDelegate(view: RegistrationViewable)
    
    
}

protocol LoginRoutable {
    
    func routeToMainScreen(admin: Bool, animated: Bool)
    func routeToMainScreenAfterRegistration()
    func routeToRegisterScreen()
    
}

typealias LoginPresentable = PresenterLifecycle & LoginPresenting & LoginRoutable & PresenterViewUpdating

class LoginPresenter: PresenterLifecycle, PresenterViewUpdating {
    
    private var view: LoginViewable
    private var loginManager: LoginManager?
    private var registrationView: RegistrationViewable?
    lazy private var dataManager = DataManager(presenter: self)
    private var entries = [Entry]()
    
    init(view: LoginViewable) {
        self.view = view
        setup()
    }
    
    func setup() {
        
        loginManager = LoginManager(presenter: self)
        
    }
    
    func load() {
        
        view.showLoadScreen()
        dataManager.downloadItems()
        
    }
    
    func update() {
        
        routeToMainScreen(admin: true, animated: false)
        
    }
    
}

extension LoginPresenter: LoginRoutable {
    
    func routeToMainScreen(admin: Bool, animated: Bool) {
        
        hideLoadingAC()
        view.showMainScreen(admin: admin, animated: animated)
        
    }
    
    func routeToRegisterScreen() {
        
        view.showRegistration()
        
    }
    
    func routeToMainScreenAfterRegistration() {
        
        dataManager.downloadItems()
        
    }
    
}

extension LoginPresenter: LoginPresenting {
    
    func signIn(email: String, password: String) {
        
        loginManager?.signIn(withEmail: email, password: password)
        
    }
    
    func signOut() {
        
        loginManager?.signOut()
        
    }
    
    func registerUser(email: String, password: String) {
        
        loginManager?.registerUser(withEmail: email, password: password)
        
    }
    
    func checkUserLogged() {
        
        loginManager?.checkUserLogged()
        
    }
    
    func showErrorAC(withTitle title:String, message: String) {
        
        view.showAlertController(withTitle: title, message: message)
        
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
}

