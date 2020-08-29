//
//  DataManager.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/24/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class DataManager {
    
    var user: OPUser!
    var ref: DatabaseReference!
    var userRef: DatabaseReference!
    var entries = Array<Entry>()
    var users = Array<OPUser>()
    var presenter: PresenterViewUpdating
    
    init(presenter: PresenterViewUpdating) {
        
        self.presenter = presenter
        
    }
    
    func downloadItems() {
        
        ref = Database.database().reference(withPath: "entries")
        ref.observe(.value) { [weak self](snapshot) in
            var _entries = [Entry]()
            for item in snapshot.children {
                let entry = Entry(snapshot: item as! DataSnapshot)
                _entries.append(entry)
            }
            self?.entries = _entries
            self?.presenter.update()
            self?.downloadUsers()
        }
        
    }
    
    func downloadUsers() {
        
        userRef = Database.database().reference(withPath: "users")
        userRef.observe(.value) { [weak self] (snapshot) in
            var _users = [OPUser]()
            for item in snapshot.children {
                let user = OPUser(snapshot: item as! DataSnapshot)
                _users.append(user)
            }
            self?.users = _users
            self?.presenter.update()
        }
        
    }
    
    func removeObservers() {
        
        if ref != nil {
            ref.removeAllObservers()
        }
        if userRef != nil {
            userRef.removeAllObservers()
            
        }
        
    }
    
    func showEntries() -> [Entry] {
        
        return entries
        
    }
    
    func showUsers() -> [OPUser] {
        
        return users
        
    }
    
    func getCurrentUser() {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = OPUser(user: currentUser)
        
    }
    
    func returnCurrentUser() -> OPUser? {
        
        guard let currentUser = Auth.auth().currentUser else { return nil }
        user = OPUser(user: currentUser)
        return user
        
    }
    
    func checkIsUserEntry(entry: Entry) -> OPUser? {
        
        for item in users {
            if item.uid == entry.userId {
                return item
            }
        }
        return nil
        
    }
    
    func addNewEntry(date: String, time: String) {
        
        let title = date + " " + time
        ref = Database.database().reference(withPath: "entries").child(title)
        ref.setValue(["time": time, "date":date, "userId": ""])
        
    }
    
    func removeUserFromEntry(entry: EntryRowItem) {
        
        let entryString = "\(entry.date) \(entry.time)"
        var newEntry = entry
        newEntry.user = user
        guard let key = ref.child(entryString).key else { return }
        let post = ["date": newEntry.date,
                    "time": newEntry.time,
                    "userId": ""]
        let childUpdates = ["\(key)": post]
        ref.updateChildValues(childUpdates)
        
    }
    
    func removeEntry(entry: EntryRowItem) {
        
        let entryString = "\(entry.date) \(entry.time)"
        ref = Database.database().reference(withPath: "entries").child(entryString)
        ref.removeValue()
        
    }
    
    func addUserToEntry(entry: EntryRowItem, user: OPUser) {
        
        let entryString = "\(entry.date) \(entry.time)"
        var newEntry = entry
        newEntry.user = user
        guard let key = ref.child(entryString).key else { return }
        let post = ["date": newEntry.date,
                    "time": newEntry.time,
                    "userId": newEntry.user?.uid]
        let childUpdates = ["\(key)": post]
        ref.updateChildValues((childUpdates))
        
    }
    
    func updateEntryWithUser(entry: EntryRowItem) {
        
        let entryString = "\(entry.date) \(entry.time)"
        var newEntry = entry
        newEntry.user = user
        guard let key = ref.child(entryString).key else { return }
        let post = ["date": newEntry.date,
                    "time": newEntry.time,
                    "userId": newEntry.user?.uid]
        let childUpdates = ["\(key)": post]
        ref.updateChildValues(childUpdates)
        
    }
    
}
