//
//  workWithApiCitiBike.swift
//  CityBike
//
//  Created by Святослав Спорыхин on 03.05.2018.
//  Copyright © 2018 Worksolutions. All rights reserved.
//

import Foundation

class ClassCitiBike: NSObject {
    
    var data: Array<dataClassCitiBike> = [dataClassCitiBike]()
    
    init(_ dict: NSDictionary) {
        let arrayData: Array<Dictionary<String,Any>> = (dict.value(forKey: "data") as! NSDictionary).value(forKey: "stations") as! Array<Dictionary<String,Any>>
        for dictTest in arrayData {
            let citi: dataClassCitiBike = dataClassCitiBike.init(dictTest["lat"] as! Double, dictTest["lon"] as! Double)
            self.data.append(citi)
        }
    }
}

class dataClassCitiBike: NSObject {
    
    let longitude: Double
    let latitude: Double
    
    init(_ lat: Double, _ lon: Double) {
        self.latitude = lat
        self.longitude = lon
    }
    
}







