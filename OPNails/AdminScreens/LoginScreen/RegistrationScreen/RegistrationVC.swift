//
//  RegistrationVC.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/21/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

protocol RegistrationViewPresenting {
    func showAlertController(withTitle text: String, message: String)
}

protocol RegistrationViewRouting {
    func showMainScreen()
}

typealias RegistrationViewable = RegistrationViewPresenting & RegistrationViewRouting

class RegistrationVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var nameSecondNameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var presenter: LoginPresentable?
    
    @IBOutlet weak var registerButton: UIButton! {
        didSet {
            registerButton.layer.cornerRadius = registerButton.bounds.height / 2
            registerButton.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.layer.cornerRadius = cancelButton.bounds.height / 2
            cancelButton.layer.masksToBounds = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    private func setupViews() {
        
        emailTF.delegate = self
        passwordTF.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        self.view.endEditing(true)
        guard let email = emailTF.text, emailTF.text != "", let password = passwordTF.text, passwordTF.text != "", let name = nameSecondNameTF.text, nameSecondNameTF.text != "", let phoneNumber = phoneNumberTF.text, phoneNumberTF.text != "" else {
            let title = "Ooops!"
            let message = "Please enter correct login or password"
            presenter?.showRegistrationErrorAC(withTitle: title, message: message)
            return
        }
        
        presenter?.registerUser(email: email, password: password)
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension RegistrationVC: RegistrationViewPresenting {
    
    func showAlertController(withTitle text: String, message: String) {
        let ac = UIAlertController(title: text, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(okAction)
        self.present(ac, animated: true)
    }
    
}

extension RegistrationVC: RegistrationViewRouting {
    
    func showMainScreen() {
        
        let vc = AdminMonthsVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension RegistrationVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == phoneNumberTF){
            
        }
        return true
    }
}

