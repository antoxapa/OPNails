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

protocol FirebaseAuthenticating {
    
    func checkUserLogged(closure: @escaping () -> Void)
    func signIn(withEmail email: String, password: String, completion: @escaping () -> Void, onError: @escaping (Error) -> Void)
    func signOut(onError: @escaping (Error) -> Void)
    func reauthenticateUser(password: String, onError: @escaping (Error?) -> Void)
    func registerUser(withEmail email: String, password: String, name: String, phoneNumber: String, completion: @escaping () -> Void, onError: @escaping (Error) -> Void)
    
}

protocol FirebaseUpdating {
    
    func addNewEntry(date: String, time: String)
    func add(user: OPUser, to entry: EntryRowItem)
    func reloadCurrentUser (onError: @escaping (Error) -> ())
    func removeUser(fromEntry entry: EntryRowItem)
    func removeEntry(_ entry: EntryRowItem)
    func updateEntryWithUser(entry: EntryRowItem)
    
}

protocol FirebaseModelUpdating {
    
    func changePassword(newPassword: String, oldPassword: String, completion: @escaping () -> Void, onError: @escaping (Error?) -> Void)
    func changeEmail(newEmail: String, password: String, completion: @escaping () -> Void, onError: @escaping (Error?) -> Void)
    func changeUserName(to name: String, completion: @escaping () -> Void)
    func changeUserPhoneNumber(to number: String, completion: @escaping () -> Void)
    
}

protocol FirebasePresenting {
    
    func showEntries() -> [Entry]
    func showUsers() -> [OPUser]
    func updateCurrentUser()
    func returnCurrentUser() -> OPUser?
    func returnFirebaseUser() -> User?
    func getEntryUser(entry: Entry) -> OPUser?
    func containsCurrentUser() -> Bool
    func isCurrentUserAdmin() -> Bool
    
}

protocol FirebaseModelObserving {
    
    func downloadItems(completion: @escaping () -> Void)
    func downloadUsers(completion: @escaping () -> Void)
    func removeObservers()
    
}

typealias FirebaseManaging = FirebaseAuthenticating & FirebaseUpdating & FirebaseModelUpdating & FirebasePresenting & FirebaseModelObserving

final class FirebaseManager {
    
    var user: OPUser!
    var ref: DatabaseReference?
    var userRef: DatabaseReference?
    var entries = Array<Entry>()
    var users = Array<OPUser>()
    
}

extension FirebaseManager: FirebaseModelObserving {
    
    func downloadItems(completion: @escaping () -> Void) {
        
        ref = Database.database().reference(withPath: "entries")
        ref?.observe(.value) { [weak self] (snapshot) in
            var _entries = [Entry]()
            for item in snapshot.children {
                let entry = Entry(snapshot: item as! DataSnapshot)
                _entries.append(entry)
            }
            self?.entries = _entries
            self?.downloadUsers {
                completion()
            }
        }
        
    }
    
    func downloadUsers(completion: @escaping () -> Void) {
        
        userRef = Database.database().reference(withPath: "users")
        userRef?.observe(.value) { [weak self] (snapshot) in
            var _users = [OPUser]()
            for item in snapshot.children {
                let user = OPUser(snapshot: item as! DataSnapshot)
                _users.append(user)
            }
            self?.users = _users
            
            completion()
        }
        
    }
    
    func removeObservers() {
        
        if ref != nil {
            ref?.removeAllObservers()
        }
        if userRef != nil {
            userRef?.removeAllObservers()
        }
        
    }
    
}

extension FirebaseManager: FirebaseAuthenticating {
    
    func checkUserLogged(closure: @escaping () -> Void) {
        
        Auth.auth().addStateDidChangeListener { (_, user) in
            guard let _ = user else { return }
            closure()
        }
        
    }
    
    func signIn(withEmail email: String, password: String, completion: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard let error = error else {
                completion()
                return
            }
            onError(error)
        }
        
    }
    
    func signOut(onError: @escaping (Error) -> Void) {
        
        do {
            try Auth.auth().signOut()
        } catch {
            onError(error)
        }
        
    }
    
    func reauthenticateUser(password: String, onError: @escaping (Error?) -> Void) {
        
        guard let currentEmail = Auth.auth().currentUser?.email else { return }
        let credential = EmailAuthProvider.credential(withEmail: currentEmail, password: password)
        
        Auth.auth().currentUser?.reauthenticate(with: credential) { (_ , error) in
            
            if error != nil {
                onError(error)
                return
                
            }
            
        }
        
    }
    
    func registerUser(withEmail email: String, password: String, name: String, phoneNumber: String, completion: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            
            guard let error = error else {
                self?.ref = Database.database().reference(withPath: "users")
                let userRef = self?.ref?.child((user?.user.uid)!)
                userRef?.setValue(["uid":user?.user.uid,"name":name, "phoneNumber":phoneNumber])
                completion()
                return
            }
            onError(error)
            
        }
        
    }
    
}

