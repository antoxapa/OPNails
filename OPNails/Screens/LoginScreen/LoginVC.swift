//
//  LoginVC.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/20/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

protocol LoginViewRoutable: AnyObject {
    
    func showRegistration()
    func showMainScreen(admin: Bool, animated: Bool)
    func showLoadScreen()
    
}

protocol LoginViewPresentable: AnyObject {
    
    func showAlertController(withTitle text: String, message: String)
    
}

typealias LoginViewable = LoginViewRoutable & LoginViewPresentable

class LoginVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var dontHaveAccountLabel: UILabel!
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
    @IBOutlet weak var registerButton: UIButton!
    
    lazy var presenter: LoginPresentable = LoginPresenter(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        setupNavBar()
        
        presenter.checkUserLogged()
        
        localizeViews()
        
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
    
    private func setupViews() {
        
        emailTF.delegate = self
        passwordTF.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }
    
    private func localizeViews() {
        
        passwordTF.placeholder = i18n.userPassword
        loginButton.setTitle(i18n.buttonLogin, for: .normal)
        registerButton.setTitle(i18n.buttonRegister, for: .normal)
        dontHaveAccountLabel.text = i18n.dontHaveAccount
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {

        presenter.signIn(email: emailTF.text, password: passwordTF.text)
        
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
        
    }
    
    func showRegistration() {
        
        let registrationVC = RegistrationVC(nibName: "RegistrationVC", bundle: nil)
        presenter.registrationDelegate(view: registrationVC)
        self.navigationController?.pushViewController(registrationVC, animated: true)
        registrationVC.presenter = presenter
        
    }
    
}

extension LoginVC: LoginViewPresentable {
//    TODO: create AlertPresentring protocol and delete dublicated code
    func showAlertController(withTitle text: String, message: String) {
        
        let ac = UIAlertController(title: text, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: i18n.buttonOk, style: .default, handler: nil)
        ac.addAction(okAction)
        self.present(ac, animated: true)
        
    }
    
}

