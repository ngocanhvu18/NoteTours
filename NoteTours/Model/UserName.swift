//
//  UserName.swift
//  NoteTours
//
//  Created by ngocanh on 7/4/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct UserName {
    let ref:  DatabaseReference?
    let name: String
    let email: String
    let url: String
    init(name: String, email: String, url: String) {
        ref = nil
        self.email = email
        self.name = name
        self.url = url
    }
    init?(snapShort: DataSnapshot) {
        guard let value = snapShort.value as? DIC else { return nil }
        guard let name = value["name"] as? String else { return nil }
        guard let email = value["email"] as? String else { return nil }
        guard let url = value["url"] as? String else { return nil }
        ref = snapShort.ref
        self.name = name
        self.email = email
        self.url = url
    }
}
