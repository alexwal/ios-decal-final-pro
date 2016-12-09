//
//  LocationDelegate.swift
//  Activity
//
//  Created by awal on 12/9/16.
//  Copyright © 2016 Alex Walczak. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class LocationDelegate: NSObject, CLLocationManagerDelegate {
    var last:CLLocation?
    var speed = 0.0
    var distanceTraveled = 0.0
    
    override init() {
        super.init()
    }
    func processLocation(_ current:CLLocation) {
        guard last != nil else {
            last = current
            return
        }
        var gotSpeed = current.speed
        if (gotSpeed > 0) {
            print("...")
        } else {
            gotSpeed = last!.distance(from: current) / (current.timestamp.timeIntervalSince(last!.timestamp))
        }
        // update
        distanceTraveled += (last?.distance(from: current))!
        speed = gotSpeed
        last = current
    }
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            processLocation(location)
        }
    }
}
