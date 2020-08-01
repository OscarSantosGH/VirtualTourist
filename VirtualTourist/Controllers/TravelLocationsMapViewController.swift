//
//  TravelLocationsMapViewController.swift
//  VirtualTourist
//
//  Created by Oscar Santos on 7/21/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class TravelLocationsMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var canDropPin = true
    var photoAlbumViewController = PhotoAlbumViewController()
    
    var persistentManager:PersistentManager!
    var pins:[Pin] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(dropPinGesture(gesture:)))
        gesture.numberOfTouchesRequired = 1
        mapView.addGestureRecognizer(gesture)
        
        mapView.delegate = self
        fetchDataFromDataStore()
        addPhotoAlbumViewController()
    }
    
    func fetchDataFromDataStore(){
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        if let result = try? persistentManager.viewContext.fetch(fetchRequest){
            pins = result
            updateMapPins()
        }
    }
    
    func updateMapPins(){
        if pins.isEmpty{
            
        }else{
            var annotations:[MKAnnotation] = []
            for pin in pins{
                let coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
                let travelPin = TravelPin(coordinate: coordinate)
                annotations.append(travelPin)
            }
            mapView.addAnnotations(annotations)
        }
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
        let travelPin = TravelPin(coordinate: coordinate)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let pin = Pin(context: persistentManager.viewContext)
        pin.latitude = coordinate.latitude
        pin.longitude = coordinate.longitude
        do{
            try persistentManager.viewContext.save()
            pins.append(pin)
            mapView.addAnnotation(travelPin)
        }catch{
            presentVTAlert(title: "Error saving the location", message: error.localizedDescription)
        }
        
    }
    
    
    
    

    func showPhotoAlbumView(pinToShow:TravelPin){
        photoAlbumViewController.location = pinToShow.coordinate
        photoAlbumViewController.downloadPhotos()
        
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
