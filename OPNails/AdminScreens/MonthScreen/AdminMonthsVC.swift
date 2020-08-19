//
//  AdminMonthsVC.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

protocol AdminMonthViewUpdatable {
    func reload()
}

protocol AdminMonthViewRoutable {
    func routeWithItem(item: DayRowItem)
}

typealias AdminMonthViewable = AdminMonthViewUpdatable & AdminMonthViewRoutable

class AdminMonthsVC: UIViewController {
    
    private let monthsCollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let monthsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        monthsCollectionView.backgroundColor = .white
        return monthsCollectionView
    }()
    
    lazy var presenter: MonthPresenting = MonthPresenter(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        setupNavBar()
        
        setupToolBar()
        
        presenter.setup()
        
    }
    
    private func setupViews() {
        monthsCollectionView.register(UINib(nibName: "DayCell", bundle: nil), forCellWithReuseIdentifier: "DayCell")
        monthsCollectionView.register(UINib(nibName: "MonthNameHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MonthHeader")
        
        monthsCollectionView.delegate = self
        monthsCollectionView.dataSource = self
        
        self.view.addSubview(monthsCollectionView)
        monthsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            monthsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            monthsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            monthsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            monthsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    
    private func setupNavBar() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.addEntries))
        
    }
    
    private func setupToolBar() {
        let today = UIBarButtonItem(title: "Today", style: UIBarButtonItem.Style.plain, target: self, action: #selector(showToday))
        //        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showToday))
        //        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        self.setToolbarItems([today], animated: true)
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    @objc private func showToday() {
        presenter.showCurrentMonth()
    }
    
    
    @objc private func addEntries() {
        
    }
}

extension AdminMonthsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfCells(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as? DayCell else { return UICollectionViewCell() }
        
        if let item = presenter.data(at: indexPath.row) {
            cell.configure(withItem: item)
            
            if presenter.compare(item: item) {
                cell.setupToday()
            } else {
                cell.setupDefault()
            }
            
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MonthHeader", for: indexPath) as? MonthNameHeaderView else { return UICollectionReusableView() }
        
        if let item = presenter.data(at: indexPath.row) {
            headerView.configure(withItem: item, presenter: presenter)
            
            if presenter.compareMonthYear(item: item) {
                headerView.hideLeftButton()
            } else {
                headerView.showLeftButton()
            }
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectCell(at: indexPath.row)
    }
}

extension AdminMonthsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.bounds.size.width - 20) / 7
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}

extension AdminMonthsVC: AdminMonthViewUpdatable {
    func reload() {
        monthsCollectionView.reloadData()
    }
    
}

// Not shure this is right for MVP
extension AdminMonthsVC: AdminMonthViewRoutable {
    func routeWithItem(item day: DayRowItem) {
        let dayVC = AdminHoursListVC()
        dayVC.day = day
        
        self.navigationController?.pushViewController(dayVC, animated: true)
    }
    
}
