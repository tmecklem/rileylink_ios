//
//  PlaceholderPumpGlucoseEvent.swift
//  RileyLink
//
//  Created by Timothy Mecklem on 10/8/16.
//  Copyright © 2016 Pete Schwamb. All rights reserved.
//

import Foundation


public struct PlaceholderPumpGlucoseEvent: PumpGlucoseEvent {
    public let length: Int
    public let rawData: Data
    
    public init?(availableData: Data, pumpModel: PumpModel) {
        length = 1
        
        guard length <= availableData.count else {
            return nil
        }
        
        rawData = availableData.subdata(in: 0..<length)
    }
    
    public var dictionaryRepresentation: [String: Any] {
        let name: String
        if let type = PumpEventType(rawValue: rawData[0] as UInt8) {
            name = String(describing: type).components(separatedBy: ".").last!
        } else {
            name = "UnknownPumpGlucoseEvent(\(rawData[0] as UInt8))"
        }
        
        return [
            "_type": name,
        ]
    }
}
