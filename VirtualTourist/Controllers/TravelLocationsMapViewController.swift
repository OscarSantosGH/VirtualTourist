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
    
    var pins:[Pin] = []
    
    // string use as a key to get the mapRegion save into UserDefault
    var persistedMapLocationKey:String = "persistedMapLocation"

    override func viewDidLoad() {
        super.viewDidLoad()
        // create a UILongPressGestureRecognizer to add it to the mapView
        let gesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(dropPinGesture(gesture:)))
        gesture.numberOfTouchesRequired = 1
        // add gesture to mapView
        mapView.addGestureRecognizer(gesture)
        mapView.delegate = self
        // try to load the map region in UserDefault
        loadPersistedMapRegion()
        // fetch the pins in CoreData
        fetchDataFromDataStore()
    }
    
    func fetchDataFromDataStore(){
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let result = try? PersistentManager.shared.viewContext.fetch(fetchRequest){
            pins = result
            updateMapPins()
        }
    }
    // display all the pins gotten from CoreDate
    func updateMapPins(){
        if !pins.isEmpty{
            var annotations:[MKAnnotation] = []
            for pin in pins{
                let annotation = TravelPin(pin: pin)
                annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
                annotations.append(annotation)
            }
            mapView.addAnnotations(annotations)
        }
    }
    // get call by long pressing the mapView
    @objc func dropPinGesture(gesture:UILongPressGestureRecognizer){
        // check if the gesture state begin
        if gesture.state == .began {
            let touch: CGPoint = gesture.location(in: self.mapView)
            let coordinate: CLLocationCoordinate2D = self.mapView.convert(touch, toCoordinateFrom: self.mapView)
            
            dropPin(coordinate: coordinate)
        }
    }
    // create and place a pin in the mapView
    func dropPin(coordinate:CLLocationCoordinate2D){
        // create a pin and set the coordinate
        let pin = Pin(context: PersistentManager.shared.viewContext)
        pin.latitude = coordinate.latitude
        pin.longitude = coordinate.longitude
        // create a TravelPin annotation with the created pin
        let annotation = TravelPin(pin: pin)
        annotation.coordinate = coordinate
        // create a feedback to mimic Apple's Maps behavior
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        do{
            // save the pin to CoreData
            try PersistentManager.shared.viewContext.save()
            // add the new pin in the pins array
            pins.append(pin)
            // add the annotation to the mapView
            mapView.addAnnotation(annotation)
        }catch{
            // present an alert if the pin couldn't be saved
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

//MARK: - MKMapViewDelegate
extension TravelLocationsMapViewController: MKMapViewDelegate{
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        setPersistedMapRegion()
    }
    // save the map region in UserDefault
    func setPersistedMapRegion(){
        let mapRegion = [
            "lat":mapView.centerCoordinate.latitude,
            "long":mapView.centerCoordinate.longitude,
            "latRegionDelta":mapView.region.span.latitudeDelta,
            "longRegionDelta":mapView.region.span.longitudeDelta
        ]
        UserDefaults.standard.set(mapRegion, forKey: persistedMapLocationKey)
    }
    // load the persisted map region from UserDefault
    func loadPersistedMapRegion(){
        guard let mapRegion = UserDefaults.standard.dictionary(forKey: persistedMapLocationKey) else {return}
        
        let location = mapRegion as! [String:CLLocationDegrees]
        let coordinate = CLLocationCoordinate2D(latitude: location["lat"]!, longitude: location["long"]!)
        let span = MKCoordinateSpan(latitudeDelta: location["latRegionDelta"]!, longitudeDelta: location["longRegionDelta"]!)
        
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is TravelPin else {return nil}
        
        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView

        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false

        } else {
            pinView!.annotation = annotation
        }

        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let travelPin = view.annotation as! TravelPin
        performSegue(withIdentifier: "photoAlbumSegue", sender: travelPin.pin)
        
        view.setSelected(false, animated: false)
    }
}
