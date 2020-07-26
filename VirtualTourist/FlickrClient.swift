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
    
    
    class func getPhotosFromLocation(lat:Double, long:Double, page:Int = 1, completion: @escaping ([FKRPhotoResponse]?, Error?)->Void){
        guard let url = URL(string: Endpoints.getPhotos.stringValue + "&lat=" + String(lat) + "&lon=" + String(long) + "&page=" + String(page)) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do{
                let response = try decoder.decode(FKRPhotosSearchResponse.self, from: data)
                let photos = response.photos
                DispatchQueue.main.async {
                    completion(photos.photo, nil)
                }
            }catch{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
