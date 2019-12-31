//
//  MappableModel.swift
//  ArvanCloud
//
//  Created by Hadi Sharghi on 12/27/19.
//  Copyright © 2019 Hadi Sharghi. All rights reserved.
//

import Alamofire
import ObjectMapper
import Foundation

class MappableModel: Mappable {
    var error = AppError()

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        error.code <- map["errorCode"]
        error.message <- map["errorMessage"]
    }
    
    
    
    
    class func apiURL(with endPoint: String) -> URL? {
        var components = URLComponents()
        components.scheme = Env.api.scheme
        components.host = Env.api.host
        components.path = Env.api.prefix + endPoint
        
        return components.url
    }
    
    
    class func authorizedHeader() -> HTTPHeaders {
        return HTTPHeaders([
            "Authorization" : Env.api.key
        ])
    }

    
    class func get<T: Mappable>(result: T.Type, endPoint: String, parameters: Parameters? = nil, _ dataHandler: @escaping (_ result:T?, _ error: AppError?) -> Void) -> () {
        
        guard let url = apiURL(with: endPoint) else {
            return
        }

        AF.request(url, method: .get, parameters: parameters, headers: authorizedHeader()).responseString { (response) in
            switch response.result {
                
            case .success(let jsonString):
                dataHandler(T(JSONString: jsonString), nil)
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    
}


struct AppError {
    var code = 0
    var message = ""
    
    init() {
    }
    
    init(errorCode: Int, message: String) {
        self.code = errorCode
        self.message = message
    }
}

//FOR TEST & DEBUG PURPOSES
extension Mappable {
    func description() -> Void {
        let reflected = Mirror(reflecting: self)
        var members = [String: String]()
        for index in reflected.children.indices {
            let child = reflected.children[index]
            members[child.label!] = child.value as? String
        }
        print(members.debugDescription)
    }
}


extension String {
    func toDate() -> Date {
        var str = self
        str.removeLast(5)
        str.removeFirst(6)
        return Date(timeIntervalSince1970: Double(str)!)
    }
}

extension Date {
    func toEpochMilliSecString() -> String {
        return "\(Int64(self.timeIntervalSince1970 * 1000))"
    }
}
