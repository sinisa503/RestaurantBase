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
import CoreData

protocol  ApiDelegate : class {
    func apiFinished(restaurantArray: [Restaurant]?)
}

class RequestService {
    
    static let sharedInstance:RequestService = RequestService()
    weak var delegate: ApiDelegate?
    private init(){
        fetchData(fromSavedUrl: API.BASE_URL)
    }
    
    private var restaurants: [Restaurant]? {
        didSet {
            delegate?.apiFinished(restaurantArray: restaurants)
        }
    }
    
     func fetchData(fromSavedUrl url: String){
        var rest: [Restaurant] = []
        Alamofire.request(API.BASE_URL).responseJSON { [weak self] response in
            if response.result.isSuccess && response.error == nil && response.data != nil{
                if let jsonDict = response.result.value as? [Dictionary<String, AnyObject>] {
                    print(jsonDict)
                    for object in jsonDict {
                        let name = object[API.NAME] as? String;
                        let address = object[API.ADDRESS] as? String
                        let longitude = object[API.LONGITUDE] as? Double
                        let latitude = object[API.LATITUDE] as? Double
                        let restaurant = Restaurant(name: name!, address: address!, longitude: longitude!, latitude: latitude!)
                        rest.append(restaurant)
                    }
                }
                if rest.count > 0 {
                    self?.restaurants = rest
                }
            }
        }
    }
}

