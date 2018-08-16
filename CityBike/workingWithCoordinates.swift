//
//  workingWithCoordinates.swift
//  CityBike
//
//  Created by Святослав Спорыхин on 31.05.2018.
//  Copyright © 2018 Worksolutions. All rights reserved.
//

import Foundation

class WorkingWithCoordinates: NSObject {
    
    let endPoint: (latitude: Double, longitude: Double)
    let startDota: (latitude: Double, longitude: Double)
    
    private var applicantsStartDota: Array<(latitude: Double, longitude: Double)> = [(Double, Double)]()
    private var applicantsEndDota: Array<(latitude: Double, longitude: Double)> = [(Double, Double)]()
    
    var region: (upLeft: (latitude: Double, longitude: Double), upRight: (latitude: Double, longitude: Double), bottomLeft: (latitude: Double, longitude: Double), bottomRight: (latitude: Double, longitude: Double))?
    
    var isMore: Bool = false
    
    init(_ start: (Double, Double), _ end: (Double, Double)) {
        startDota = start
        endPoint = end
    }
    
    func createRegion() {
        self.region = ((0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0))
        let bool1: Bool = endPoint.latitude < startDota.latitude
        let bool2: Bool = endPoint.longitude < startDota.longitude
        self.isMore = bool2
        
        
        if bool1 {
            region?.upLeft.0 = endPoint.latitude - 0.0002
            region?.upRight.0 = startDota.latitude + 0.0002
            region?.bottomLeft.0 = startDota.latitude + 0.0002
            region?.bottomRight.0 = endPoint.latitude - 0.0002
        } else {
            region?.upLeft.0 = endPoint.latitude + 0.0002
            region?.upRight.0 = startDota.latitude - 0.0002
            region?.bottomLeft.0 = startDota.latitude - 0.0002
            region?.bottomRight.0 = endPoint.latitude + 0.0002
        }
        
        if bool2 {
            region?.upRight.1 = startDota.longitude + 0.0018
            region?.upLeft.1 = startDota.longitude + 0.0018
            region?.bottomLeft.1 = endPoint.longitude - 0.0018
            region?.bottomRight.1 = endPoint.longitude - 0.0018
        } else {
            region?.upRight.1 = startDota.longitude - 0.0018
            region?.upLeft.1 = startDota.longitude - 0.0018
            region?.bottomLeft.1 = endPoint.longitude + 0.0018
            region?.bottomRight.1 = endPoint.longitude + 0.0018
        }
    }
    
    func returnAllowableCoordinates(_ array: ClassCitiBike) -> Array<(latitude: Double, longitude: Double)> {
        var arrayReturn: Array<(Double, Double)> = [(Double, Double)]()
        for coordinates in array.data {
            if isMore {
                
                let bool1: Bool = coordinates.latitude > region!.upLeft.latitude
                let bool2: Bool = coordinates.latitude < region!.upRight.latitude
                let bool3: Bool = coordinates.longitude > region!.bottomRight.longitude
                let bool4: Bool = coordinates.longitude < region!.upRight.longitude
                
                if bool1 && bool2 && bool3 && bool4 {
                    arrayReturn.append((coordinates.latitude, coordinates.longitude))
                }
            } else {
                
                let bool1: Bool = coordinates.latitude < region!.upLeft.latitude
                let bool2: Bool = coordinates.latitude > region!.upRight.latitude
                let bool3: Bool = coordinates.longitude < region!.bottomRight.longitude
                let bool4: Bool = coordinates.longitude > region!.upRight.longitude
                
                if bool1 && bool2 && bool3 && bool4 {
                    arrayReturn.append((coordinates.latitude, coordinates.longitude))
                }
            }
        }
        return arrayReturn
    }
    
    func returnNearestToBeginning(_ array: Array<(latitude: Double, longitude: Double)>){
        var options: Array<(latitude: Double, longitude: Double)> = array
        var applicant: (latitude: Double, longitude: Double)?
        var difference: (latitude: Double, longitude: Double)?
        var turnover: Int = 0
        var count: Int = 0
        
        let a: Double = array.first!.latitude - startDota.latitude
        let b: Double = array.first!.longitude - startDota.longitude
        
        var A1B1: Double = sqrt(((a) * (a)) + ((b) * (b)))
        
        if options.count > 5 {
            count = 5
        } else {
            count = options.count
        }
        
        while turnover < count {
            applicant = options.first!
            var indexApplicant: Int = 0
        if isMore {
            difference = (array.first!.latitude - startDota.latitude, array.first!.longitude - startDota.longitude)
        } else {
            difference = (startDota.latitude - array.first!.latitude, startDota.longitude - array.first!.longitude)
        }
        for index in 0..<options.count {
            
            let a1: Double = options[index].latitude - startDota.latitude
            let b1: Double = options[index].longitude - startDota.longitude
            
            let testA1B1: Double = sqrt(((a1) * (a1)) + ((b1) * (b1)))
            
            if A1B1 > testA1B1 {
                A1B1 = testA1B1
                indexApplicant = index
                applicant = options[index]
            }
        }
            options.remove(at: indexApplicant)
            applicantsStartDota.append(applicant!)
            turnover = turnover + 1
        }
    }
    
