//
//  FKRPhotosSearchResponse.swift
//  VirtualTourist
//
//  Created by Oscar Santos on 7/26/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation

struct FKRPhotosSearchResponse: Codable {
    let photos:FKRPhotosResponse
    let stat:String
}
