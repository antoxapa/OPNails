//
//  User.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/24/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class OPUser {
    
    let uid: String?
    let phoneNumber: String?
    let name: String?
    
    init(user: User) {
        
        self.uid = user.uid
        self.phoneNumber = user.phoneNumber
        self.name = user.displayName
        
    }
    
    init(snapshot: DataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String:AnyObject]
        uid = snapshotValue["uid"] as? String
        phoneNumber = snapshotValue["phoneNumber"] as? String
        name = snapshotValue["name"] as? String
        
    }
    
}

enum ProfileInfoOption: Int {
    
    case username = 0
    case phoneNumber
    case email
    case password
    
}
