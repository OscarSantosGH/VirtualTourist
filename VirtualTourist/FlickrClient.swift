//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Oscar Santos on 7/21/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation

class FlickrClient{
    static let apiKey = "9f464e9ce36ddd0bf813be86292a29d0"
    
    enum Endpoints{
       static let base = "https://www.flickr.com/services/rest/"
        
        case getPhotos
        
        var stringValue: String{
            switch self {
            case .getPhotos:
                return Endpoints.base + "?method=flickr.photos.search&api_key=" + FlickrClient.apiKey + "&nojsoncallback=1&format=json"
            }
        }
    }
    
    
    
}
