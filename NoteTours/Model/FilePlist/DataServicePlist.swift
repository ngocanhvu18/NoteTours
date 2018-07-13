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
    
    func getPlacesFirst(key: String, complete: ([Places])-> Void)  {
        var placesFirst: [Places] = []
        guard let dictionary = PlistService().getDataPlist(plist: "PlacesVietnam.plist") else { return  }
        guard let placesData = dictionary[key] as? [DIC] else { return  }
        for dataPlaces in placesData {
            if let placesObject = Places(dictionary: dataPlaces) {
                placesFirst.append(placesObject)
            }
        }
       complete(placesFirst)
        
        
    }
    

}


