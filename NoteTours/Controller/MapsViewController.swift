//
//  MapsViewController.swift
//  NoteTours
//
//  Created by Ngọc Anh on 7/5/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation
typealias DICT = Dictionary<AnyHashable, Any>

class MapsViewController: UIViewController {
    
    @IBOutlet weak var mapsView: GMSMapView!
    
    var isStopUpdateLocation: Bool = false
    
    var locationManager: CLLocationManager = {
        var locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
        return locationManager
    }()
    
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
 
    
    var zoomLevel: Float = 15
    var marker: GMSMarker!

    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient()
        locationManager.delegate = self
//        placeAutocomplete()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // hien thi vi toaj do diem den
    func placeAutocomplete(with source: CLLocationCoordinate2D) {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        placesClient.autocompleteQuery("Mộc Châu", bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let placeID = results?.first?.placeID {
                self.getCoordinatePlace(placeID: placeID, result: { des in
                    self.getPolylineRoute(from: source, to: des)
                })
            }
        })
    }
    
    func getCoordinatePlace(placeID: String, result: @escaping (CLLocationCoordinate2D)->Void) {
        placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(placeID)")
                return
            }
            DispatchQueue.main.async {
                result(place.coordinate)
            }
        })

    }

    //MARK: POLYLINE

    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving")!
        
        let task = URLSession.shared.dataTask(with: url,completionHandler: { (data, reponse, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let objectData = data else {return}
            do{
                guard let reuslts = try JSONSerialization.jsonObject(with: objectData, options: .mutableContainers) as? DICT else {return}
                guard let routes = reuslts["routes"] as? [DICT] else{ return}
                guard let overview_polyline = routes.first?["overview_polyline"] as? DICT else {return}
                guard let points = overview_polyline["points"] as? String else {return}
                DispatchQueue.main.async {
                    self.showPath(polyStr: points)
                }
            }
            catch{
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    // Polyline (duong chi dan )
    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.geodesic = true
        
        polyline.strokeColor = UIColor.blue
        polyline.map = mapsView
        let bunds = GMSCoordinateBounds(path:path!)
        let cameraUpdat = GMSCameraUpdate.fit(bunds, with: UIEdgeInsets(top: 40, left: 15, bottom: 10, right: 15))
        self.mapsView.animate(with: cameraUpdat)
    }
}


extension MapsViewController: CLLocationManagerDelegate {
    // xu ly vi tri
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location: CLLocation = locations.last {
            locationManager.stopUpdatingLocation()
            if !isStopUpdateLocation {
                isStopUpdateLocation = true
                placeAutocomplete(with: location.coordinate)
            }
        }
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted")
        case .denied:
            print("User denied access to location")
            // Display the map using the default location.
        case .notDetermined:
            print("Location status not determined")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

