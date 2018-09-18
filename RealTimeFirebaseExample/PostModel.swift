//
//  PostModel.swift
//  RealTimeFirebaseExample
//
//  Created by Elizabeth Rudenko on 17.09.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import Firebase
import FirebaseDatabase

struct PostModel {
    var id: String
    var name: String
    var description: String

    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        id = snapshot.key
        name = snapshotValue["name"] as? String ?? ""
        description = snapshotValue["description"] as? String ?? ""
    }
}
