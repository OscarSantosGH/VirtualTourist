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
    let owner:String
    let secret:String
    let server:String
    let farm:Int
    let title:String
    let ispublic:Int
    let isfriend:Int
    let isfamily:Int
}
