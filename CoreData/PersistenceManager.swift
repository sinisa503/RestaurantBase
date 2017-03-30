//
//  PersistenceManager.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 29/03/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation
import CoreData

class PerstistenceManager {
    
    static let sharedInstance = PerstistenceManager()
    
    private init() {}
    
    static func updateRestaurantIfNotPresent (_ restaurant: Restaurant,_ context: NSManagedObjectContext) -> Restaurant?
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:DataBaseConstants.RESTORAN)
        fetchRequest.predicate = NSPredicate(format: "address == %@", restaurant.address)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest) as! [NSFetchRequestResult]
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: DataBaseConstants.NAME) as? String{
                        print("\(restaurant.name) already exists in database")
                    }
                }
                return restaurant
            } else {
                let newRestoran = NSEntityDescription.insertNewObject(forEntityName: DataBaseConstants.RESTORAN, into: context)
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
    
}
