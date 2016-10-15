//
//  GlucoseSensorDataEvent.swift
//  RileyLink
//
//  Created by Timothy Mecklem on 10/14/16.
//  Copyright © 2016 Pete Schwamb. All rights reserved.
//

import Foundation

public struct GlucoseSensorDataEvent: TimestampedPumpGlucoseEvent {
    public let length: Int
    public let sgv: Int
    public let rawData: Data
    public let timestamp: DateComponents
    
    public init?(availableData: Data, pumpModel: PumpModel) {
        length = 12
        
        //guard length <= availableData.count else {
        //    return nil
        //}
        
        rawData = availableData.subdata(in: 0..<length)
        sgv = Int(availableData[0] as UInt8)
        timestamp = DateComponents(pumpEventData: availableData, offset: 2)
    }
    
    public var dictionaryRepresentation: [String: Any] {
        return [
            "name": "GlucoseSensorDataEvent",
        ]
    }
}