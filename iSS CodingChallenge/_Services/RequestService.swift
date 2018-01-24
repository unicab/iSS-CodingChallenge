//
//  AlamoreService.swift
//  iSS CodingChallenge
//
//  Created by Tam Nguyen on 1/23/18.
//  Copyright © 2018 Tam Nguyen. All rights reserved.
//

import Foundation
import Alamofire

class RequestService {
    
    // centralized service request method
    private static func request(str: String, completion: @escaping (_ data: Data?, _ error: Error?)->Void) {
        Alamofire.request(str).response { resp in
            if let error = resp.error { completion(nil, error); return }
            guard let data = resp.data else { completion(nil, nil); return }
            completion(data, nil)
        }
    }
}

extension RequestService {
    
    // fetch for astronauts on the ISS
    static func fetchISSInfo(completion: @escaping ((_ info: ISSInfoModel?)->Void)) {
        let urlStr = "http://api.open-notify.org/astros.json"

        RequestService.request(str: urlStr) { data, error in
            if let error = error { print(error); completion(nil); return }
            guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let sJson = json, let model = ISSInfoModel(dict: sJson) else { completion(nil); return }
            completion(model)
        }
    }
    
    // fetch for the ISS Location
    static func fetchISSLocation(completion: @escaping ((_ location: ISSLocationModel?)->Void)) {
        let urlStr = "http://api.open-notify.org/iss-now.json"
        
        RequestService.request(str: urlStr) { data, error in
            if let error = error { print(error); completion(nil); return }
            guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let sJson = json, let model = ISSLocationModel(dict: sJson) else { completion(nil); return }
            completion(model)
        }
    }
    
    // fetch for the ISS PassTime at input location
    static func fetchISSPassTime(atLatitutude: String, atLongitude: String, completion: @escaping ((_ passtime: ISSPassTimeModel?)->Void)) {
        let urlStr = "http://api.open-notify.org/iss-pass.json?lat=\(atLatitutude)&lon=\(atLongitude)"
        
        RequestService.request(str: urlStr) { data, error in
            if let error = error { print(error); completion(nil); return }
            guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let sJson = json, let model = ISSPassTimeModel(dict: sJson) else { completion(nil); return }
            completion(model)
        }
    }

}
