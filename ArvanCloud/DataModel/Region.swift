//
//  Region.swift
//  ArvanCloud
//
//  Created by Hadi Sharghi on 12/26/19.
//  Copyright © 2019 Hadi Sharghi. All rights reserved.
//

import Alamofire
import ObjectMapper
import Foundation

class Region: MappableModel {
    
    
    var flag: String?
    var country:  String?
    var cityCode: String?
    var city: String?
    var dataCenterCode: String?
    var dataCenterName: String?
    var code: String?
    var canCreate: Bool?
    var isDefault: Bool?
    var isVisible: Bool?
    var servers: [Server]?
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        
        super.mapping(map: map)
        
        flag <- map["flag"]
        country <- map["country"]
        cityCode <- map["city_code"]
        city <- map["city"]
        dataCenterCode <- map["dc_code"]
        dataCenterName <- map["dc"]
        code <- map["code"]
        canCreate <- map["create"]
        isDefault <- map["default"]
        isVisible <- map["visible"]
        
        
    }

    class List: MappableModel {
        var regions: [Region]?


        override func mapping(map: Map) {

            super.mapping(map: map)

            regions <- map["data"]

        }

    }
    
    class func getAll(_ completionHandler: @escaping (_ result: [Region]?, _ error: AppError?) -> Void) -> Void {
        MappableModel.get(result: Region.List.self, endPoint: "region") { (regionList, error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            completionHandler(regionList?.regions, nil)
            
        }
    }
}
