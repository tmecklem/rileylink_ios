//
//  SensorCalFactorGlucoseEvent.swift
//  RileyLink
//
//  Created by Timothy Mecklem on 10/14/16.
//  Copyright © 2016 Pete Schwamb. All rights reserved.
//

import Foundation

public struct SensorCalFactorGlucoseEvent: TimestampReferenceGlucoseEvent {
    public let length: Int
    public let rawData: Data
    public let timestamp: DateComponents
    public let factor: Float
    
    public init?(availableData: Data, pumpModel: PumpModel) {
        length = 7
        
        guard length <= availableData.count else {
            return nil
        }
        
        rawData = availableData.subdata(in: 0..<length)
        
        func decodeFactor(from bytes: Data) -> Float {
            return Float(Int(bigEndianBytes: bytes))
        }
        
        factor = decodeFactor(from: availableData.subdata(in: 5..<7)) / Float(1000.0)
        timestamp = DateComponents(glucoseEventBytes: rawData.subdata(in: 1..<5).reverseBytes())
    }
    
    public var dictionaryRepresentation: [String: Any] {
        return [
            "_type": "SensorCalFactor",
            "factor": String(format: "%0.3f", factor)
        ]
    }
}
