//
//  DataServicePlist.swift
//  NoteTours
//
//  Created by Ngọc Anh on 6/28/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import Foundation

class DataService {
    
    static let shared : DataService = DataService()
    var cityCode : Int?
    
    // Cities
    private var _cities: [City]?
    var cities: [City] {
        get {
            if _cities == nil {
                getDataCities()
            }
            return _cities ?? []
        }
        set {
            _cities = newValue
        }
    }
    
    func getDataCities() {
        _cities = []
        guard let dictionary = PlistService().getDataPlist(plist: "Cities.plist") else { return }
        guard let cityDictionaries = dictionary["Cities"] as? [DIC] else { return}
        for cityDictionary in cityDictionaries {
            if let city = City(dictionary: cityDictionary) {
                _cities?.append(city)
            }
        }
    }
    // Districts
    private var _districts: [Districts]?
    var distrists: [Districts] {
        get {
            if _districts == nil {
                getDataDistricts()
            }
            return _districts?.filter { $0.cityCode == self.cityCode } ?? []
        }
        set {
            _districts = newValue
        }
    }
    
    
    func getDataDistricts() {
        _districts = []
        guard let dictionary = PlistService().getDataPlist(plist: "Districts.plist") else { return  }
        guard let districtDictionaries = dictionary["Districts"] as? [DIC] else { return  }
        for districtsDictionary in districtDictionaries{
            if let district = Districts(dictionary: districtsDictionary) {
                _districts? .append(district)
            }
        }
    }
}
