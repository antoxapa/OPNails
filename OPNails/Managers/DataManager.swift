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
    var entry: Entry!
    var ref: DatabaseReference!
    var entries = Array<Entry>()
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
        }
        
    }
    
    func removeObservers() {
        
        ref.removeAllObservers()
        
    }
    
    func showEntries() -> [Entry] {
        
        return entries
        
    }
    
    func checkCurrentUser() {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = OPUser(user: currentUser)
        
    }
    
    func addNewEntry(date: String, time: String) {
        
        let title = date + " " + time
        ref = Database.database().reference(withPath: "entries").child(title)
        ref.setValue(["time": time, "date":date, "userId": ""])
        
    }
    
    func updateEntryWithUser(entry: EntryRowItem) {
        
        let entryString = "\(entry.date) \(entry.time)"
        var newEntry = entry
        newEntry.user = user.uid
        guard let key = ref.child(entryString).key else { return }
        let post = ["date": newEntry.date,
                    "time": newEntry.time,
                    "userId": newEntry.user]
        let childUpdates = ["\(key)": post]
        ref.updateChildValues(childUpdates)
        
    }
    
}
