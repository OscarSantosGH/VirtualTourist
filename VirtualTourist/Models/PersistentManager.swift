//
//  PersistentManager.swift
//  VirtualTourist
//
//  Created by Oscar Santos on 7/30/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation
import CoreData

class PersistentManager{
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName:String){
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil){
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else{
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
}
