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
    
    public let events: [PumpEvent]
    
    public init(pageData: Data, pumpModel: PumpModel) throws {
        
        guard checkCRC16(pageData) else {
            events = [PumpEvent]()
            throw GlucoseHistoryPageError.invalidCRC
        }
        
        let pageData = pageData.subdata(in: 0..<1022)
        
        func matchEvent(_ offset: Int) -> PumpEvent? {
            if let eventType = PumpGlucoseEventType(rawValue:(pageData[offset] as UInt8)) {
                let remainingData = pageData.subdata(in: offset..<pageData.count)
                if let event = eventType.eventType.init(availableData: remainingData, pumpModel: pumpModel) {
                    return event
                }
            }
            return nil
        }
        
        var offset = 0
        let length = pageData.count
        var unabsorbedInsulinRecord: UnabsorbedInsulinPumpEvent?
        var tempEvents = [PumpEvent]()
        
        while offset < length {
            // Slurp up 0's
            if pageData[offset] as UInt8 == 0 {
                offset += 1
                continue
            }
            guard var event = matchEvent(offset) else {
                events = [PumpEvent]()
                throw GlucoseHistoryPageError.unknownEventType(eventType: pageData[offset] as UInt8)
            }
            
            if unabsorbedInsulinRecord != nil, var bolus = event as? BolusNormalPumpEvent {
                bolus.unabsorbedInsulinRecord = unabsorbedInsulinRecord
                unabsorbedInsulinRecord = nil
                event = bolus
            }
            if let event = event as? UnabsorbedInsulinPumpEvent {
                unabsorbedInsulinRecord = event
            } else {
                tempEvents.append(event)
            }
            offset += event.length
        }
        events = tempEvents
    }
}
