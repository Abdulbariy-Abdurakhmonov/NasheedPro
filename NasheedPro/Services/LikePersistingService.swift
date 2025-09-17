//
//  LikePersistingService.swift
//  NasheedPro
//
//  Created by Abdulboriy on 26/07/25.
//

import Foundation
import CoreData

class LikePersistingService {
    private let container: NSPersistentContainer
    private let containerName: String = "LikedContainer"
    private let entityName: String = "LikedEntity"
    
    @Published var likedEntities: [LikedEntity] = []
    
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores {_, error in
            if let error {
                print("Error loading Core Data!: \(error)")
            }
            self.getLikedIds()
        }
    }
    
     func getLikedIds() {
        let request = NSFetchRequest<LikedEntity>(entityName: entityName)
        
        do {
           likedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching data: \(error)")
        }
    }
    
    
     func add(nasheed: NasheedModel) {
        let entity = LikedEntity(context: container.viewContext)
        entity.likedID = nasheed.id
        applyChanges()
        
    }
    
  
     func delete(entity: LikedEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    
     func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data: \(error)")
        }
    }
    
    
     func applyChanges() {
        save()
        getLikedIds()
    }
    
    
    
}
