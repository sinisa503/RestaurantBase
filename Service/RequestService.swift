//
//  RequestService.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 29/03/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class RequestService {
    
    var restaurantList: [Restaurant]?
    
    static func fetchData(fromSavedUrl url: String, callback: ((Dictionary<String,AnyObject>?, Error?) -> Void)?) {
        Alamofire.request(API.BASE_URL).responseJSON { response in
            if response.result.isSuccess && response.error == nil {
                if let dict = response.result.value as? Dictionary<String,AnyObject> {
                    let name = dict[API.NAME]?.stringValue;
                    let address = dict[API.ADDRESS]?.stringValue
                    let longitude = dict[API.LONGITUDE]?.doubleValue
                    let latitude = dict[API.LATITUDE]?.doubleValue
                    let json = JSON(data: response.data!)
                    //callback?(json, nil)
                }
            }else {
                callback?(nil, response.error)
            }
        }
    }
    
    /*
     for index in 0..<json.count {
     let name = json[index][API.NAME].stringValue
     let address = json[index][API.ADDRESS].stringValue
     let longitude = json[index][API.LONGITUDE].doubleValue
     let latitude = json[index][API.LATITUDE].doubleValue
     let restaurant = Restaurant(name: name, address: address, longitude: longitude, latitude: latitude)
     }
     
     
     print(response.request)  // original URL request
     print(response.response) // HTTP URL response
     print(response.data)     // server data
     print(response.result)   // result of response serialization
 */
}

