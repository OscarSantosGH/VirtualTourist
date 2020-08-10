//
//  TravelPin.swift
//  VirtualTourist
//
//  Created by Oscar Santos on 7/23/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import MapKit
// custom MKAnnotation that store a Pin
class TravelPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pin:Pin
    
    init(pin: Pin) {
        
        self.pin = pin
        coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.latitude)
        super.init()
        
    }
}
