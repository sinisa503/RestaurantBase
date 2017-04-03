//
//  PersistenceManagerTest.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 29/03/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import XCTest
import CoreData

class PersistenceManagerTest: XCTestCase {
//TODO: Context in persisenceManager does not get initialized from tests???    
    var persistent: PerstistenceManager?
    
    override func setUp() {
        super.setUp()
        persistent = PerstistenceManager.sharedInstance
        persistent?.clearDatabase()
    }
    
    func databaseCleared() {
        persistent?.clearDatabase()
        XCTAssertEqual(persistent?.countObjects(entityName: DataBaseConstants.ENTITY_RESTAURANT, predicate: nil), 0)
    }
    
    override func tearDown() {
        persistent?.clearDatabase()
        persistent = nil
        super.tearDown()
    }
    
    func testClearingDatabase() {
        persistent?.clearDatabase()
        XCTAssertEqual(persistent?.countObjects(entityName: DataBaseConstants.ENTITY_RESTAURANT, predicate: nil), 0)
    }
    
    func testSaveingRestaurant() {
        let name = "Dinner's Delight"
        let address = "Kalalarga 2"
        let longitude = 16.654
        let latitude = 42.234
        
        let testModel = Restaurant(name: name, address: address, longitude: longitude, latitude: latitude)
        persistent = PerstistenceManager.sharedInstance
        persistent?.clearDatabase()
        persistent?.updateDatabaseWith(restaurant: testModel, andImage: nil)
        
        XCTAssertEqual(persistent?.countObjects(entityName: DataBaseConstants.ENTITY_RESTAURANT, predicate: nil), 1)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
