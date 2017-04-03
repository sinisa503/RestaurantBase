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
    
    /** Class is made singleton **/
    static let sharedInstance = PerstistenceManager()
    private var appDelegate: AppDelegate?
    var context: NSManagedObjectContext?
    
    private init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
    }
    
    /** Clears all database **/
    func clearDatabase() {
        guard let context = context else {return}
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
    
    /** Only counts objects in database. Theese objects can not be used **/
    func countObjects(entityName: String, predicate: NSPredicate?) -> Int {
        guard let context = context else {return 0}
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
                
            }
        }
        return count
    }
    
    /** Method is checking if added restaurant is already contained in database and is updating database only if it's not **/
    func allRestaurantsFromDatabase() -> [Restoran]?{
        guard let context = context else {return nil}
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:DataBaseConstants.ENTITY_RESTAURANT)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest) as! [NSFetchRequestResult]
            if results.count > 0 {
                var array: [NSManagedObject] = []
                for result in results as! [NSManagedObject] {
                    array.append(result)
                }
                return array as? [Restoran]
            }
        }catch {
            return nil
        }
        return nil
    }
    
    /** Updates database with new restaurant **/
    func updateDatabaseWith(restaurant: Restaurant, andImage image:Data?) {
        if let context = context {
            let newRestaurant = NSEntityDescription.insertNewObject(forEntityName: DataBaseConstants.ENTITY_RESTAURANT, into: context)
            newRestaurant.setValue(restaurant.name, forKey: DataBaseConstants.NAME)
            newRestaurant.setValue(restaurant.address, forKey: DataBaseConstants.ADDRESS)
            newRestaurant.setValue(restaurant.longitude, forKey: DataBaseConstants.LONGITUDE)
            newRestaurant.setValue(restaurant.latitude, forKey: DataBaseConstants.LATITUDE)
            
            if let data = image {
                add(image: data, for: restaurant)
            }
            do {
                try context.save()
            }catch let err{
                print(err.localizedDescription)
            }
        }
    }
    
    /** Updates database with new image **/
    func add(image: Data?, for restaurant: Restaurant) {
        guard let context = context else {return}
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:DataBaseConstants.ENTITY_RESTAURANT)
        fetchRequest.predicate = NSPredicate(format: "address == %@", restaurant.address)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest) as! [NSFetchRequestResult]
            if results.count > 0 {
                if let rest = results.first as? Restoran {
                    rest.image = image as NSData?
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
