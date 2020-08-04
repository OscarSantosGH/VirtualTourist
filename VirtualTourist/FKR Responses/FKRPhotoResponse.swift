//
//  FKRPhotoResponse.swift
//  VirtualTourist
//
//  Created by Oscar Santos on 7/26/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation

struct FKRPhotoResponse: Codable {
    let id:String
    let title:String
    let url:String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case url = "url_m"
    }
}
