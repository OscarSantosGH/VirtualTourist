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
    // property created to use this class as a singleton
    static let shared = PersistentManager(modelName: "VirtualTourist")
    
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init(modelName:String){
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil){
        persistentContainer.loadPersistentStores { [weak self] (storeDescription, error) in
            guard let self = self else {return}
            guard error == nil else{
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext()
            completion?()
        }
    }
}

extension PersistentManager{
    func autoSaveViewContext(interval:TimeInterval = 10){
        guard interval > 0 else {return}
        if viewContext.hasChanges{
            viewContext.saveOrRollback()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak self] in
            guard let self = self else {return}
            self.autoSaveViewContext()
        }
    }
}
