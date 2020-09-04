//
//  UserAccountVC.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/30/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

protocol UserViewUpdatable {
    
    func update(user: OPUser, email: String)
    func dissmisAC()
    
}

protocol UserViewRoutable {
    
    func pop()
    
}

protocol UserViewPresendable {
    
    func showEditAC(title: String, option: ProfileInfoOption)
    func showLoadingAC()
    func showErrorAC(text: String)
    
}

typealias UserViewable = UserViewUpdatable & UserViewRoutable & UserViewPresendable

class UserAccountVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userLogo: UIImageView!
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var logoutButton: UIButton! {
        didSet {
            logoutButton.layer.cornerRadius = 10
            logoutButton.layer.masksToBounds = true
        }
    }
    
    lazy var presenter: UserPresenting = UserPresenter(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        presenter.load()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        presenter.setup()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.cancel()
        
    }
    
    private func setupViews() {
        
        let textFields = [fullNameTF, phoneNumberTF, emailTF, passwordTF].compactMap { $0 }
        for (index, field) in textFields.enumerated() {
            field.delegate = self
            field.textColor = .gray
            field.tag = index
            addButton(to: field)
        }
        
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
    
    @IBAction func logoutCancelButtonPressed(_ sender: UIButton) {
        
        presenter.logout()
        
    }
    
}

extension UserAccountVC: UserViewUpdatable {
    
    func update(user: OPUser, email: String) {
        
        dissmisAC()
        
        fullNameTF.text = user.name
        phoneNumberTF.text = user.phoneNumber
        emailTF.text = email
        passwordTF.text = ""
        
    }
    
    func dissmisAC() {
        
        if let _ = self.navigationController?.presentedViewController {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}

extension UserAccountVC: UserViewRoutable {
    
    func pop() {
        
        let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
        self.navigationController?.setViewControllers([loginVC], animated: false)
        
    }
    
}

extension UserAccountVC: UserViewPresendable {
    
    func showEditAC(title: String, option: ProfileInfoOption) {
        
        let ac = UIAlertController(title: "Change \(title)", message: nil, preferredStyle: .alert)
        let actionTitle = "OK"
        
        let action = UIAlertAction(title: actionTitle, style: .default) { [weak self] (action) in
            
            self?.showLoadingAC()
            guard let textField = ac.textFields?.first else { return }
            guard let secondTextField = ac.textFields?.last else { return }
            self?.presenter.changeProfileInfo(option: option, newValue: textField.text!, password: secondTextField.text!)
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        action.isEnabled = false
        ac.addAction(action)
        ac.addAction(cancel)
        
        ac.addTextField { (textField) in
            
            textField.placeholder = "New \(title)"
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
                {_ in
                    let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let textIsNotEmpty = textCount > 0
                    action.isEnabled = textIsNotEmpty
            })
            
        }
        
        ac.addTextField() { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
    
        self.present(ac, animated: true)
        
    }
    
    func showLoadingAC() {
        
        let alert = UIAlertController(title: "Wait...", message: nil, preferredStyle: .alert)
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
    
    func showErrorAC(text: String) {
        
        let title = "Error"
        let ac = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(action)
        present(ac, animated: true)
        
    }
    
}
