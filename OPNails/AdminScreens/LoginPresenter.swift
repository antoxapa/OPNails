//
//  LoginPresenter.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/20/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

protocol LoginPresenting {
    
}

protocol LoginRoutable {
    
    func routeTo(admin: Bool)
    
}

typealias LoginPresentable = PresenterLifecycle & LoginPresenting & LoginRoutable

class LoginPresenter: PresenterLifecycle {
    
    private var view: LoginViewable
    
    init(view: LoginViewable) {
        self.view = view
    }
    
    func setup() {
        
        
    }
    
    
    
}

extension LoginPresenter: LoginRoutable {
    
    func routeTo(admin: Bool) {
        view.showMainScreen()
    }
    
}

extension LoginPresenter: LoginPresenting {
    
}
