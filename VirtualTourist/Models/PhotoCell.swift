//
//  PhotoCell.swift
//  VirtualTourist
//
//  Created by Oscar Santos on 7/24/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // helper URL to check if the photo URL that make the call to the Flickr API is the same that's came back
    var imageURLPath: URL?
    
    func setImage(photo:Photo){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        guard let url = photo.url else {return}
        imageURLPath = url
        FlickrClient.shared.getPhotoImage(url: url) { [weak self] (image) in
            guard let self = self else {return}
            if self.imageURLPath == url{
                guard let imageUnwrapped = image else {return}
                self.photoImageView.image = imageUnwrapped
                photo.image = imageUnwrapped.jpegData(compressionQuality: 1)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }else{
                return
            }
            
        }
    }

}
