//
//  AdminMonthsVC.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

class MonthsVC: UIViewController {
    
    private let monthsCollectionView: UICollectionView = {
        
        let viewLayout = UICollectionViewFlowLayout()
        let monthsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        monthsCollectionView.backgroundColor = .white
        return monthsCollectionView
        
    }()
    
    lazy var presenter: MonthPresenting = MonthPresenter(view: self)
    var isSelectStateActive: Bool = false
    var adminUser: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        setupNavBar()
        
        setupToolBar()
        
        presenter.setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.load()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.cancel()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        monthsCollectionView.collectionViewLayout.invalidateLayout()
        monthsCollectionView.reloadData()
        
    }
    
    private func setupViews() {
        
        monthsCollectionView.register(UINib(nibName: "DayCell", bundle: nil), forCellWithReuseIdentifier: "DayCell")
        monthsCollectionView.register(UINib(nibName: "EmptyCell", bundle: nil), forCellWithReuseIdentifier: "EmptyCell")
        monthsCollectionView.register(UINib(nibName: "MonthNameHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MonthHeader")
        
        monthsCollectionView.delegate = self
        monthsCollectionView.dataSource = self
        monthsCollectionView.allowsMultipleSelection = true
        
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
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if adminUser {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.addEntries))
        }
        
    }
    
    private func setupToolBar() {
        
        let today = UIBarButtonItem(title: "Today", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.showToday))
        self.setToolbarItems([today], animated: true)
        self.navigationController?.setToolbarHidden(false, animated: false)
        
    }
    
    @objc private func showToday() {
        
        presenter.showCurrentMonth()
        
    }
    
    @objc private func addNewEntry() {
        
        guard let indexPath = monthsCollectionView.indexPathsForSelectedItems else { return }
        presenter.addNewEntries(forDays: indexPath)
        
    }
    
    @objc private func addEntries() {
        
        isSelectStateActive = !isSelectStateActive
        if isSelectStateActive {
            let add = UIBarButtonItem(title: "Add time", style: .plain, target: self, action: #selector(self.addNewEntry))
            add.isEnabled = false
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            self.setToolbarItems([spacer ,spacer, add, spacer,spacer], animated: true)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(self.addEntries))
        } else {
            let today = UIBarButtonItem(title: "Today", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.showToday))
            self.setToolbarItems([today], animated: true)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.addEntries))
        }
        presenter.reloadView()
        
    }
    
}

extension MonthsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfCells(in: section)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row < presenter.skipCount() {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath)
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as? DayCell else { return UICollectionViewCell() }
        
        if let item = presenter.data(at: indexPath.row - presenter.skipCount()) {
            
            if isSelectStateActive {
                cell.selectModeActivate()
            } else {
                cell.selectModeDeactivate()
            }
            
            if presenter.compare(item: item) {
                cell.setupToday()
            } else {
                cell.setupDefault()
            }
            cell.configure(withItem: item)
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MonthHeader", for: indexPath) as? MonthNameHeaderView else { return UICollectionReusableView() }
        
        if let item = presenter.data(at: indexPath.row) {
            headerView.configure(withItem: item, presenter: presenter)
            
            if isSelectStateActive {
                headerView.hideRightButton()
            } else {
                headerView.showRightButton()
            }
            
            if presenter.compareMonthYear(item: item) {
                headerView.hideLeftButton()
            } else {
                headerView.showLeftButton()
            }
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !isSelectStateActive {
            presenter.didSelectCell(at: indexPath.row - presenter.skipCount())
            collectionView.deselectItem(at: indexPath, animated: false)
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as? DayCell {
                cell.isSelected ? cell.setSelectedState() : cell.setUnselectedState()
                if collectionView.indexPathsForSelectedItems?.count != 0 {
                    guard let items = self.toolbarItems else { return }
                    items[2].isEnabled = true
                }
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if collectionView.indexPathsForSelectedItems?.count == 0 && isSelectStateActive {
            guard let items = self.toolbarItems else { return }
            items[2].isEnabled = false
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? DayCell {
                cell.setSelectedState()
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? DayCell {
                cell.setUnselectedState()
            }
        }
        
    }
}

extension MonthsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (monthsCollectionView.frame.width - 20) / 7
        return CGSize(width: size, height: size)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: 100, height: 60)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        
    }
}

extension MonthsVC: MonthViewUpdatable {
    
    func reload() {
        
        monthsCollectionView.reloadData()
        
    }
    
    func reloadItemAt(indexPath: [IndexPath]?) {
        
        guard let index = indexPath else { return }
        monthsCollectionView.reloadItems(at: index)
        
    }
    
}

extension MonthsVC: MonthViewRoutable {
    
    func routeWithItem(item day: DayRowItem) {
        let dayVC = AdminHoursListVC()
        dayVC.day = day
        dayVC.admin = adminUser
        
        self.navigationController?.pushViewController(dayVC, animated: true)
    }
    
    func routeWithItems(items days: [DayRowItem]) {
        
        let entryVC = NewEntryVC(nibName: "NewEntryVC", bundle: nil)
        entryVC.days = days
        addEntries()
        self.present(entryVC, animated: true)
        
    }
    
}


