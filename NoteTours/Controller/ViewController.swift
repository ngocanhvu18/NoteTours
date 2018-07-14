//
//  ViewController.swift
//  NoteTours
//
//  Created by Ngọc Anh on 7/14/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import UIKit
import GooglePlaces

class ViewController: UIViewController {
    var placesClient: GMSPlacesClient!
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient()
        placeAutocomplete()
    }
    
    func placeAutocomplete() {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        placesClient.autocompleteQuery("Mộc Châu (Sơn La)", bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                if let placeID = results[0].placeID {
                    self.placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
                        if let error = error {
                            print("lookup place id query error: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let place = place else {
                            print("No place details for \(placeID)")
                            return
                        }
                        
                        print("Place name \(place.name)")
                        print("Place address \(place.coordinate)")
                    })
                }
            }
        })
    }
}
