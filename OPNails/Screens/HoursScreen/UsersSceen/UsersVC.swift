//
//  UsersVC.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/29/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

protocol UsersViewUpdatable {
    
    func reload()
    
}

protocol UsersViewRoutable {
    
    func pop(user: OPUser)
    
}

typealias UsersViewable = UsersViewUpdatable & UsersViewRoutable

class UsersVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel! {
        didSet {
            emptyLabel.alpha = 0.4
            emptyLabel.text = "No users"
        }
    }
    
    lazy var presenter: UsersPresenter = UsersPresenter(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        presenter.load()
        
    }
    
    private func setupViews() {
        
        usersTableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.tableFooterView = UIView(frame: .zero)
        
    }
    
}

extension UsersVC: UsersViewUpdatable {
    
    func reload() {
        
        usersTableView.reloadData()
        
    }
    
}

extension UsersVC: UsersViewRoutable {
    
    func pop(user: OPUser) {
        
        presenter.postNotification(info: ["user": user])
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

extension UsersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        presenter.numberOfCells(in: section)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else {
            return UITableViewCell() }
        
        if let item = presenter.data(at: indexPath.row) {
            
            emptyLabel.isHidden = true
            cell.configure(item: item)
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        presenter.didSelectCell(at: indexPath.row)
        
    }
    
}
