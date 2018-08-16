//
//  ViewController.swift
//  CityBike
//
//  Created by Святослав Спорыхин on 27.04.2018.
//  Copyright © 2018 Worksolutions. All rights reserved.
//

import UIKit
import Alamofire
import GooglePlaces
import GoogleMaps
import Polyline

extension CitiBykeController: CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
//        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        self.location.latitude = location.coordinate.latitude
        self.location.longitude = location.coordinate.longitude
        self.location.isActive = true
        self.location.changeText("Current location")
        mapView.isMyLocationEnabled = true
//        mapView.settings.myLocationButton = true
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        // 8
        locationManager.stopUpdatingLocation()
    }
    
    
    
}

class CitiBykeController: UIViewController, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate{
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var buttonLocation: UIButton!
    @IBOutlet weak var getDirections: UIButton!
    
    @IBOutlet weak var heightFieldStreet: NSLayoutConstraint!
    
    @IBOutlet weak var location: placesButton!
    @IBOutlet weak var whereGo: placesButton!
    
    private let locationManager: CLLocationManager = CLLocationManager()
    
    var buttonPlace: placesButton?
    var polyline: GMSPolyline?
    var citiBikeStation: ClassCitiBike?
    var routeObject: ClassRoute?
    
    var start: (Double, Double) = (40.76244987,-73.96331107)
    var end: (Double, Double) = (40.7736457, -73.9609112)

