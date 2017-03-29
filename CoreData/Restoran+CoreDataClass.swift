//
//  Restoran+CoreDataClass.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 29/03/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(Restoran)
public class Restoran: NSManagedObject {
    
    static func updateRestaurantIfNotPresent (_ restaurant: Restaurant,_ context: NSManagedObjectContext) -> Restaurant?
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Restoran")
        fetchRequest.predicate = NSPredicate(format: "address == %@", restaurant.address)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest) as! [NSFetchRequestResult]
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let name = result.value(forKey: "name") as? String{
                                print("\(restaurant.name) already exists in database")
                        }
                    }
                    return restaurant
                } else {
                    let newRestoran = NSEntityDescription.insertNewObject(forEntityName: "Restoran", into: context)
                    newRestoran.setValue(restaurant.name, forKey: "name")
                    newRestoran.setValue(restaurant.address, forKey: "address")
                    newRestoran.setValue(restaurant.longitude, forKey: "longitude")
                    newRestoran.setValue(restaurant.latitude, forKey: "latitude")
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
