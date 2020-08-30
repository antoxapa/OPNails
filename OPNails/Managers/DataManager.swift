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
    
    func signOut() {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func changePassword(password: String) {
        
        Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
            
            print(error?.localizedDescription as Any)
            
        })
        
    }
    
    func changeEmail(email: String) {
        
        Auth.auth().currentUser?.updateEmail(to: email, completion: { [weak self] (error) in
            
            print(error?.localizedDescription as Any)
            if error == nil {
                if self?.users != nil {
                    for userWithDate in self!.users {
                        if userWithDate.uid == self?.returnCurrentUser()?.uid {
                            if let uid = userWithDate.uid {
                                guard let key = self?.userRef.child(uid).key else { return }
                                let post = ["email": email,
                                            "name": userWithDate.name,
                                            "phoneNumber": userWithDate.phoneNumber,
                                            "uid" : uid]
                                
                                let childUpdates = ["\(key)": post]
                                self?.userRef.updateChildValues(childUpdates)
                            }
                        }
                    }
                }
            }
        })
        
    }
    
    func changeUserName(name: String) {
        
        for userWithDate in users {
            if userWithDate.uid == returnCurrentUser()?.uid {
                if let uid = userWithDate.uid {
                    guard let key = userRef.child(uid).key else { return }
                    let post = ["email": userWithDate.email,
                                "name": name,
                                "phoneNumber": userWithDate.phoneNumber,
                                "uid" : uid]
                    
                    let childUpdates = ["\(key)": post]
                    userRef.updateChildValues(childUpdates)
                }
            }
        }
        
        
    }
    
    func changeUserPhoneNumber(number: String) {
        
        for userWithDate in users {
            if userWithDate.uid == returnCurrentUser()?.uid {
                if let uid = userWithDate.uid {
                    guard let key = userRef.child(uid).key else { return }
                    let post = ["email": userWithDate.email,
                                "name": userWithDate.name,
                                "phoneNumber": number,
                                "uid" : uid]
                    
                    let childUpdates = ["\(key)": post]
                    userRef.updateChildValues(childUpdates)
                }
            }
        }
        
    }
    
    //    func changeProfileInfo(name: String?, phone: String?, email: String?, password: String?) {
    //
    //        if let uid = returnCurrentUser()?.uid {
    //            guard let key = userRef.child(uid).key else { return }
    //            let post = ["email": email,
    //                        "name": name,
    //                        "phoneNumber": phone,
    //                        "uid" : uid]
    //
    //            let childUpdates = ["\(key)": post]
    //            userRef.updateChildValues(childUpdates)
    //
    //            if let password = password {
    //
    //                Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
    //
    //                    print(error?.localizedDescription as Any)
    //
    //                })
    //            }
    //
    //
    //        }
    
    //    }
    
    
    
}
