//
//  NSManagedObjectContext+Ext.swift
//  VirtualTourist
//
//  Created by Oscar Santos on 8/1/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import CoreData

extension NSManagedObjectContext{
    public func saveOrRollback(){
        
        if hasChanges{
            do {
                try save()
            } catch {
                rollback()
            }
        }
        
    }
}
