//
//  CalBGForPHGlucoseEvent.swift
//  RileyLink
//
//  Created by Timothy Mecklem on 10/14/16.
//  Copyright © 2016 Pete Schwamb. All rights reserved.
//

import Foundation

public struct CalBGForGHGlucoseEvent: PumpGlucoseEvent {
    public let length: Int
    public let rawData: Data
    public let timestamp: DateComponents
    public let amount: Int
    
    public init?(availableData: Data, pumpModel: PumpModel) {
        length = 6
        
        guard length <= availableData.count else {
            return nil
        }
        
        rawData = availableData.subdata(in: 0..<length)
        
        func d(_ idx:Int) -> Int {
            return Int(availableData[idx] as UInt8)
        }
        
        timestamp = DateComponents(glucoseEventBytes: availableData.subdata(in: 2..<length).reverseBytes())
        amount = Int(((d(2) & 0b00100000) << 3) | d(4))
    }
    
    public var dictionaryRepresentation: [String: Any] {
        return [
            "_type": "CalBGForGH",
            "amount": amount,
        ]
    }
}
