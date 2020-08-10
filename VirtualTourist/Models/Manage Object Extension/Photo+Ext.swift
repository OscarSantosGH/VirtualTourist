//
//  Photo+Ext.swift
//  VirtualTourist
//
//  Created by Oscar Santos on 8/2/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation
import CoreData

extension Photo{
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        // initiate the creationDate with the photo creation time
        creationDate = Date()
    }
}
