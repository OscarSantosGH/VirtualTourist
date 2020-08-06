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
    // timer used to delay the animation of the zoom to the location
    var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newCollectionButton.isEnabled = false
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
            pinCollection.currentPage = 1
            downloadPhotos()
        }else{
            let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
            let predicate = NSPredicate(format: "photoCollection == %@", pinCollection)
            let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.predicate = predicate
            if let result = try? PersistentManager.shared.viewContext.fetch(fetchRequest){
                photos = result
                collectionView.reloadData()
                if pinCollection.totalPages > 1{
                    newCollectionButton.isEnabled = true
                }
            }
        }
    }
    
    
    private func downloadPhotos(fromPage page:Int = 1){
        FlickrClient.shared.getPhotosFromLocation(lat: pin.latitude, long: pin.longitude, page: page) { [weak self] (collection, error) in
            guard let self = self else {return}
            if error != nil{
                if let fkrError = error as? FKRError{
                    self.presentVTAlert(title: fkrError.message, message: fkrError.errorDescription)
                }else{
                    self.presentVTAlert(title: "Something went wrong", message: error!.localizedDescription)
                    //self.photos = []
                    self.collectionView.reloadData()
                }
            }else{
                guard let photoCollection = collection else {return}
                self.pin.collection?.totalPages = Int16(photoCollection.pages)
                
                let photos = photoCollection.photo
                if photos.isEmpty{
                    print("NO Photo Here")
                }else{
                    for photoResponse in photos{
                        let photo = Photo(context: PersistentManager.shared.viewContext)
                        photo.id = photoResponse.id
                        guard let url = URL(string: photoResponse.url) else {return}
                        photo.url = url
                        photo.photoCollection = self.pin.collection
                        self.photos.append(photo)
                    }
                    self.collectionView.reloadData()
                    do{
                        try PersistentManager.shared.viewContext.save()
                    }catch{
                        print(error.localizedDescription)
                    }
                }
                
                if let totalPages = self.pin.collection?.totalPages{
                    if totalPages > 1{
                        self.newCollectionButton.isEnabled = true
                    }
                }
            }
        }
    }
    

    
    @IBAction func newCollectionAction(_ sender: Any) {
        newCollectionButton.isEnabled = false
        for photoToDelete in photos{
            PersistentManager.shared.viewContext.delete(photoToDelete)
        }
        do{
            try PersistentManager.shared.viewContext.save()
        }catch{
            print("error saving the context: \(error.localizedDescription)")
        }
        photos = []
        collectionView.reloadData()
        guard let photoCollection = pin.collection else {return}
        
        
        let currentPage:Int = Int(photoCollection.currentPage)
        let totalPages:Int = Int(photoCollection.totalPages)
        var randomPage:Int
            
        repeat{
            randomPage = Int.random(in: 1...totalPages)
        }while randomPage == currentPage
            
        photoCollection.currentPage = Int16(randomPage)
        downloadPhotos(fromPage: randomPage)
        
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
        cell.setImage(photo: photo)
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
        PersistentManager.shared.viewContext.delete(photoToDelete)
        do{
            try PersistentManager.shared.viewContext.save()
            photos.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
        }catch{
            print("error saving the context: \(error.localizedDescription)")
        }
        
    }
}
