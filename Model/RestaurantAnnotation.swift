//
//  RestaurantAnnotation.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 02/04/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation
import MapKit

class RestaurantAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var phone: String!
    var name: String!
    var address: String!
    var image: UIImage!
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
