//
//  DataFireBase.swift
//  NoteTours
//
//  Created by Ngọc Anh on 7/2/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import Foundation
import FirebaseDatabase
typealias DICT = Dictionary<AnyHashable, Any>

struct UserDefaults {
    let ref: DatabaseReference?
    let user: String
    let passwood: String
    
}

