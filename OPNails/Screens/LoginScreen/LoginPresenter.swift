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
    func showRegistrationErrorAC(withTitle title:String, message: String)
    func registrationDelegate(view: RegistrationViewable)
    
}

protocol LoginRoutable {
    
    func routeToMainScreen(admin: Bool, animated: Bool)
    func routeToMainScreenAfterRegistration()
    func routeToRegisterScreen()
    
}

typealias LoginPresentable = PresenterLifecycle & LoginPresenting & LoginRoutable

class LoginPresenter: PresenterLifecycle {
    
    private var view: LoginViewable
    private var loginManager: LoginManager?
    private var registrationView: RegistrationViewable?
    
    init(view: LoginViewable) {
        self.view = view
        setup()
    }
    
    func setup() {
        
        loginManager = LoginManager(presenter: self)
        
    }
    
}

extension LoginPresenter: LoginRoutable {
    
    func routeToMainScreen(admin: Bool, animated: Bool) {
        
        view.showMainScreen(admin: admin, animated: animated)
        
    }
    
    func routeToRegisterScreen() {
        
        view.showRegistration()
        
    }
    
    func routeToMainScreenAfterRegistration() {
        
        registrationView?.showMainScreen()
        
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
    
    func registrationDelegate(view: RegistrationViewable) {
        
        registrationView = view
        
    }
}

