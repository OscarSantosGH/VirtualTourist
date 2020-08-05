//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Oscar Santos on 7/24/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    
    private var photos = [Photo]()
    var pin:Pin!
    var persistentManager:PersistentManager!
    // timer used to delay the animation of the zoom to the location
    var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        showLocation()
        checkPinPhotoCollection()
    }
    override func viewDidDisappear(_ animated: Bool) {
        photos = []
        collectionView.reloadData()
    }
    
    
    private func configureCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimunItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimunItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    
    private func showLocation(){
        // create a custom MKAnnotation for the Students Location
        let annotation = TravelPin(pin: pin)
        annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        // scheduled the timer to delay the zoom animation for 1 sec
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(zoomToLocation), userInfo: nil, repeats: false)
        mapView.isUserInteractionEnabled = false
        mapView.addAnnotation(annotation)
    }
    
    @objc func zoomToLocation(){
        // get the coordinate
        let coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        // create a CLLocationDistance to use it in the MKCoordinateRegion
        let distance:CLLocationDistance = 80_000
        // create a MKCoordinateRegion
        let mapRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        // set the region to the mapView and create the zoom animation
        mapView.setRegion(mapRegion, animated: true)
        // invalidate the timer
        timer.invalidate()
    }
    
    
    func checkPinPhotoCollection(){
        guard let pinCollection = pin.collection else {return}
        if pinCollection.isEmpty{
            downloadPhotos()
        }else{
            let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
            let predicate = NSPredicate(format: "photoCollection == %@", pinCollection)
            let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.predicate = predicate
            if let result = try? persistentManager.viewContext.fetch(fetchRequest){
                if result.isEmpty{
                    downloadPhotos()
                }else{
                    photos = result
                    collectionView.reloadData()
                }
            }
        }
    }
    
    
    
    private func downloadPhotos(){
        FlickrClient.shared.getPhotosFromLocation(lat: pin.latitude, long: pin.longitude) { [weak self] (photos, error) in
            guard let self = self else {return}
            if error != nil{
                if let fkrError = error as? FKRError{
                    self.presentVTAlert(title: fkrError.message, message: fkrError.errorDescription)
                }else{
                    self.presentVTAlert(title: "Something went wrong", message: error!.localizedDescription)
                }
            }else{
                guard let photos = photos else {return}
                if photos.isEmpty{
                    print("NO Photo Here")
                }else{
                    for photoResponse in photos{
                        let photo = Photo(context: self.persistentManager.viewContext)
                        photo.id = photoResponse.id
                        guard let url = URL(string: photoResponse.url) else {return}
                        photo.url = url
                        photo.photoCollection = self.pin.collection
                        self.photos.append(photo)
                        
                        
                    }
                    self.collectionView.reloadData()
                    do{
                       try self.persistentManager.viewContext.save()
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    


//    @IBAction func backAction(_ sender: Any) {
//        UIView.animate(withDuration: 0.5, animations: { [weak self] in
//            guard let self = self else {return}
//            let frame = self.view.frame
//            //let yComponent = UIScreen.main.bounds.height - 200
//            self.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: frame.width, height: frame.height)
//        }) { [weak self] (completed)  in
//            guard let self = self else {return}
//            if completed{
//                self.photos = []
//                self.collectionView.reloadData()
//            }
//        }
//    }
    
    @IBAction func newCollectionAction(_ sender: Any) {
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

//MARK: CollectionView Data Source
extension PhotoAlbumViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = photos[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.setImage(photo: photo, persistentManager: persistentManager)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
}

//MARK: CollectionView Delegate
extension PhotoAlbumViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoToDelete = photos[indexPath.row]
        persistentManager.viewContext.delete(photoToDelete)
        do{
            try persistentManager.viewContext.save()
            photos.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
        }catch{
            print("error deleting the Photo: \(error.localizedDescription)")
        }
        
    }
}
