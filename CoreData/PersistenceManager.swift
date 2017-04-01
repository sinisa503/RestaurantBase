//
//  PersistenceManager.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 29/03/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PerstistenceManager {
    
    static let sharedInstance = PerstistenceManager()
    
    private init() {}
    
    func updateRestaurantIfNotPresent (_ restaurant: Restaurant,_ context: NSManagedObjectContext) -> Restaurant?
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:DataBaseConstants.ENTITY_RESTAURANT)
        fetchRequest.predicate = NSPredicate(format: "address == %@", restaurant.address)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest) as! [NSFetchRequestResult]
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: DataBaseConstants.NAME) as? String{
                        print("\(name) already exists in database")
                    }
                }
                return restaurant
            } else {
                let newRestoran = NSEntityDescription.insertNewObject(forEntityName: DataBaseConstants.ENTITY_RESTAURANT, into: context)
                newRestoran.setValue(restaurant.name, forKey: DataBaseConstants.NAME)
                newRestoran.setValue(restaurant.address, forKey: DataBaseConstants.ADDRESS)
                newRestoran.setValue(restaurant.longitude, forKey: DataBaseConstants.LONGITUDE)
                newRestoran.setValue(restaurant.latitude, forKey: DataBaseConstants.LATITUDE)
                do {
                    try context.save()
                    print("\(restaurant.name) saved into database")
                }catch let err{
                    print(err.localizedDescription)
                }
            }
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
        return nil
    }
    
    func clearDatabase(_ context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:DataBaseConstants.ENTITY_RESTAURANT)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest) as! [NSFetchRequestResult]
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    context.delete(result)
                }
                do {
                    try context.save()
                }catch _ {
                    print("Error saveing to database")
                }
            }
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    func countObjects(entityName: String, predicate: NSPredicate?, context: NSManagedObjectContext) -> Int {
        var count: Int = 0
        context.performAndWait {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            
            if let predicate = predicate {
                fetchRequest.predicate = predicate
            }
            
            fetchRequest.resultType = NSFetchRequestResultType.countResultType
            do {
                count = try context.count(for: fetchRequest)
            } catch {
                //Assert or handle exception gracefully
            }
        }
        return count
    }
    
    func insertRestaurantToDatabase(restaurant: Restaurant, context: NSManagedObjectContext) {
        let newRestaurant = NSEntityDescription.insertNewObject(forEntityName: DataBaseConstants.ENTITY_RESTAURANT, into: context)
        newRestaurant.setValue(restaurant.name, forKey: DataBaseConstants.NAME)
        newRestaurant.setValue(restaurant.address, forKey: DataBaseConstants.ADDRESS)
        newRestaurant.setValue(restaurant.longitude, forKey: DataBaseConstants.LONGITUDE)
        newRestaurant.setValue(restaurant.latitude, forKey: DataBaseConstants.LATITUDE)
        
        let img:UIImage?
        if let imageString = restaurant.image {
            img = UIImage(named: imageString)
            if let image = img {
                newRestaurant.setValue(image, forKey: DataBaseConstants.IMAGE)
            }
        }

        do {
            try context.save()
            print("Saved!")
        }catch let err{
            print(err.localizedDescription)
        }
    }
}
