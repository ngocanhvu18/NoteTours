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
    let date: String
    let pass: String
    init(name: String, email: String, date: String, pass: String) {
        ref = nil
        self.email = email
        self.name = name
        self.date = date
        self.pass = pass
    }
    init?(snapShort: DataSnapshot) {
        guard let value = snapShort.value as? DIC else { return nil }
        guard let name = value["name"] as? String else { return nil }
        guard let email = value["email"] as? String else { return nil }
        guard let date = value["date"] as? String else { return nil }
        guard let pass = value["pass"] as? String else { return nil }
        ref = snapShort.ref
        self.name = name
        self.email = email
        self.date = date
        self.pass = pass
    }
    func toAnyObject() -> Any {
        return [
            "name": name,
            "email": email,
            "pass": pass,
            "date": date
        ]
    }
}
