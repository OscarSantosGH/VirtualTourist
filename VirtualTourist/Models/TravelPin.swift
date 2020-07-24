//
//  TravelPin.swift
//  VirtualTourist
//
//  Created by Oscar Santos on 7/23/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import UIKit
import MapKit

class TravelPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
