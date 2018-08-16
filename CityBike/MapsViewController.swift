//
//  MapsViewController.swift
//  CityBike
//
//  Created by Святослав Спорыхин on 07.05.2018.
//  Copyright © 2018 Worksolutions. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class MapsViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate {
    
    @IBOutlet weak var searchPlace: UITextField!
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Complete")
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Fail")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Cancel")
    }
    
    @IBAction func beginFixText(_ sender: UITextField) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
        
        //self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
}
