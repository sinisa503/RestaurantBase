//
//  RestaurantModelTest.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 29/03/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import XCTest

class RestaurantModelTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func test_Init() {
        let name = "Dinner's Delight"
        let address = "Kalalarga 2"
        let longitude = 16.654
        let latitude = 42.234
        
        let testModel = Restaurant(name: name, address: address, longitude: longitude, latitude: latitude)
        
        XCTAssertEqual(name, testModel.name, "Name does not match")
        XCTAssertEqual(address, testModel.address, "Address does not match")
        XCTAssertEqual(latitude, testModel.latitude, "Latitude does not match")
        XCTAssertEqual(longitude, testModel.longitude, "Longitude does not match")
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
