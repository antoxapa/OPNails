//
//  AdminHoursListVC.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/17/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

protocol AdminHoursViewUpdatable {
    
    func reload()
    
}

protocol AdminHoursViewRoutable {
    
    func showDetail()
    
}

protocol AdminHoursViewPresendable {
    
    func presentDay() -> DayRowItem
    func showSignInEntryUserAC(index: Int)
    
}

typealias AdminHoursViewable = AdminHoursViewUpdatable & AdminHoursViewRoutable & AdminHoursViewPresendable

class AdminHoursListVC: UIViewController {
    
    lazy var presenter: HoursPresenting = HoursPresenter(view: self)
    
    private let hoursTableView = UITableView()
    private var emptyLabel = UILabel()
    
    var day: DayRowItem?
    var admin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        setupNavBar()
        
        presenter.load()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateEditedEntry), name: .entriesEdited, object: nil)
        
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
        
        emptyLabel.text = "No entries"
        
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
    
    @objc private func updateEditedEntry() {
        
        presenter.load()
        
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

extension AdminHoursListVC: AdminHoursViewRoutable {
    
    func showDetail() {
        
        let detailVC = NewEntryVC(nibName: "NewEntryVC", bundle: nil)
        if day != nil {
            let month = "\(day!.monthNumber)"
            detailVC.date = "\(day!.day)-\(month)-\(day!.year)"
        }
        self.present(detailVC, animated: true)
        
    }
    
    func pop() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

extension AdminHoursListVC: AdminHoursViewUpdatable {
    
    func reload() {
        
        if let _ = self.navigationController?.presentedViewController {
            self.dismiss(animated: true, completion: nil)
        }
        
        hoursTableView.reloadData()
        
    }
    
}

extension AdminHoursListVC: AdminHoursViewPresendable {
    
    func presentDay() -> DayRowItem {
        
        return day!
        
    }
    
    func showSignInEntryUserAC(index: Int) {
        
        if let day = presenter.data(at: index) {
        let title = "New entry"
            let message = "Are you sure you want to sign up at \(day.time)?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let actionTitle = "Yes"
            let action = UIAlertAction(title: actionTitle, style: .default) { [weak self](action) in
                self?.showLoadingAC()
                self?.presenter.setUserInEntry(index: index)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(action)
            ac.addAction(cancel)
            self.present(ac, animated: true)
        }
        
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
    
}


