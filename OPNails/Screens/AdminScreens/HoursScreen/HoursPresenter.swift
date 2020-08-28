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
    
}

protocol HoursPresentereRouting {
    
    func presentDetailVC()
    
}

protocol PresenterViewUpdating {
    
    func update()
    
}

protocol PresenterModelUpdating {
    
    func setUserInEntry(index: Int)
    
}

typealias HoursPresenting = HoursPresenterTableViewPresenting & HoursPresentereRouting & PresenterLifecycle & PresenterViewUpdating & PresenterModelUpdating

class HoursPresenter: PresenterLifecycle, PresenterViewUpdating {
    
    private lazy var dataManager = DataManager(presenter: self)
    private var view: AdminHoursViewable
    var entries = [Entry]()
    var users = [OPUser]()
    var satisfEntries = [EntryRowItem]()
    var date: String = ""
    
    init(view: AdminHoursViewable) {
        
        self.view = view
        
    }
    
    func setup() {
        
        let day = view.presentDay()
        var workday = day.isWorkday
        date = "\(day.day)-\(day.monthNumber)-\(day.year)"
        satisfEntries = [EntryRowItem]()
        for entry in entries {
            if entry.date == date {
                workday = true
                if dataManager.returnCurrentUser()?.email == "antoxapa@gmail.com" {
                    if let user = dataManager.checkIsUserEntry(entry: entry)  {
                        let newEntry = EntryRowItem(date: date, time: entry.time, user: user, isWorkday: false)
                        satisfEntries.append(newEntry)
                    } else {
                        let newEntry = EntryRowItem(date: date, time: entry.time, user: nil, isWorkday: workday)
                        satisfEntries.append(newEntry)
                    }
                } else {
                    if let user = dataManager.checkIsUserEntry(entry: entry) {
                        if user.uid == dataManager.returnCurrentUser()?.uid {
                            let newEntry = EntryRowItem(date: date, time: entry.time, user: user, isWorkday: false)
                            satisfEntries.append(newEntry)
                        }
                    } else {
                        let newEntry = EntryRowItem(date: date, time: entry.time, user: nil, isWorkday: workday)
                        satisfEntries.append(newEntry)
                    }
                }
            }
        }
    }
    
    
    func load() {
        
        dataManager.downloadItems()
        dataManager.downloadUsers()
        dataManager.getCurrentUser()
        
    }
    
    func cancel() {
        
        dataManager.removeObservers()
        
    }
    
    func update() {
        
        entries = dataManager.showEntries()
        users = dataManager.showUsers()
        setup()
        view.reload()
        
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
        
        if dataManager.user.email == "antoxapa@gmail.com" {
            print("admin")
        } else {
            for entry in satisfEntries {
                if satisfEntries[row].user?.uid == dataManager.returnCurrentUser()?.uid {
                    print("gotcha")
                } else if entry.user?.uid == dataManager.returnCurrentUser()?.uid {
                    print("deselect another entry")
                    
                } else {
                    view.showSignInEntryUserAC(index: row)
                }
                //            if entries[row].userId != nil && entries[row].userId == dataManager.returnCurrentUser()?.uid {
                //                print("no")
                //            } else {
                //
                //            }
            }
        }
        
    }
    
}

extension HoursPresenter: HoursPresentereRouting {
    
    func presentDetailVC() {
        
        view.showDetail()
        
    }
    
}

extension HoursPresenter: PresenterModelUpdating {
    
    func setUserInEntry(index: Int) {
        
        let entry = satisfEntries[index]
        dataManager.updateEntryWithUser(entry: entry)
        dataManager.downloadItems()
        
    }
    
}
