//
//  LoginVC.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/20/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

protocol LoginViewRoutable {
    func showRegistration()
    func showMainScreen()
    func showAdminScreen()
}

typealias LoginViewable = LoginViewRoutable

class LoginVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var loginButton: UIButton! {
        
        didSet {
            
            loginButton.layer.cornerRadius = loginButton.bounds.height / 2
            loginButton.layer.masksToBounds = true
            
        }
    }
    
    @IBOutlet weak var facebookButton: UIButton!  {
        
        didSet {
            
            facebookButton.layer.cornerRadius = facebookButton.bounds.height / 2
            facebookButton.layer.masksToBounds = true
            
        }
    }
    
    @IBOutlet weak var googleButton: UIButton!  {
        
        didSet {
            
            googleButton.layer.cornerRadius = googleButton.bounds.height / 2
            googleButton.layer.masksToBounds = true
            
        }
        
    }
    
    lazy var presenter: LoginPresentable = LoginPresenter(view: self)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.delegate = self
        passwordTF.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    
        setupNavBar()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
        
    }
    
    private func setupNavBar() {
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        presenter.routeTo(admin: false)
        
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        
    }
    
    @IBAction func facebookButtonPressed(_ sender: UIButton) {
        
        
    }
    
    @IBAction func googleButtonPressed(_ sender: UIButton) {
        
        
    }
    
}

extension LoginVC: LoginViewRoutable {
    
    func showMainScreen() {
        
        let vc = AdminMonthsVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func showAdminScreen() {
        
    }
    
    func showRegistration() {
        
    }
    
}

