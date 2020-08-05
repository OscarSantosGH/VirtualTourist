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
    var pins:[Pin] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(dropPinGesture(gesture:)))
        gesture.numberOfTouchesRequired = 1
        mapView.addGestureRecognizer(gesture)
        
        mapView.delegate = self
        fetchDataFromDataStore()
    }
    
    func fetchDataFromDataStore(){
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let result = try? PersistentManager.shared.viewContext.fetch(fetchRequest){
            pins = result
            print("pin result: \(result.count)")
            updateMapPins()
        }
    }
    
    func updateMapPins(){
        if pins.isEmpty{
            
        }else{
            var annotations:[MKAnnotation] = []
            for pin in pins{
                let annotation = TravelPin(pin: pin)
                annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
                annotations.append(annotation)
            }
            mapView.addAnnotations(annotations)
        }
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
        let pin = Pin(context: PersistentManager.shared.viewContext)
        pin.latitude = coordinate.latitude
        pin.longitude = coordinate.longitude
        
        let annotation = TravelPin(pin: pin)
        annotation.coordinate = coordinate
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        do{
            try PersistentManager.shared.viewContext.save()
            pins.append(pin)
            mapView.addAnnotation(annotation)
        }catch{
            presentVTAlert(title: "Error saving the location", message: error.localizedDescription)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoAlbumSegue"{
            let photoAlbumVC = segue.destination as! PhotoAlbumViewController
            photoAlbumVC.pin = sender as? Pin
        }
    }
    

}

extension TravelLocationsMapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is TravelPin else {return nil}
        
        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView

        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView?.markerTintColor = UIColor.red

        } else {
            pinView!.annotation = annotation
        }

        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let travelPin = view.annotation as! TravelPin
        performSegue(withIdentifier: "photoAlbumSegue", sender: travelPin.pin)
    }
}
