//
//  DataServicePlist.swift
//  NoteTours
//
//  Created by Ngọc Anh on 6/28/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import Foundation
enum Regions: String {
    case nortArea = "I. Địa điểm phượt ở miền Bắc"
    case centralArea = "II. Địa điểm phượt ở miền Trung"
    case southArea = "III. Địa điểm phượt miền Nam"
    case westArea = "IV. Địa điểm phượt miền Tây"
    
    static func fromHashValue(hashValue: Int) -> Regions? {
        switch hashValue {
        case 0:
            return .nortArea
        case 1:
            return .centralArea
        case 2:
            return .southArea
        case 3:
            return .westArea
        default:
            return nil
        }
    }
}

class DataService {
    
    static let shared : DataService = DataService()
    
    private var _placesFirst: [Places]?
    var placesFirst: [Places] {
        get{
            if _placesFirst == nil {
                getPlacesFirst()
            }
            return _placesFirst ?? []
        }
        set{
            _placesFirst = newValue
        }
    }
    func getPlacesFirst()  {
        _placesFirst = []
        guard let dictionary = PlistService().getDataPlist(plist: "PlacesVietnam.plist") else { return  }
        guard let placesData = dictionary["I. Địa điểm phượt ở miền Bắc"] as? [DIC] else { return  }
        for dataPlaces in placesData {
            if let placesObject = Places (dictionary: dataPlaces) {
                _placesFirst?.append(placesObject)
            }
        }
    }
   //secondView
    private var _placesSecond: [Places]?
    var placesSecond: [Places] {
        get{
            if _placesSecond == nil {
                getPlacesSecond()
            }
            return _placesSecond ?? []
        }
        set{
            _placesSecond = newValue
        }
    }
    func getPlacesSecond()  {
        _placesSecond = []
        guard let dictionary = PlistService().getDataPlist(plist: "PlacesVietnam.plist") else { return  }
        guard let placesData = dictionary["II. Địa điểm phượt ở miền Trung"] as? [DIC] else { return  }
        for dataPlaces in placesData {
            if let placesObject = Places(dictionary: dataPlaces) {
                _placesSecond?.append(placesObject)
            }
        }
    }
    //thirdView
    private var _placesThird: [Places]?
    var placesThird: [Places] {
        get{
            if _placesThird == nil {
                getPlacesThird()
            }
            return _placesThird ?? []
        }
        set{
            _placesThird = newValue
        }
    }
    func getPlacesThird()  {
        _placesThird = []
        guard let dictionary = PlistService().getDataPlist(plist: "PlacesVietnam.plist") else { return  }
        guard let placesData = dictionary["III. Địa điểm phượt miền Nam"] as? [DIC] else { return  }
        for dataPlaces in placesData {
            if let placesObject = Places(dictionary: dataPlaces) {
                _placesThird?.append(placesObject)
            }
        }
    }
    //forthView
    private var _placesForth: [Places]?
    var placesForth: [Places] {
        get{
            if _placesForth == nil {
                getPlacesForth()
            }
            return _placesForth ?? []
        }
        set{
            _placesForth = newValue
        }
    }
    func getPlacesForth() {
        _placesForth = []
        guard let dictionary = PlistService().getDataPlist(plist: "PlacesVietnam.plist") else { return  }
        guard let placesData = dictionary["IV. Địa điểm phượt miền Tây"] as? [DIC] else { return  }
        for dataPlaces in placesData {
            if let placesObject = Places(dictionary: dataPlaces) {
                _placesForth?.append(placesObject)
            }
        }
    }
    }


