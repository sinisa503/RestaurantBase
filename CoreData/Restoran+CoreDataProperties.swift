//
//  Restoran+CoreDataProperties.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 04/04/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation
import CoreData


extension Restoran {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restoran> {
        return NSFetchRequest<Restoran>(entityName: "Restoran")
    }

    @NSManaged public var address: String?
    @NSManaged public var image: NSData?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?

}
