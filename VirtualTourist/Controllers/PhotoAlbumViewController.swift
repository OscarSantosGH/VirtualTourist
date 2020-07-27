//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Oscar Santos on 7/24/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var newCollectionButton: UIButton!
    
    var photos = [FKRPhotoResponse]()
    var location = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func configureCollectionView(){
        let nib = UINib(nibName: "PhotoCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "photoCell")
        collectionView.dataSource = self
        
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimunItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimunItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    func downloadPhotos(){
        FlickrClient.shared.getPhotosFromLocation(lat: location.latitude, long: location.longitude) { [weak self] (photos, error) in
            guard let self = self else {return}
            if error != nil{
                if let fkrError = error as? FKRError{
                    self.presentVTAlert(title: fkrError.message, message: fkrError.errorDescription)
                }else{
                    self.presentVTAlert(title: "Something went wrong", message: error!.localizedDescription)
                }
            }else{
                guard let photos = photos else {return}
                self.photos = photos
                self.collectionView.reloadData()
            }
        }
    }


    @IBAction func backAction(_ sender: Any) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else {return}
            let frame = self.view.frame
            //let yComponent = UIScreen.main.bounds.height - 200
            self.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: frame.width, height: frame.height)
        }
    }
    
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
