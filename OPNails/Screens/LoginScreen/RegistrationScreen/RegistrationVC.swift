//
//  RegistrationVC.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/21/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

protocol RegistrationViewPresenting: AnyObject {
    
    func showAlertController(withTitle text: String, message: String)
    func showLoadingAlert()
    func hideLoadingAlert()
    
}

typealias RegistrationViewable = RegistrationViewPresenting

class RegistrationVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var nameSecondNameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var registrationTitle: UILabel!
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
        
        localizeViews()
        
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
    
    private func localizeViews() {
        
        nameSecondNameTF.placeholder = i18n.userName
        phoneNumberTF.placeholder = i18n.userPhone
        emailTF.placeholder = i18n.userMail
        passwordTF.placeholder = i18n.userPassword
        
        registrationTitle.text = i18n.registration_title
        registerButton.setTitle(i18n.buttonRegister, for: .normal)
        cancelButton.setTitle(i18n.buttonCancel, for: .normal)
        
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
        presenter?.checkTextValidation(email: emailTF.text, password: passwordTF.text, name: nameSecondNameTF.text, phoneNumber: phoneNumberTF.text)
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension RegistrationVC: RegistrationViewPresenting {
    
    func showAlertController(withTitle text: String, message: String) {
        let ac = UIAlertController(title: text, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: i18n.buttonOk, style: .default, handler: nil)
        ac.addAction(okAction)
        present(ac, animated: true)
        
    }
    
    func showLoadingAlert() {
        
        let alert = UIAlertController(title: i18n.alertLoad, message: nil, preferredStyle: .alert)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        
        alert.view.addSubview(activityIndicator)
        alert.view.heightAnchor.constraint(equalToConstant: 95).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -20).isActive = true
        present(alert, animated: true)
        
    }
    
    func hideLoadingAlert() {
        
        if let _ = self.navigationController?.presentedViewController {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}

extension RegistrationVC: UITextFieldDelegate {
    
    //TODO: Add TF validation methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == phoneNumberTF){
            
        }
        return true
    }
    
}