    func returnNearestToEnding(_ array: Array<(latitude: Double, longitude: Double)>){
        var options: Array<(latitude: Double, longitude: Double)> = array
        var applicant: (latitude: Double, longitude: Double)?
        var difference: (latitude: Double, longitude: Double)?
        var turnover: Int = 0
        var count: Int = 0
        
        let a: Double = array.first!.latitude - endPoint.latitude
        let b: Double = array.first!.longitude - endPoint.longitude
        
        var C1D1: Double = sqrt(((a) * (a)) + ((b) * (b)))
        
        if options.count > 5 {
            count = 5
        } else {
            count = options.count
        }
        
        while turnover < count {
            applicant = options.first!
            var indexApplicant: Int = 0
        for index in 0..<options.count {
            
            let a1: Double = options[index].latitude - endPoint.latitude
            let b1: Double = options[index].longitude - endPoint.longitude
            
            let testC1D1: Double = sqrt(((a1) * (a1)) + ((b1) * (b1)))
            
            if C1D1 > testC1D1 {
                C1D1 = testC1D1
                indexApplicant = index
                applicant = options[index]
            }
        }
            options.remove(at: indexApplicant)
            applicantsEndDota.append(applicant!)
            turnover = turnover + 1
        }
    }
    
    func returnRoute(_ array: Array<(latitude: Double, longitude: Double)>) -> ClassRoute {
        
        returnNearestToBeginning(array)
        returnNearestToEnding(array)
        
        var A1B1: Double = Double()
        var D1C1: Double = Double()
        
        var A1B1C1D1: Double?
        
        var routeObject: ClassRoute?
        
        //for index1 in 0..<applicantsStartDota.count{
            
            let a = startDota.latitude - applicantsStartDota[0].latitude
            let b = startDota.longitude - applicantsStartDota[0].longitude
            
            A1B1 = sqrt(((a) * (a)) + ((b) * (b)))
            
            //for index2 in 0..<applicantsEndDota.count {
                
                let a1 = applicantsStartDota[0].latitude - applicantsEndDota[0].latitude
                let b1 = applicantsStartDota[0].longitude - applicantsEndDota[0].longitude
                
                if a1 != 0 && b1 != 0 {
                
                let a2 = endPoint.latitude - applicantsEndDota[0].latitude
                let b2 = endPoint.longitude - applicantsEndDota[0].longitude
                
                D1C1 = sqrt(((a2) * (a2)) + ((b2) * (b2)))
                
                if A1B1C1D1 == nil || A1B1C1D1! > sqrt(((a1) * (a1)) + ((b1) * (b1))) + A1B1 + D1C1 {
                    A1B1C1D1 = sqrt(((a1) * (a1)) + ((b1) * (b1))) + A1B1 + D1C1
                    routeObject = ClassRoute.init(startDota, applicantsStartDota[0], endPoint, applicantsEndDota[0])
                }
            //}
            //}
        }
        return routeObject!
    }
    
}

//        let test = sqrt(((5.0 - -2.0) * (5.0 - -2.0)) + ((5.0 - 2.0) * (5.0 - 2.0)))
//        let a = test/sqrt(2.0)

class ClassRoute: NSObject {
    
    let startDota: (latitude: Double, longitude: Double)
    let applicantStartDota: (latitude: Double, longitude: Double)
    let endDota: (latitude: Double, longitude: Double)
    let applicantEndDota: (latitude: Double, longitude: Double)
    
    init(_ SDota: (latitude: Double, longitude: Double), _ ApplicSDota: (latitude: Double, longitude: Double), _ EDota: (latitude: Double, longitude: Double), _ ApplicEDota: (latitude: Double, longitude: Double)) {
        startDota = SDota
        applicantStartDota = ApplicSDota
        applicantEndDota = ApplicEDota
        endDota = EDota
    }
    
}











