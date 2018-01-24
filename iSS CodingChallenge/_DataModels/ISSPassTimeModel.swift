//
//  ISSPassTime.swift
//  iSS CodingChallenge
//
//  Created by Tam Nguyen on 1/23/18.
//  Copyright © 2018 Tam Nguyen. All rights reserved.
//

import Foundation

class ISSPassTimeItem: CustomStringConvertible {
    private(set) var duration: Int = Int.invalid
    private(set) var timestamp: Date?
    
    init(dict: [String: Any]) {
        if let dur = dict["duration"] as? Int { self.duration = dur }
        if let timeUnit = dict["risetime"] as? Int { self.timestamp = Date(timeIntervalSince1970: TimeInterval(timeUnit)) }
    }
    
    var description: String {
        var fullStr = "duration: \(duration)."
        if let timestamp = self.timestamp { fullStr = fullStr + " timerise: \(timestamp)" }
        return fullStr
    }
}

class ISSPassTimeModel: CustomStringConvertible {
    private(set) var timeItems = [ISSPassTimeItem]()
    
    init?(dict: [String: Any]) {
        guard let dict = dict["response"] as? NSArray else { return nil }
        
        self.timeItems = dict.flatMap {
            guard let d = $0 as? [String: Any] else { return nil }
            return ISSPassTimeItem(dict: d)
        }
    }
    
    var description: String { return "\(timeItems)" }
}
