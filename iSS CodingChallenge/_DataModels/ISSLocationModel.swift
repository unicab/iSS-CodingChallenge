//
//  LocationModel.swift
//  iSS CodingChallenge
//
//  Created by Tam Nguyen on 1/23/18.
//  Copyright © 2018 Tam Nguyen. All rights reserved.
//

import Foundation

extension String { static let invalid = "<invalid>" }
extension Int { static let invalid = -1 }

// ISS location data model
class ISSLocationModel: CustomStringConvertible {
    private(set) var latitude: String = String.invalid
    private(set) var longitude: String = String.invalid
    private(set) var timestamp: Date?
    
    init?(dict: [String: Any]) {
        guard let posDict = dict["iss_position"] as? [String: Any] else { return nil }
        if let lat = posDict["latitude"] as? String { self.latitude = lat }
        if let lon = posDict["longitude"] as? String { self.longitude = lon }
        
        if let timeUnit = dict["timestamp"] as? Int, timeUnit != Int.invalid {
            self.timestamp = Date(timeIntervalSince1970: TimeInterval(timeUnit))
        }
    }
    
    var description: String { return "lat: \(latitude). lon: \(longitude). time: \(timestamp)"}
}
