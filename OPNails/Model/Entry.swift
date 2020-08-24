//
//  Entry.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/24/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Entry {
    let time: String
    var userId: String?
    let ref: DatabaseReference?
    var complited: Bool = false
    
    init(time: String, userId: String) {
        self.time = time
        self.userId = userId
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String:AnyObject]
        time = snapshotValue["time"] as! String
//        time = snapshotValue["time"] as! String
        userId = snapshotValue["userId"] as? String
//        complited = snapshotValue["complited"] as! Bool
        ref = snapshot.ref
    }
}
