//
//  TravelLocationsMapViewController.swift
//  VirtualTourist
//
//  Created by Oscar Santos on 7/21/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationsMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var canDropPin = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let gesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(dropPinGesture(gesture:)))
        gesture.numberOfTouchesRequired = 1
        mapView.addGestureRecognizer(gesture)
    }
    
    @objc func dropPinGesture(gesture:UILongPressGestureRecognizer){
        
        if gesture.state == .began {
            canDropPin = false
            dropPin()
            
            let touch: CGPoint = gesture.location(in: self.mapView)
            let coordinate: CLLocationCoordinate2D = self.mapView.convert(touch, toCoordinateFrom: self.mapView)

            self.mapView.setCenter(coordinate, animated: true)

        }else{
            canDropPin = true
        }
    }
    
    func dropPin(){
        print("pin dropped")
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
