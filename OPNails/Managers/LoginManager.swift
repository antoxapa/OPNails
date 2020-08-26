//
//  LoginManager.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/20/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation
import FirebaseAuth

class LoginManager {
    
    var presenter: LoginPresentable
    
    init(presenter: LoginPresentable) {
        
        self.presenter = presenter
        
    }
    
    
    func checkUserLogged() {
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                
                self?.presenter.load()
                
            }
        }
    }
    
    func checkAdminUser() -> Bool {
        if Auth.auth().currentUser?.email == "antoxapa@gmail.com" {
            return true
        }
        return false
    }
    
    func signIn(withEmail email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                let title = "Oops!"
                self?.presenter.showErrorAC(withTitle: title, message: error!.localizedDescription)
            }
            if user != nil {
                self?.presenter.load()
            } else {
                let title = "Error"
                let message = "No such user"
                self?.presenter.showErrorAC(withTitle: title, message: message)
            }
        }
        
    }
    
    func signOut() {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func registerUser(withEmail email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.presenter.hideLoadingAC()
                self?.presenter.showRegistrationErrorAC(withTitle: "Error", message: error!.localizedDescription)
            }
            if user != nil {
                self?.presenter.routeToMainScreenAfterRegistration()
            }
        }
    }
    
}
