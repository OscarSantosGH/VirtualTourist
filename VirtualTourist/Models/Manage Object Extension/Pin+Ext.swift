//
//  Pin+Ext.swift
//  VirtualTourist
//
//  Created by Oscar Santos on 8/2/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation
import CoreData

extension Pin {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
