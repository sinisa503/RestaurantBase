//
//  Restaurant.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 28/03/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation

class Restaurant{
    
    private var _name: String
    private var _address: String
    private var _longitude: Double
    private var _latitude: Double
    private var _image: String?
    
    init(name: String, address: String, longitude: Double, latitude: Double) {
        _name = name
        _address = address
        _longitude = longitude
        _latitude = latitude
    }

    init(name: String, address: String, longitude: Double, latitude: Double, imageName: String) {
        _name = name
        _address = address
        _longitude = longitude
        _latitude = latitude
        _image = imageName
    }
    
    var name: String {
        return _name
    }
    var address: String {
        return _address
    }
    var longitude: Double {
        return _longitude
    }
    var latitude:Double {
        return _latitude
    }
    var image: String? {
        if let image = _image {
            return image
        }else {
            return nil
        }
    }
    func setImage(name:String) {
        _image = name
    }
}
