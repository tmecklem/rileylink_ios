//
//  GlucoseSensorDataEvent.swift
//  RileyLink
//
//  Created by Timothy Mecklem on 10/14/16.
//  Copyright © 2016 Pete Schwamb. All rights reserved.
//

import Foundation

public struct GlucoseSensorDataEvent: RelativeTimestampedGlucoseEvent {
    public let length: Int
    public let sgv: Int
    public let rawData: Data
    public var timestamp: DateComponents
    
    public init?(availableData: Data, pumpModel: PumpModel) {
        length = 1
        
        guard length <= availableData.count else {
            return nil
        }
        
        rawData = availableData.subdata(in: 0..<length)
        sgv = Int(availableData[0] as UInt8) * 2
        timestamp = DateComponents()
    }
    
    public var dictionaryRepresentation: [String: Any] {
        return [
            "name": "GlucoseSensorDataEvent",
            "sgv": sgv
        ]
    }
}
