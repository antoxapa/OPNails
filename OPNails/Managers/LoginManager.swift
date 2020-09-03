//
//  LoginManager.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/20/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class LoginManager {
    
    var presenter: LoginPresentable
    var ref: DatabaseReference?
    
    init(presenter: LoginPresentable) {
        
        self.presenter = presenter
        
    }
    
    func checkUserLogged() {
        
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            guard let _ = user else { return }
            self?.presenter.load()
        }
        
    }
    
    func checkAdminUser() -> Bool {
        
        return Auth.auth().currentUser?.uid == Constants.API.USER_ID
        
    }
    
    func signIn(withEmail email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                let title = "Error!"
                self?.presenter.showErrorAC(withTitle: title, message: error!.localizedDescription)
                return
            }
            self?.presenter.load()
        }
        
    }
    
    func signOut() {
        
        do {
            try Auth.auth().signOut()
        } catch {
            //TODO: Add code here
        }
        
    }
    
    func registerUser(withEmail email: String, password: String, name: String, phoneNumber: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.presenter.hideLoadingAC()
                self?.presenter.showRegistrationErrorAC(withTitle: "Error", message: error!.localizedDescription)
            }
            if user != nil {
                self?.ref = Database.database().reference(withPath: "users")
                let userRef = self?.ref?.child((user?.user.uid)!)
                userRef?.setValue(["uid":user?.user.uid,"name":name, "phoneNumber":phoneNumber])
                self?.presenter.routeToMainScreenAfterRegistration()
            }
        }
        
    }
    
}
