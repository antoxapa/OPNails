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
    func showMainScreen(admin: Bool, animated: Bool)
    func showAdminScreen()
    func showLoadScreen()
    
}

protocol LoginViewPresentable {
    
    func showAlertController(withTitle text: String, message: String)
    
}

typealias LoginViewable = LoginViewRoutable & LoginViewPresentable

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
        
        setupViews()
        
        setupNavBar()
        
        presenter.checkUserLogged()
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        presenter.cancel()
//
//    }
    
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
    
    private func setupViews() {
        
        emailTF.delegate = self
        passwordTF.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        guard let email = emailTF.text, let password = passwordTF.text, emailTF.text != "", passwordTF.text != "" else {
            
            let title = "Ooops!"
            let message = "Please enter correct login or password"
            presenter.showErrorAC(withTitle: title, message: message)
            return
            
        }
        
        presenter.signIn(email: email, password: password)
        
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        presenter.routeToRegisterScreen()
        
    }
    
    @IBAction func facebookButtonPressed(_ sender: UIButton) {
        
        
    }
    
    @IBAction func googleButtonPressed(_ sender: UIButton) {
        
        
    }
    
}

extension LoginVC: LoginViewRoutable {
    
    func showLoadScreen() {
        
        let loadingVC = LoadingVC()
        self.navigationController?.pushViewController(loadingVC, animated: false)
        
    }
    
    func showMainScreen(admin: Bool, animated: Bool) {
        
        let vc = MonthsVC()
        if admin {
            vc.adminUser = admin
        }
        self.navigationController?.setViewControllers([vc], animated: false)
//        presenter.cancel()
        
    }
    
    
    func showAdminScreen() {
        
    }
    
    func showRegistration() {
        
        let registrationVC = RegistrationVC(nibName: "RegistrationVC", bundle: nil)
        presenter.registrationDelegate(view: registrationVC)
        self.navigationController?.pushViewController(registrationVC, animated: true)
        registrationVC.presenter = presenter
        
    }
    
}

extension LoginVC: LoginViewPresentable {
    
    func showAlertController(withTitle text: String, message: String) {
        
        let ac = UIAlertController(title: text, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(okAction)
        self.present(ac, animated: true)
        
    }
    
}

