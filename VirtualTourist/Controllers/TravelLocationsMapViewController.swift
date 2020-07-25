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
    var photoAlbumViewController = PhotoAlbumViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(dropPinGesture(gesture:)))
        gesture.numberOfTouchesRequired = 1
        mapView.addGestureRecognizer(gesture)
        
        mapView.delegate = self
        
        addPhotoAlbumViewController()
    }
    
    func addPhotoAlbumViewController() {
        // 1- Add bottomSheetVC as a child view
        self.addChild(photoAlbumViewController)
        self.view.addSubview(photoAlbumViewController.view)
        photoAlbumViewController.didMove(toParent: self)

        // 2- Adjust bottomSheet frame and initial position.
        let height = view.frame.height
        let width  = view.frame.width
        photoAlbumViewController.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
    @objc func dropPinGesture(gesture:UILongPressGestureRecognizer){
        
        if gesture.state == .began {
            canDropPin = false
            
            let touch: CGPoint = gesture.location(in: self.mapView)
            let coordinate: CLLocationCoordinate2D = self.mapView.convert(touch, toCoordinateFrom: self.mapView)
            //self.mapView.setCenter(coordinate, animated: true)
            
            dropPin(coordinate: coordinate)

        }else{
            canDropPin = true
        }
    }
    
    func dropPin(coordinate:CLLocationCoordinate2D){
        let pin = TravelPin(coordinate: coordinate)
        mapView.addAnnotation(pin)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    

    func showPhotoAlbumView(pinToShow:TravelPin){
        var mapRect = mapView.visibleMapRect
        let pinPos = MKMapPoint.init(pinToShow.coordinate)
        mapRect.origin.x = pinPos.x - mapRect.size.width * 0.5
        mapRect.origin.y = pinPos.y - mapRect.size.height * 0.15
        mapView.setVisibleMapRect(mapRect, animated: true)
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else {return}
            let height = self.view.frame.height
            let width  = self.view.frame.width
            self.photoAlbumViewController.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        }
    }

}

extension TravelLocationsMapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        showPhotoAlbumView(pinToShow: view.annotation as! TravelPin)
    }
}
