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

typealias AdminHoursViewable = AdminHoursViewUpdatable & AdminHoursViewRoutable

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
        
        //        presenter.setup()
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
        hoursTableView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension AdminHoursListVC: AdminHoursViewRoutable {
    
    func showDetail() {
        
        let detailVC = NewEntryVC(nibName: "NewEntryVC", bundle: nil)
        if day != nil {
            let month = "\(day!.monthNumber)"
            detailVC.date = "\(day!.day)-\(month)-\(day!.year)"
        }
        self.navigationController?.showDetailViewController(detailVC, sender: self)
        
    }
    
}

extension AdminHoursListVC: AdminHoursViewUpdatable {
    
    func reload() {
        
        hoursTableView.reloadData()
        
    }
    
}
