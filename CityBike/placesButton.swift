//
//  placesButton.swift
//  CityBike
//
//  Created by Святослав Спорыхин on 29.05.2018.
//  Copyright © 2018 Worksolutions. All rights reserved.
//

import UIKit
import GoogleMaps

class placesButton: UIButton {
    
    var isHavePlace: Bool = false
    var isActive: Bool = false
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    var textPlaces: String = ""
    
    var marker: GMSMarker?
    var constText: String = ""
    
    func customInit() {
        self.initBackground()
        self.initTextAlignment()
    }
    
    func initTextAlignment() {
        self.titleLabel?.textAlignment = .left
        self.titleLabel?.textColor = UIColor.black
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
    }
    
    func initBackground() {
        self.layer.cornerRadius = 20.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        let arrayState: Array<UIControlState> = [.normal, .focused, .selected]
        for state in arrayState{
            self.setTitleColor(UIColor.lightGray, for: state)
        }
    }
    
    func changeText(_ text: String) {
        self.setTitle("  " + text, for: .normal)
        self.setTitle("  " + text, for: .selected)
        self.setTitle("  " + text, for: .focused)
    }
}
