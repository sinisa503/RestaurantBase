//
//  Constants.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 28/03/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation

struct API {
    public static let BASE_URL = "http://www.mocky.io/v2/54ef80f5a11ac4d607752717"
    public static let NAME = "Name"
    public static let ADDRESS = "Address"
    public static let LONGITUDE = "Longitude"
    public static let LATITUDE = "Latitude"
}

struct DataBaseConstants {
    public static let ENTITY_RESTAURANT = "Restoran"
    public static let NAME = "name"
    public static let ADDRESS = "address"
    public static let LONGITUDE = "longitude"
    public static let LATITUDE = "latitude"
    public static let IMAGE = "image"
}

struct SegueiConstants {
    public static let SHOW_DETAIL = "showDetail"
    public static let ADD_RESTAURANT = "addRestaurant"
    public static let ITEM_SAVED = "itemSaved"
}

struct StoryboardIdentifiers {
    static let RESTAURANT_TABLE_VC = "restaurantTableVC"
}

struct UserDefaultsConstants {
    static let DATA_FROM_URL_LOADED = "isDataFromUrlLoaded"
}
