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

class FirebaseManager {
    
    var user: OPUser!
    var ref: DatabaseReference!
    var userRef: DatabaseReference!
    var entries = Array<Entry>()
    var users = Array<OPUser>()
    var presenter: PresenterViewUpdating
    
    init(presenter: PresenterViewUpdating) {
        
        self.presenter = presenter
        
    }
    
    func reloadCurrentUser() {
        
        Auth.auth().currentUser?.reload(completion: { [weak self] (error) in
            if error != nil {
                self?.presenter.showErrorAC(text: error!.localizedDescription)
                return
            }
        })
        
    }
    
    func isCurrentUserAdmin() -> Bool {
        
        return Auth.auth().currentUser?.uid == Constants.API.USER_ID
        
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
    
    func updateCurrentUser() {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = OPUser(user: currentUser)
        
    }
    
    func returnCurrentUser() -> OPUser? {
        
        guard let currentUser = Auth.auth().currentUser else { return nil }
        user = OPUser(user: currentUser)
        return user
        
    }
    
    func returnFirebaseUser() -> User? {
        
        guard let user = Auth.auth().currentUser else { return nil }
        return user
        
    }
    
    func getEntryUser(entry: Entry) -> OPUser? {
        
        for item in users {
            if item.uid == entry.userId {
                return item
            }
        }
        return nil
        
    }
    
    func containsCurrentUser() -> Bool {
        
        for user in users {
            if user.uid == returnCurrentUser()?.uid {
                return true
            }
        }
        return false
        
    }
    
    func addNewEntry(date: String, time: String) {
        
        let title = date + " " + time
        ref = Database.database().reference(withPath: "entries").child(title)
        ref.setValue(["time": time, "date":date, "userId": ""])
        
    }
    
    func removeUser(fromEntry entry: EntryRowItem) {
        
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
    
    func removeEntry(_ entry: EntryRowItem) {
        
        let entryString = "\(entry.date) \(entry.time)"
        ref = Database.database().reference(withPath: "entries").child(entryString)
        ref.removeValue()
        
    }
    
    func add(user: OPUser, to entry: EntryRowItem) {
        
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
            presenter.showErrorAC(text: error.localizedDescription)
        }
        
    }
    
    func changePassword(newPassword: String, oldPassword: String) {
        
        guard let currentEmail = Auth.auth().currentUser?.email else { return }
        let credential = EmailAuthProvider.credential(withEmail: currentEmail, password: oldPassword)
        
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { [weak self] (result, error) in
            if error != nil {
                guard let text = error?.localizedDescription else { return }
                self?.presenter.showErrorAC(text: text)
                return
            }
            
            Auth.auth().currentUser?.updatePassword(to: newPassword) { (error) in
                if error != nil {
                    guard let text = error?.localizedDescription else { return }
                    self?.presenter.showErrorAC(text: text)
                    return
                }
                self?.presenter.update()
            }
        })
        
    }
    
    func changeEmail(newEmail: String, password: String) {
        
        guard let currentEmail = Auth.auth().currentUser?.email else { return }
        let credential = EmailAuthProvider.credential(withEmail: currentEmail, password: password)
        
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { [weak self] (result, error) in
            if error != nil {
                guard let text = error?.localizedDescription else { return }
                self?.presenter.showErrorAC(text: text)
                return
            }
            
            Auth.auth().currentUser?.updateEmail(to: newEmail) { (error) in
                if error != nil {
                    guard let text = error?.localizedDescription else { return }
                    self?.presenter.showErrorAC(text: text)
                    return
                }
                self?.presenter.update()
            }
        })
        
    }
    
    func changeUserName(to name: String) {
        
        if containsCurrentUser() {
            let uid = Auth.auth().currentUser!.uid
            let thisUserRef = self.userRef.child(uid)
            let thisUserEmailRef = thisUserRef.child("name")
            thisUserEmailRef.setValue(name)
        }
        presenter.update()
        
    }
    
    func changeUserPhoneNumber(to number: String) {
        
        if containsCurrentUser() {
            let uid = Auth.auth().currentUser!.uid
            let thisUserRef = self.userRef.child(uid)
            let thisUserEmailRef = thisUserRef.child("phoneNumber")
            thisUserEmailRef.setValue(number)
        }
        presenter.update()
        
    }
    
}
