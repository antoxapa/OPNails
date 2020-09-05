//
//  UsersVC.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/29/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

protocol UsersViewUpdatable: AnyObject {
    
    func reload()
    
}

protocol UsersViewRoutable: AnyObject {
    
    func pop()
    
}

protocol UsersViewPresentable: AnyObject {
    
    func returnEntry() -> EntryRowItem?
    
}

typealias UsersViewable = UsersViewUpdatable & UsersViewRoutable & UsersViewPresentable

class UsersVC: UIViewController {
    
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel! {
        didSet {
            emptyLabel.alpha = 0.4
            emptyLabel.text = i18n.emptyUsers
        }
    }
    
    lazy var presenter: UsersPresenter = UsersPresenter(view: self)
    var entry: EntryRowItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        presenter.setup()
        
        presenter.load()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.cancel()
        
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
    
    func pop() {
        
        self.navigationController?.popViewController(animated: true)
        
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
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
}

extension UsersVC: UsersViewPresentable {
    
    func returnEntry() -> EntryRowItem? {
        
        return entry
        
    }
    
}
