//
//  FKRPhotosResponse.swift
//  VirtualTourist
//
//  Created by Oscar Santos on 7/26/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation

struct FKRPhotosResponse: Codable {
    let page:Int
    let pages:Int
    let perpage:Int
    let total:String
    let photo:[FKRPhotoResponse]
}
