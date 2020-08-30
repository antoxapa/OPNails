//
//  UserAccountVC.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/30/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

protocol UserViewUpdatable {
    
    func update(user: OPUser)
    func changedUserInfo() -> (name: String?, phone: String?, email: String?, password: String?)
    
}

protocol UserViewRoutable {
    
    func pop()
    
}

protocol UserViewPresendable {
    
    func setEditable(_ : Bool)
    func showEditAC(title: String, tag: Int)
    
}

typealias UserViewable = UserViewUpdatable & UserViewRoutable & UserViewPresendable

class UserAccountVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userLogo: UIImageView!
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var logoutCancelButton: UIButton!
    
    lazy var presenter: UserPresenting = UserPresenter(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        presenter.load()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.cancel()
        
    }
    
    private func setupViews() {
        
        fullNameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        phoneNumberTF.delegate = self
        
        
        
//        fullNameTF.isUserInteractionEnabled = false
        fullNameTF.textColor = .gray
        fullNameTF.tag = 0
//        emailTF.isUserInteractionEnabled = false
        emailTF.textColor = .gray
        emailTF.tag = 2
//        passwordTF.isUserInteractionEnabled = false
        passwordTF.textColor = .gray
        passwordTF.tag = 3
//        phoneNumberTF.isUserInteractionEnabled = false
        phoneNumberTF.textColor = .gray
        phoneNumberTF.tag = 1
        
        addButton(to: fullNameTF)
        addButton(to: emailTF)
        addButton(to: passwordTF)
        addButton(to: phoneNumberTF)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: false)
        
    }
    
    private func addButton(to textField: UITextField) {
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "edit"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(textField.frame.size.width - 5), y: CGFloat(5), width: CGFloat(5), height: CGFloat(5))
        button.addTarget(self, action: #selector(self.edit), for: .touchUpInside)
        button.tag = textField.tag
        textField.rightView = button
        textField.rightViewMode = .always
        
    }
    
    @IBAction func edit(_ sender: UITextField) {

        presenter.showEditAC(tag: sender.tag)
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    func tfEnable() {
        
        logoutCancelButton.setTitle("Cancel", for: .normal)
        editButton.setTitle("OK", for: .normal)
        fullNameTF.isUserInteractionEnabled = true
        fullNameTF.textColor = .black
        emailTF.isUserInteractionEnabled = true
        emailTF.textColor = .black
        passwordTF.isUserInteractionEnabled = true
        passwordTF.textColor = .black
        phoneNumberTF.isUserInteractionEnabled = true
        phoneNumberTF.textColor = .black
        
    }
    
    func tfDisable() {
        
        logoutCancelButton.setTitle("Logout", for: .normal)
        editButton.setTitle("Edit", for: .normal)
        fullNameTF.isUserInteractionEnabled = false
        fullNameTF.textColor = .gray
        emailTF.isUserInteractionEnabled = false
        emailTF.textColor = .gray
        passwordTF.isUserInteractionEnabled = false
        passwordTF.textColor = .gray
        phoneNumberTF.isUserInteractionEnabled = false
        phoneNumberTF.textColor = .gray
        
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        
        if editButton.titleLabel?.text == "OK" {
            
//            presenter.changeProfileInfo()
            
        }
        
//        presenter.setEditable()
        
    }
    
    @IBAction func logoutCancelButtonPressed(_ sender: UIButton) {
        
        presenter.logout()
        
    }
    
}

extension UserAccountVC: UserViewUpdatable {
    
    func update(user: OPUser) {
        
        fullNameTF.text = user.name
        phoneNumberTF.text = user.phoneNumber
        emailTF.text = user.email
        passwordTF.text = ""
        
    }
    
    func changedUserInfo() -> (name: String?, phone: String?, email: String?, password: String?) {
        
        let name = fullNameTF.text
        let phone = phoneNumberTF.text
        let email = emailTF.text
        let password = passwordTF.text
        
        if password != "" {
            
        return (name, phone, email, password)
            
        }
        
        return (name,phone,email,nil)
        
    }
    
}

extension UserAccountVC: UserViewRoutable {
    
    func pop() {
        
        let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
        self.navigationController?.setViewControllers([loginVC], animated: false)
        
    }
    
}

extension UserAccountVC: UserViewPresendable {
    
    func showEditAC(title: String, tag: Int) {
        
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let actionTitle = "OK"
        ac.addTextField()
        let action = UIAlertAction(title: actionTitle, style: .default) { [weak self](action) in
//            self?.showLoadingAC()
//            self?.presenter.removeUserFromEntry(index: index)
            guard let textField = ac.textFields?.first, textField.text != "" else { return }
            self?.presenter.changeProfileInfo(tag: tag, newValue: textField.text!)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(action)
        ac.addAction(cancel)
        self.present(ac, animated: true)
        
        
        
    }
    
    func setEditable(_ editable: Bool) {
        
        editable ? self.tfEnable() : self.tfDisable()
        
    }
    
}
