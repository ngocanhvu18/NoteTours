//
//  PlistService.swift
//  NoteTours
//
//  Created by Ngọc Anh on 6/28/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import Foundation

class City {
    
    var name: String
    var cityCode: Int
    
    init(name: String, cityCode: Int) {
        self.name = name
        self.cityCode = cityCode
    }
    
    convenience init?(dictionary: DIC) {
        guard let name = dictionary["Name"] as? String, let cityCode = dictionary["CityCode"] as? Int else { return nil }
        self.init(name: name, cityCode: cityCode)
    }
}
