//
//  PhotoCollection+Ext.swift
//  VirtualTourist
//
//  Created by Oscar Santos on 8/4/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import CoreData

extension PhotoCollection{
    // helper property to check if the photoCollection is empty
    var isEmpty: Bool{
        return photos?.count ?? 0 == 0
    }
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        // initiate the creationDate with the photoCollection creation time
        creationDate = Date()
    }
}
