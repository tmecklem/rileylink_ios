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
        
        let pageData = pageData.subdata(in: 0..<1022).reverseBytes() // recent bytes (events) first
        
        func matchEvent(_ offset: Int) -> PumpGlucoseEvent? {
            let remainingData = pageData.subdata(in: offset..<pageData.count)
            if let eventType = PumpGlucoseEventType(rawValue:(pageData[offset] as UInt8)) {
                NSLog("Found glucose event of type: " + String(describing: eventType))
                if let event = eventType.eventType.init(availableData: remainingData, pumpModel: pumpModel) {
                    return event
                }
            }
            NSLog("Found glucose event of type: " + String(describing: PumpGlucoseEventType.glucoseSensorDataEvent.eventType))
            return PumpGlucoseEventType.glucoseSensorDataEvent.eventType.init(availableData: remainingData, pumpModel: pumpModel)
        }
        
        func addTimestampsToEvents(startTimestamp: DateComponents, eventsNeedingTimestamp: [RelativeTimestampedGlucoseEvent]) -> [PumpGlucoseEvent] {
            var eventsWithTimestamps = [PumpGlucoseEvent]()
            let calendar = Calendar.current
            var date : Date = calendar.date(from: startTimestamp)!
            for var event in eventsNeedingTimestamp {
                date = calendar.date(byAdding: Calendar.Component.minute, value: -5, to: date)!
                event.timestamp = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                event.timestamp.calendar = calendar
                eventsWithTimestamps.append(event)
            }
            return eventsWithTimestamps
        }
        
        var offset = 0
        let length = pageData.count
        var tempEvents = [PumpGlucoseEvent]()
        var eventsNeedingTimestamp = [RelativeTimestampedGlucoseEvent]()
        
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
            
            if event as? DataEndPumpGlucoseEvent != nil {
                break
            }
            
            if let event = event as? RelativeTimestampedGlucoseEvent {
                eventsNeedingTimestamp.insert(event, at: 0)
            } else {
                let eventsWithTimestamp = addTimestampsToEvents(startTimestamp: event.timestamp, eventsNeedingTimestamp: eventsNeedingTimestamp).reversed()
                tempEvents.append(contentsOf: eventsWithTimestamp)
                tempEvents.append(event)
                eventsNeedingTimestamp.removeAll()
            }
            
            offset += event.length
        }
        events = tempEvents
    }
}
