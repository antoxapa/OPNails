//
//  AdminMonthsVC.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

protocol AdminMonthViewUpdatable {
    //    func reload()
}

class AdminMonthsVC: UIViewController, AdminMonthViewUpdatable {
    
    private let monthsCollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let monthsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        monthsCollectionView.backgroundColor = .white
        return monthsCollectionView
    }()
    
    lazy var presenter = MonthPresenter(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        presenter.load()
    }
    
    private func setupViews() {
        monthsCollectionView.register(UINib(nibName: "MonthCell", bundle: nil), forCellWithReuseIdentifier: "MonthCell")
        monthsCollectionView.register(UINib(nibName: "MonthNameHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MonthHeader")
        monthsCollectionView.delegate = self
        monthsCollectionView.dataSource = self
        self.view.addSubview(monthsCollectionView)
        monthsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint .activate([
            monthsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            monthsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            monthsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            monthsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

extension AdminMonthsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfCells(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCell", for: indexPath) as? MonthCell else {
            return UICollectionViewCell()
        }
        
        if let item = presenter.data(at: indexPath.row) {
            cell.configure(withItem: item)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MonthHeader", for: indexPath)
        return headerView
    }
}

extension AdminMonthsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.bounds.size.width - 7) / 7
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 70)
    }
}
