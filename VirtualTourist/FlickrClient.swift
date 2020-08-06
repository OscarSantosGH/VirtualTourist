//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Oscar Santos on 7/21/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import UIKit

class FlickrClient{
    static let shared = FlickrClient()
    static let apiKey = "9f464e9ce36ddd0bf813be86292a29d0"
    //let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    enum Endpoints{
       static let base = "https://www.flickr.com/services/rest/"
        
        case getPhotos
        
        var stringValue: String{
            switch self {
            case .getPhotos:
                return Endpoints.base + "?method=flickr.photos.search&api_key=" + apiKey + "&nojsoncallback=1&format=json&per_page=50&extras=url_m"
            }
        }
    }
    
    
    func getPhotosFromLocation(lat:Double, long:Double, page:Int = 1, completion: @escaping (FKRPhotosResponse?, Error?)->Void){
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
                    completion(photos, nil)
                }
            }catch{
                DispatchQueue.main.async {
                    print("error decoding")
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    func getPhotoImage(url:URL, completion: @escaping (UIImage?)->Void){
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else{
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }
}
