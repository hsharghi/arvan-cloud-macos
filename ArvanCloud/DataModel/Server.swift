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

class ServerSpec: MappableModel {

    var id: String?
    var diskSpace: Int?
    var ram: Int?
    var numberOfCPUs: Int?
    
    required init?(map: Map) {
         super.init(map: map)
     }
     
     override func mapping(map: Map) {
         
         super.mapping(map: map)
        id <- map["id"]
        diskSpace <- map["disk"]
        ram <- map["ram"]
        numberOfCPUs <- map["vcpus"]
    }
}


class Server: MappableModel {
    
    enum Status: String {
        case active = "ACTIVE"
        case inActive = "INACTIVE"
    }
    
    private var statusString: String? {
        didSet {
            if let statusString = statusString {
                status = Status(rawValue: statusString) ?? .inActive
            }
        }
    }
    var id: String?
    var ip: String?
    var name: String?
    var status: Status = .inActive
    var os: String?
    var osVersion: String?
    var specs: ServerSpec?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        
        super.mapping(map: map)
        
        id <- map["id"]
        ip <- map["addresses.public1.addr"]
        name <- map["name"]
        status <- map["status"]
        os <- map["os"]
        osVersion <- map["os_version"]
        specs <- map["flavor"]
        
    }
    
    
    class List: MappableModel {
        var servers: [Server]?


        override func mapping(map: Map) {

            super.mapping(map: map)

            servers <- map["data"]

        }

    }
    
    
    class func get(for datacenter: String, _ completionHandler: @escaping (_ result: [Server]?, _ error: AppError?) -> Void) -> Void {
        MappableModel.get(result: Server.List.self, endPoint: "regions/\(datacenter)/servers") { (serverList, error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            completionHandler(serverList?.servers , nil)
            
        }
    }
}
