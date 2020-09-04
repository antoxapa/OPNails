//
//  HoursPresenter.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/18/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation

protocol HoursPresenterTableViewPresenting {
    
    func numberOfCells(in section: Int) -> Int
    func data(at row: Int) -> EntryRowItem?
    func didSelectCell(at row: Int) -> Void
    func checkCurrentUserRow(row: EntryRowItem) -> Bool
    
}

protocol HoursPresentereRouting {
    
    func presentDetailVC()
    
}

protocol PresenterViewObserving {
    
    func addNotificationObservers()
    func removeNotificationObservers()
    
}

protocol PresenterModelUpdating {
    
    func setCurrentUserInEntry(index: Int)
    func setUserInEntry(index: Int, user: OPUser)
    func removeUserFromEntry(index: Int)
    func removeEntry(index: Int)
    
}

typealias HoursPresenting = HoursPresenterTableViewPresenting & HoursPresentereRouting & PresenterLifecycle & PresenterViewUpdating & PresenterModelUpdating & PresenterViewObserving

final class HoursPresenter: PresenterLifecycle {
    
    private var fireManager: FirebaseManaging
    private var view: AdminHoursViewable
    var entries = [Entry]()
    var users = [OPUser]()
    var satisfEntries = [EntryRowItem]()
    var date: String = ""
    
    init(view: AdminHoursViewable) {
        
        fireManager = FirebaseManager()
        self.view = view
        
    }
    
    func setup() {
        
        let day = view.presentDay()
        date = "\(day.day)-\(day.monthNumber)-\(day.year)"
        satisfEntries = [EntryRowItem]()
        for entry in entries {
            guard entry.date == date else { continue }
            
            var user = fireManager.getEntryUser(entry: entry)
            if !fireManager.isCurrentUserAdmin(), user?.uid != fireManager.returnCurrentUser()?.uid {
                user = nil
            }
            let newEntry = EntryRowItem(date: date, time: entry.time, user: user, isWorkday: user != nil)
            satisfEntries.append(newEntry)
        }
        
    }
    
    func load() {
        
        fireManager.downloadItems {
            self.update()
        }
        fireManager.downloadUsers {
            self.update()
        }
        fireManager.updateCurrentUser()
        
    }
    
    func cancel() {
        
        fireManager.removeObservers()
        
    }
    
}

extension HoursPresenter: PresenterViewUpdating {
    
    func update() {
        
        entries = fireManager.showEntries()
        users = fireManager.showUsers()
        setup()
        view.reload()
        
    }
    
    func showErrorAC(text: String) {
        
        
    }
    
    func dismissAC() {
        
    }
    
}

extension HoursPresenter: HoursPresenterTableViewPresenting {
    
    func numberOfCells(in section: Int) -> Int {
        
        return satisfEntries.count
        
    }
    
    func data(at row: Int) -> EntryRowItem? {
        
        return satisfEntries[row]
        
    }
    
    func didSelectCell(at row: Int) {
        
        if fireManager.isCurrentUserAdmin() {
            satisfEntries[row].user?.uid != nil ? view.showRemoveUserFromEntryAC(index: row) : view.showUsers(index: row)
        } else if satisfEntries[row].user?.uid == fireManager.returnCurrentUser()?.uid {
            
            view.showClientWillRemoveEntryTimeAC(index: row)
            
        } else {
            
            satisfEntries.contains(where: { (entry) -> Bool in
                entry.user?.uid == fireManager.returnCurrentUser()?.uid
                
            }) ? view.showClientShouldRemoveEntryTime() : view.showSignInEntryUserAC(index: row)
            
        }
        
    }
    
    func checkCurrentUserRow(row: EntryRowItem) -> Bool {
        
        return row.user?.uid == fireManager.returnCurrentUser()?.uid
        
    }
    
}

extension HoursPresenter: HoursPresentereRouting {
    
    func presentDetailVC() {
        
        view.showDetail()
        
    }
    
}

extension HoursPresenter: PresenterModelUpdating {
    
    func setCurrentUserInEntry(index: Int) {
        
        let entry = satisfEntries[index]
        fireManager.updateEntryWithUser(entry: entry)
        fireManager.downloadItems {
            self.update()
        }
        
    }
    
    func setUserInEntry(index: Int, user: OPUser) {
        
        let entry = satisfEntries[index]
        fireManager.add(user: user, to: entry)
        fireManager.downloadItems {
            self.update()
        }
        
    }
    
    func removeUserFromEntry(index: Int) {
        
        let entry = satisfEntries[index]
        fireManager.removeUser(fromEntry: entry)
        fireManager.downloadItems {
            self.update()
        }
        
    }
    
    func removeEntry(index: Int) {
        
        let entry = satisfEntries[index]
        fireManager.removeEntry(entry)
        fireManager.downloadItems {
            self.update()
        }
        
    }
    
}

extension HoursPresenter: PresenterViewObserving {
    
    func addNotificationObservers() {
        
        NotificationCenter.default.addObserver(view, selector: #selector(view.setUser(notification:)), name: .userSelected, object: nil)
        NotificationCenter.default.addObserver(view, selector: #selector(view.updateEditedEntry), name: .entriesEdited, object: nil)
        
    }
    
    func removeNotificationObservers() {
        
        NotificationCenter.default.removeObserver(view, name: .entriesEdited, object: nil)
        NotificationCenter.default.removeObserver(view, name: .userSelected, object: nil)
        
    }
    
}
