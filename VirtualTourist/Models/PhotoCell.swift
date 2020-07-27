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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setImage(photo:FKRPhotoResponse){
        FlickrClient.shared.getPhotoImage(farm: photo.farm, server: photo.server, id: photo.id, secret: photo.secret) { [weak self] (image) in
            guard let self = self else {return}
            guard let imageUnwrapped = image else {
                return
            }
            self.photoImageView.image = imageUnwrapped
        }
    }

}
