//
//  Places.swift
//  NoteTours
//
//  Created by NgọcAnh on 7/10/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import Foundation
class Places {
    var name: String
    var image: String
    var content: String
    init(name: String, image: String, content: String) {
        self.name = name
        self.image = image
        self.content = content
    }
    convenience init?(dictionary: DIC) {
        guard let name = dictionary["name"] as? String, let image = dictionary["image"] as? String, let content = dictionary["content"] as? String else { return nil }
        self.init(name: name, image: image, content: content)
    }
}
