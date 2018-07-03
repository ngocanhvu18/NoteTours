//
//  Districts.swift
//  NoteTours
//
//  Created by Ngọc Anh on 6/28/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//
import Foundation

typealias DIC = Dictionary<AnyHashable,Any>

class PlistService {
    
    func getDataPlist(plist: String) -> DIC? {
        var result: DIC?
        let fileComponents = plist.components(separatedBy: ".")
        guard let filePath = Bundle.main.path(forResource: fileComponents.first ?? "", ofType: fileComponents.last ?? "") else {return nil}
        guard FileManager.default.fileExists(atPath: filePath) else {return nil}
        guard let data = FileManager.default.contents(atPath: filePath) else {return nil}
        do {
            guard let root =  try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil)  as? DIC else {return nil}
            result = root
        } catch  {
            print("PropertyListSerialization Error")
        }
        return result
    }
}
