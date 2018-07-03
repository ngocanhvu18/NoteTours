//
//  Districst.swift
//  NoteTours
//
//  Created by Ngọc Anh on 6/29/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import Foundation

class Districts {
    var cityCode : Int
    var districtCode : Int
    var name : String
    init(cityCode: Int, districtCode: Int, name: String) {
        self.cityCode = cityCode
        self.districtCode = districtCode
        self.name = name
    }
    
    convenience init?(dictionary: DIC) {
        guard let name = dictionary["Name"] as? String, let cityCode = dictionary["CityCode"] as? Int, let districtCode = dictionary["DistrictCode"] as? Int else { return nil }
        self.init(cityCode: cityCode, districtCode: districtCode, name: name)
    }
}