extension FirebaseManager: FirebaseUpdating {
    
    func addNewEntry(date: String, time: String) {
        
        let title = date + " " + time
        ref = Database.database().reference(withPath: "entries").child(title)
        ref?.setValue(["time": time, "date":date, "userId": ""])
        
    }
    
    func reloadCurrentUser (onError: @escaping (Error) -> ()) {
        
        Auth.auth().currentUser?.reload { (error) in
            
            guard let error = error else {
                return
            }
            onError(error)
        }
        
    }
    
    func removeUser(fromEntry entry: EntryRowItem) {
        
        let entryString = "\(entry.date) \(entry.time)"
        var newEntry = entry
        newEntry.user = user
        guard let key = ref?.child(entryString).key else { return }
        let post = ["date": newEntry.date,
                    "time": newEntry.time,
                    "userId": ""]
        let childUpdates = ["\(key)": post]
        ref?.updateChildValues(childUpdates)
        
    }
    
    func removeEntry(_ entry: EntryRowItem) {
        
        let entryString = "\(entry.date) \(entry.time)"
        ref = Database.database().reference(withPath: "entries").child(entryString)
        ref?.removeValue()
        
    }
    
    func add(user: OPUser, to entry: EntryRowItem) {
        
        let entryString = "\(entry.date) \(entry.time)"
        var newEntry = entry
        newEntry.user = user
        guard let key = ref?.child(entryString).key else { return }
        let post = ["date": newEntry.date,
                    "time": newEntry.time,
                    "userId": newEntry.user?.uid]
        let childUpdates = ["\(key)": post]
        ref?.updateChildValues((childUpdates))
        
    }
    
    func updateEntryWithUser(entry: EntryRowItem) {
        
        let entryString = "\(entry.date) \(entry.time)"
        var newEntry = entry
        newEntry.user = user
        guard let key = ref?.child(entryString).key else { return }
        let post = ["date": newEntry.date,
                    "time": newEntry.time,
                    "userId": newEntry.user?.uid]
        let childUpdates = ["\(key)": post]
        ref?.updateChildValues(childUpdates)
        
    }
    
}

extension FirebaseManager: FirebaseModelUpdating {
    
    func changeUserName(to name: String, completion: @escaping () -> Void) {
        
        if containsCurrentUser() {
            let uid = Auth.auth().currentUser!.uid
            let thisUserRef = self.userRef?.child(uid)
            let thisUserEmailRef = thisUserRef?.child("name")
            thisUserEmailRef?.setValue(name)
        }
        completion()
        
    }
    
    func changeUserPhoneNumber(to number: String, completion: @escaping () -> Void) {
        
        if containsCurrentUser() {
            let uid = Auth.auth().currentUser!.uid
            let thisUserRef = self.userRef?.child(uid)
            let thisUserEmailRef = thisUserRef?.child("phoneNumber")
            thisUserEmailRef?.setValue(number)
        }
        completion()
        
    }
    
    func changeEmail(newEmail: String, password: String, completion: @escaping () -> Void, onError: @escaping (Error?) -> Void) {
        
        reauthenticateUser(password: password) { (error) in
            
            onError(error)
            return
            
        }
        
        Auth.auth().currentUser?.updateEmail(to: newEmail) { (error) in
            
            if error != nil {
                onError(error)
                return
            }
            completion()
            
        }
        
    }
    
    func changePassword(newPassword: String, oldPassword: String, completion: @escaping () -> Void, onError: @escaping (Error?) -> Void) {
        
        reauthenticateUser(password: oldPassword) { (error) in
            
            onError(error)
            return
            
        }
        
        Auth.auth().currentUser?.updatePassword(to: newPassword) { (error) in
            
            if error != nil {
                onError(error)
                return
            }
            completion()
            
        }
        
    }
    
}

extension FirebaseManager: FirebasePresenting {
    
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
    
    func isCurrentUserAdmin() -> Bool {
        
        return Auth.auth().currentUser?.uid == Constants.API.USER_ID
        
    }
    
}
