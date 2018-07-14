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
    
    @IBOutlet weak var goTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var toButton: UIButton!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var mapsView: GMSMapView!
    @IBOutlet weak var topContrainSliderMenu: NSLayoutConstraint!
    @IBOutlet weak var sliderMenu: UIView!
    
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
    var placesClient2: GMSPlacesClient!
    
    var zoomLevel: Float = 15.0
    var marker: GMSMarker!
    var myLocation: CLLocation?
    var source: GMSPlace?
    var checkIdentifer: Bool = true
 
    // Edit View Menu
    var isOpenSliderMenu: Bool = true {
        didSet {
            topContrainSliderMenu.constant = isOpenSliderMenu ? 0 : -(UIScreen.main.bounds.height * 1/5 + 20)
            UIView.animate(withDuration: 0.35) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapsView.settings.myLocationButton = true
        mapsView.settings.compassButton = true
        mapsView.isMyLocationEnabled = true
        placesClient = GMSPlacesClient.shared()
        placesClient2 = GMSPlacesClient()
         placeAutocomplete()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myLocation = mapsView.myLocation
       
        print(myLocation?.coordinate)
        locationData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //  Click Buttun Menu
    @IBAction func clickMenu(_ sender: Any) {
        isOpenSliderMenu = !isOpenSliderMenu
    }
    // hien thi vi toaj do diem den
    func placeAutocomplete() {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        placesClient2.autocompleteQuery("Mộc Châu (Sơn La)", bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                if let placeID = results[0].placeID {
                    self.placesClient2.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
                        if let error = error {
                            print("lookup place id query error: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let place = place else {
                            print("No place details for \(placeID)")
                            return
                        }
                        self.source = place
                        print("Place name \(place.name)")
                        print("Place address \(place.coordinate)")
                    })
                }
            }
            
        })
    }
    

    //MARK: POLYLINE
    // du lieu vi tri
    func locationData(){
        print(myLocation?.coordinate)
        print(source?.coordinate)
        getPolylineRoute(from: myLocation!.coordinate, to: source!.coordinate)
    }
    // truyen vi  tri len Service
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
                guard let overview_polyline = routes[0]["overview_polyline"] as? DICT else {return}
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
        isOpenSliderMenu = !isOpenSliderMenu
    }
    
    
}


extension MapsViewController: CLLocationManagerDelegate {
    // xu ly vi tri
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location :\(location)")
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        marker = nil
        if mapsView.isHidden {
            mapsView.isHidden = false
            mapsView.camera = camera
        } else {
            mapsView.animate(to: camera)
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
            mapsView.isHidden = false
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
    
    
//extension MapsViewController {
//
//    // Marker 2 vi tri
//    func markerSource(coordinate: CLLocationCoordinate2D) -> GMSMarker {
//        mapsView.clear()
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
//        marker.title = source?.name
//        marker.snippet = source?.formattedAddress ?? ""
//        marker.map = mapsView
//        return marker
//    }
//
//    func markerdestination(coordinate: CLLocationCoordinate2D) -> GMSMarker {
//        mapsView.clear()
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
//        marker.title = destination?.name
//        marker.snippet = destination?.formattedAddress ?? ""
//        marker.map = mapsView
//        return marker
//
//    }
//}

// "https://maps.googleapis.com/maps/api/directions/json?origin=21.032461191487627,105.76515889786882&destination=37.393179400000001,-122.07787610000001&sensor=false&mode=driving"
