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

class MapsViewController: UIViewController, AutoCompleteControllerDelegate {
    
    
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
    var zoomLevel: Float = 15.0
    var marker: GMSMarker!
    var source: GMSPlace?
    var destination: GMSPlace?
    var checkIdentifer: Bool = true
    
    // Edit View Menu
    var isOpenSliderMenu: Bool = false {
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
        
        
        // Clik View Menu
        topContrainSliderMenu.constant = -(UIScreen.main.bounds.height * 1/5 + 20)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //  Click Buttun Menu
    @IBAction func clickMenu(_ sender: Any) {
        isOpenSliderMenu = !isOpenSliderMenu
    }
    //MARK: POLYLINE
    // du lieu vi tri
    func locationData(){
        getPolylineRoute(from: source!.coordinate, to: destination!.coordinate)
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
    // gan du lieu
    func passingData(place: GMSPlace) {
        if checkIdentifer == true {
            source = place
            goTextField.text = "\(place.formattedAddress ?? "")"
            
        } else {
            destination = place
            toTextField.text = "\(place.formattedAddress ?? "")"
            
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15)
        
        mapsView.camera = camera
        mapsView.clear()
        if source != nil && destination != nil {
            let markerSource = GMSMarker()
            markerSource.position = CLLocationCoordinate2D(latitude: (source?.coordinate.latitude)!, longitude: (source?.coordinate.longitude)!)
            markerSource.icon = #imageLiteral(resourceName: "icons8-location_filled copy")
            markerSource.title = source?.name
            markerSource.snippet = source?.formattedAddress ?? ""
            markerSource.map = mapsView
            
            let markerDestination = GMSMarker()
            markerDestination.position = CLLocationCoordinate2D(latitude: (destination?.coordinate.latitude)!, longitude: (destination?.coordinate.longitude)!)
            markerDestination.icon = #imageLiteral(resourceName: "icons8-location_filled copy")
            markerDestination.title = destination?.name
            markerDestination.snippet = source?.formattedAddress ?? ""
            markerDestination.map = mapsView
            
            locationData()
            
        }
    }
    // truyen du lieu
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        checkIdentifer = segue.identifier == "goAdd"
        let nextViewController = segue.destination as? AutoCompleteController
        nextViewController?.delegate = self
    }
}

extension MapsViewController: CLLocationManagerDelegate {
    // xu ly vi tri
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation =  locations.last!
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        
        
        
        // danh dau vi tri
        
        marker = nil
        mapsView.clear()
        
        if mapsView.isHidden {
            mapsView.isHidden = false
            mapsView.camera = camera
        } else {
            mapsView.animate(to: camera)
        }
        
    }
    
    // Marker 2 vi tri
    func markerSource(coordinate: CLLocationCoordinate2D) -> GMSMarker {
        mapsView.clear()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.title = source?.name
        marker.snippet = source?.formattedAddress ?? ""
        marker.map = mapsView
        return marker
    }
    func markerdestination(coordinate: CLLocationCoordinate2D) -> GMSMarker {
        mapsView.clear()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.title = destination?.name
        marker.snippet = destination?.formattedAddress ?? ""
        marker.map = mapsView
        return marker
        
    }
    
    
}
