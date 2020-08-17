//
//  AdminHoursListVC.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/17/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

class AdminHoursListVC: UIViewController {
    
    private let hoursTableView = UITableView()
    var day: DayRowItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        setupNavBar()
    }
    
    private func setupViews() {
        
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
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
            
            emptyLabel.centerYAnchor.constraint(equalTo: hoursTableView.centerYAnchor, constant: -60),
            emptyLabel.centerXAnchor.constraint(equalTo: hoursTableView.centerXAnchor),
        ])
        
    }
    
    private func setupNavBar() {
        if day != nil {
            self.navigationItem.title = "\(day!.month) \(day!.day), \(day!.year)"
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.addNewEntry))
        
    }
    
    @objc private func addNewEntry() {
        
    }
}

extension AdminHoursListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HoursCell", for: indexPath) as? HoursCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension AdminMonthsVC {
    
    
}
