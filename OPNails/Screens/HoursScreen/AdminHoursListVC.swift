//
//  AdminHoursListVC.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/17/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

protocol AdminHoursViewUpdatable: AnyObject {
    
    func reload()
    
}

protocol AdminHoursViewRoutable: AnyObject {
    
    func showDetail()
    func showUsers(index: Int, entry: EntryRowItem)
    func pop()
    
}

protocol AdminHoursViewPresendable: AnyObject {
    
    func presentDay() -> DayRowItem
    func showSignInEntryUserAC(index: Int)
    func showRemoveUserFromEntryAC(index: Int)
    func showClientShouldRemoveEntryTime()
    func showClientWillRemoveEntryTimeAC(index: Int)
    func showLoadingAC()
    
}

typealias AdminHoursViewable = AdminHoursViewUpdatable & AdminHoursViewRoutable & AdminHoursViewPresendable

class AdminHoursListVC: UIViewController {
    
    lazy var presenter: HoursPresenting = HoursPresenter(view: self)
    
    private let hoursTableView = UITableView()
    private var emptyLabel = UILabel()
    
    var day: DayRowItem?
    var admin: Bool = false
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        setupNavBar()
        
        presenter.load()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.load()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.cancel()
        
    }
    
    private func setupViews() {
        
        emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        emptyLabel.alpha = 0.4
        hoursTableView.register(UINib(nibName: "HoursCell", bundle: nil), forCellReuseIdentifier: "HoursCell")
        
        hoursTableView.delegate = self
        hoursTableView.dataSource = self
        hoursTableView.tableFooterView = UIView(frame: .zero)
        
        self.view.addSubview(hoursTableView)
        hoursTableView.addSubview(emptyLabel)
        
        emptyLabel.text = i18n.emptyTitle
        
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        hoursTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hoursTableView.topAnchor.constraint(equalTo: view.topAnchor),
            hoursTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            hoursTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            hoursTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            emptyLabel.centerYAnchor.constraint(equalTo: hoursTableView.centerYAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: hoursTableView.centerXAnchor),
        ])
        
    }
    
    private func setupNavBar() {
        
        if day != nil {
            self.navigationItem.title = "\(day!.month) \(day!.day), \(day!.year)"
        }
        
        if admin {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.addNewEntry))
        }
        
    }
    
    @objc private func addNewEntry() {
        
        presenter.presentDetailVC()
        
    }
    
}

extension AdminHoursListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.numberOfCells(in: section)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HoursCell", for: indexPath) as? HoursCell else { return UITableViewCell() }
        
        if let day = presenter.data(at: indexPath.row) {
            emptyLabel.isHidden = true
            
            cell.configure(with: day)
            
            presenter.checkCurrentUserRow(row: day) ? cell.selectedState() : cell.unselectedState()
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

extension AdminHoursListVC: AdminHoursViewRoutable {
    
    func showDetail() {
        
        let detailVC = NewEntryVC(nibName: "NewEntryVC", bundle: nil)
        if day != nil {
            detailVC.days = [day!]
        }
        self.present(detailVC, animated: true)
        
    }
    
    func showUsers(index: Int, entry: EntryRowItem) {
        
        let usersVC = UsersVC(nibName: "UsersVC", bundle: nil)
        self.index = index
        usersVC.entry = entry
        self.navigationController?.pushViewController(usersVC, animated: true)
        
    }
    
    func pop() {
        
        if let _ = self.presentedViewController as? UIAlertController {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
    }
    
}

extension AdminHoursListVC: AdminHoursViewUpdatable {
    
    func reload() {
        
        presenter.dismissAC()
        hoursTableView.reloadData()
        
    }
    
}

extension AdminHoursListVC: AdminHoursViewPresendable {
    
    func presentDay() -> DayRowItem {
        
        return day!
        
    }
    
    func showSignInEntryUserAC(index: Int) {
        
        if let day = presenter.data(at: index) {
            let title = i18n.newEntry
            let message = "\(i18n.signUpAt) \(day.time)?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let actionTitle = i18n.buttonYes
            let action = UIAlertAction(title: actionTitle, style: .default) { [weak self](action) in
                self?.presenter.showLoadingAC()
                self?.presenter.setCurrentUserInEntry(index: index)
            }
            let cancel = UIAlertAction(title: i18n.buttonCancel, style: .cancel, handler: nil)
            ac.addAction(action)
            ac.addAction(cancel)
            self.present(ac, animated: true)
        }
        
    }
    
    func showRemoveUserFromEntryAC(index: Int) {
        
        let title = i18n.removeClient
        let message = i18n.areYouSureRemoveClient
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionTitle = i18n.buttonYes
        let action = UIAlertAction(title: actionTitle, style: .default) { [weak self](action) in
            self?.presenter.showLoadingAC()
            self?.presenter.removeUserFromEntry(index: index)
        }
        let cancel = UIAlertAction(title: i18n.buttonCancel, style: .cancel, handler: nil)
        ac.addAction(action)
        ac.addAction(cancel)
        self.present(ac, animated: true)
        
    }
    
    func showLoadingAC() {
        
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
    
    func showClientShouldRemoveEntryTime() {
        
        let title = i18n.errorTitle
        let message = i18n.cancelEntryBefore
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionTitle = i18n.buttonOk
        let action = UIAlertAction(title: actionTitle, style: .cancel)
        ac.addAction(action)
        self.present(ac, animated: true)
        
    }
    
    func showClientWillRemoveEntryTimeAC(index: Int) {
        
        let title = i18n.buttonCancel
        let message = i18n.cancelEntry
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionTitle = i18n.buttonOk
        let action = UIAlertAction(title: actionTitle, style: .default) { [weak self](action) in
            self?.presenter.showLoadingAC()
            self?.presenter.removeUserFromEntry(index: index)
        }
        let cancel = UIAlertAction(title: i18n.buttonCancel, style: .cancel, handler: nil)
        ac.addAction(action)
        ac.addAction(cancel)
        self.present(ac, animated: true)
        
    }
    
}


