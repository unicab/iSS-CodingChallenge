//
//  ISSInfoModel.swift
//  iSS CodingChallenge
//
//  Created by Tam Nguyen on 1/23/18.
//  Copyright © 2018 Tam Nguyen. All rights reserved.
//

import Foundation

// ISS astronauts data model
class ISSInfoModel: CustomStringConvertible {
    private(set) var people = [String]()
    
    init?(dict: [String: Any]) {
        guard let pplDict = dict["people"] as? NSArray else { return nil }
        
        self.people = pplDict.flatMap {
            guard let d = $0 as? [String: Any] else { return nil }
            return d["name"] as? String
        }
    }
    
    var description: String { return "\(people)" }
}