    @IBAction func location(_ sender: UIButton) {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        var camera: GMSCameraPosition = GMSCameraPosition.init()
        
        self.polyline?.map = nil
        
        self.buttonPlace?.changeText(place.formattedAddress!)
        self.buttonPlace?.longitude = place.coordinate.longitude
        self.buttonPlace?.latitude = place.coordinate.latitude
        self.buttonPlace?.isActive = true
        
        if self.location.isActive && self.whereGo.isActive {
            let testObject: WorkingWithCoordinates = WorkingWithCoordinates.init((location.latitude!, location.longitude!), (whereGo.latitude!, whereGo.longitude!))
            testObject.createRegion()
            
            let pathArray: GMSMutablePath = GMSMutablePath()
            
            let path1: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: testObject.region!.bottomLeft.0, longitude: testObject.region!.bottomLeft.1)
            let path2: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: testObject.region!.bottomRight.0, longitude: testObject.region!.bottomRight.1)
            let path3: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: testObject.region!.upLeft.0, longitude: testObject.region!.upLeft.1)
            let path4: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: testObject.region!.upRight.0, longitude: testObject.region!.upRight.1)
            
            pathArray.add(path1)
            pathArray.add(path2)
            pathArray.add(path3)
            pathArray.add(path4)
            pathArray.add(path1)
            
            let marker1: GMSMarker = GMSMarker()
            let marker2: GMSMarker = GMSMarker()
            let marker3: GMSMarker = GMSMarker()
            let marker4: GMSMarker = GMSMarker()
            
            marker1.position = path1
            marker2.position = path2
            marker3.position = path3
            marker4.position = path4
            
            marker1.icon = #imageLiteral(resourceName: "granicy")
            marker2.icon = #imageLiteral(resourceName: "granicy")
            marker3.icon = #imageLiteral(resourceName: "granicy")
            marker4.icon = #imageLiteral(resourceName: "granicy")
            
            marker1.map = self.mapView
            marker2.map = self.mapView
            marker3.map = self.mapView
            marker4.map = self.mapView
            
            GMSPolygon(path: pathArray).map = self.mapView
            
            let arrayVariant: Array<(latitude: Double, longitude: Double)> = testObject.returnAllowableCoordinates(self.citiBikeStation!)
            if arrayVariant.count != 0 {
                self.routeObject = testObject.returnRoute(arrayVariant)
            }
            
            self.location.marker?.map = nil
            self.location.marker = GMSMarker()
            
            self.whereGo.marker?.map = nil
            self.whereGo.marker = GMSMarker()
            
            self.location.marker!.position = CLLocationCoordinate2D(latitude: self.location.latitude!, longitude: self.location.longitude!)
            self.location.marker?.isFlat = true
            self.location.marker!.map = mapView
            
            self.whereGo.marker!.position = CLLocationCoordinate2D(latitude: self.whereGo.latitude!, longitude: self.whereGo.longitude!)
            self.whereGo.marker?.isFlat = true
            self.whereGo.marker!.map = mapView
            
            let bounds: GMSCoordinateBounds = GMSCoordinateBounds(coordinate: location.marker!.position, coordinate: whereGo.marker!.position)
            camera = mapView.camera(for: bounds, insets: UIEdgeInsets())!
            let arrayState: Array<UIControlState> = [.normal, .focused, .selected]
            for state in arrayState{
                self.getDirections.setImage(#imageLiteral(resourceName: "directionOn"), for: state)
            }
        } else {
            self.buttonPlace?.marker = GMSMarker()
            self.buttonPlace?.marker?.isFlat = true
            self.buttonPlace?.marker?.position = CLLocationCoordinate2D(latitude: self.buttonPlace!.latitude!, longitude: self.buttonPlace!.longitude!)
            self.buttonPlace?.marker?.map = mapView
            camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 17.0)
        }
        
        mapView.camera = camera
        mapView.moveCamera(GMSCameraUpdate.zoomOut())
        viewController.dismiss(animated: true)
                let client: GMSPlacesClient = GMSPlacesClient()
                client.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
                    if let error = error {
                        print("Pick Place error: \(error.localizedDescription)")
                        return
                    }
        
                    if let placeLikelihoodList = placeLikelihoodList {
                        for likelihood in placeLikelihoodList.likelihoods {
                            let place = likelihood.place
                            print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                            print("Current Place address \(place.formattedAddress)")
                            print("Current Place attributions \(place.attributions)")
                            print("Current PlaceID \(place.placeID)")
                        }
                    }
                })
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true)
        self.buttonPlace?.changeText(buttonPlace!.constText)
        self.buttonPlace?.isActive = false
        self.buttonPlace?.marker?.map = nil
        print("Cancel")
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.location.customInit()
        self.whereGo.customInit()
        
        let latitude: CLLocationDegrees = 40.72619215
        let longitude: CLLocationDegrees = -73.99275517
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 14.0)

        self.location.constText = "Where do you go from?"
        self.whereGo.constText = "Where to go?"
        
        self.location.changeText(location.constText)
        self.whereGo.changeText(whereGo.constText)
        
        Alamofire.request("https://gbfs.citibikenyc.com/gbfs/en/station_information.json").responseJSON{ [weak self]
            response in
            switch response.result {
            case .success(_):
                let answer: NSDictionary = try! JSONSerialization.jsonObject(with: response.data!) as! NSDictionary
                self?.citiBikeStation = ClassCitiBike.init(answer)
                for mar in self!.citiBikeStation!.data{
                    let marker: GMSMarker = GMSMarker()
                    marker.icon = #imageLiteral(resourceName: "markerBicycle")
                    marker.position = CLLocationCoordinate2D(latitude: mar.latitude, longitude: mar.longitude)
                    marker.map = self?.mapView
                }
            case .failure(_):
                print("false")
            }
        }
    }
    
    func callPlacesList() {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    @IBAction func direction(_ sender: UIButton) {
        if self.location.isActive && self.whereGo.isActive {
            
            //let url: String = "https://maps.googleapis.com/maps/api/directions/json?origin=\(self.location.latitude!),\(self.location.longitude!)&destination=\(self.whereGo.latitude!),\(self.whereGo.longitude!)&mode=walking&key=AIzaSyD4e0VH9jdvatTqs5g52aUNNsE_jYlGG_s"
            
            let url: String = "https://maps.googleapis.com/maps/api/directions/json?origin=\(routeObject!.startDota.latitude),\(routeObject!.startDota.longitude)&destination=\(routeObject!.endDota.latitude),\(routeObject!.endDota.longitude)&waypoints=optimize:true%7Cvia:\(routeObject!.applicantStartDota.latitude)%2C\(routeObject!.applicantStartDota.longitude)%7Cvia:\(routeObject!.applicantEndDota.latitude)%2C\(routeObject!.applicantEndDota.longitude)&mode=bicycling&key=AIzaSyD4e0VH9jdvatTqs5g52aUNNsE_jYlGG_s"
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).responseJSON { response in
                switch response.result {
                case .success(_):
                    let ui = try! JSONSerialization.jsonObject(with: response.data!)
                    let io: NSDictionary = ui as! NSDictionary
                    print("kl")
                    let routes: Array<NSDictionary> = io.value(forKey: "routes") as! Array<NSDictionary>
                    let legs: Array<NSDictionary> = routes.first?.value(forKey: "legs") as! Array<NSDictionary>
                    let steps: Array<NSDictionary> = legs.first?.value(forKey: "steps") as! Array<NSDictionary>
                    let path: GMSMutablePath = GMSMutablePath()
                    path.add(CLLocationCoordinate2D(latitude: self.location.latitude!, longitude: self.location.longitude!))
                    for end_location in steps {
                        let end: NSDictionary = end_location.value(forKey: "polyline") as! NSDictionary
                        let decodeCoordinates: [CLLocationCoordinate2D]? = decodePolyline(end.value(forKey: "points") as! String)
                        if decodeCoordinates != nil {
                            for coordinate in decodeCoordinates! {
                                path.add(coordinate)
                            }
                        }
                    }
                    self.polyline?.map = nil
                    self.polyline = GMSPolyline(path: path)
                    self.polyline?.map = self.mapView
                case .failure(_):
                    print("false")
                }
            }
        }
    }
    
    @IBAction func locationAction(_ sender: placesButton) {
        self.buttonPlace = sender
        self.callPlacesList()
    }
    
}
//20






















