//
//  SensorTimestampGlucoseEvent.swift
//  RileyLink
//
//  Created by Timothy Mecklem on 10/14/16.
//  Copyright © 2016 Pete Schwamb. All rights reserved.
//

import Foundation

public struct SensorTimestampGlucoseEvent: TimestampReferenceGlucoseEvent {
    public let length: Int
    public let rawData: Data
    public let timestamp: DateComponents
    
    public init?(availableData: Data, pumpModel: PumpModel) {
        length = 5
        
        guard length <= availableData.count else {
            return nil
        }
        
        rawData = availableData.subdata(in: 0..<length)
        timestamp = DateComponents(glucoseEventBytes: availableData.subdata(in: 1..<length).reverseBytes())
    }
    
    public var dictionaryRepresentation: [String: Any] {
        return [
            "_type": "SensorTimestamp",
        ]
    }
}
