//
//  GlucoseHistoryPage.swift
//  RileyLink
//
//  Created by Timothy Mecklem on 10/8/16.
//  Copyright © 2016 Pete Schwamb. All rights reserved.
//

import Foundation

public class GlucoseHistoryPage {
    
    public enum GlucoseHistoryPageError: Error {
        case invalidCRC
        case unknownEventType(eventType: UInt8)
    }
    
    public let events: [PumpGlucoseEvent]
    
    public init(pageData: Data, pumpModel: PumpModel) throws {
        
        guard checkCRC16(pageData) else {
            events = [PumpGlucoseEvent]()
            throw GlucoseHistoryPageError.invalidCRC
        }
        
        let pageData = pageData.subdata(in: 0..<1022).reverseBytes()
        
        NSLog("Reversed: " + pageData.hexadecimalString)
        
        func matchEvent(_ offset: Int) -> PumpGlucoseEvent? {
            if let eventType = PumpGlucoseEventType(rawValue:(pageData[offset] as UInt8)) {
                let remainingData = pageData.subdata(in: offset..<pageData.count)
                NSLog("Found glucose event of type: " + String(describing: eventType))
                if let event = eventType.eventType.init(availableData: remainingData, pumpModel: pumpModel) {
                    return event
                }
            }
            return PumpGlucoseEventType.glucoseSensorDataEvent.eventType.init(availableData: pageData, pumpModel: pumpModel)
        }
        
        var offset = 0
        let length = pageData.count
        //var unabsorbedInsulinRecord: UnabsorbedInsulinPumpEvent?
        var tempEvents = [PumpGlucoseEvent]()
        
        while offset < length {
            // Slurp up 0's
            if pageData[offset] as UInt8 == 0 {
                offset += 1
                continue
            }
            guard let event = matchEvent(offset) else {
                events = [PumpGlucoseEvent]()
                throw GlucoseHistoryPageError.unknownEventType(eventType: pageData[offset] as UInt8)
            }
            
            offset += event.length
        }
        events = tempEvents
    }
}
