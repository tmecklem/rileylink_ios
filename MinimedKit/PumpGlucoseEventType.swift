//
//  PumpGlucoseEventType.swift
//  RileyLink
//
//  Created by Timothy Mecklem on 10/8/16.
//  Copyright © 2016 Pete Schwamb. All rights reserved.
//

/*0x01: dict(name='DataEnd',packet_size=0,date_type='none',op='0x01'),
 0x02: dict(name='SensorWeakSignal',packet_size=0,date_type='prevTimestamp',op='0x02'),
 0x03: dict(name='SensorCal',packet_size=1,date_type='prevTimestamp',op='0x03'),
 0x07: dict(name='Fokko-07',packet_size=1,date_type='prevTimestamp',op='0x07'),
 0x08: dict(name='SensorTimestamp',packet_size=4,date_type='minSpecific',op='0x08'),
 0x0a: dict(name='BatteryChange',packet_size=4,date_type='minSpecific',op='0x0a'),
 0x0b: dict(name='SensorStatus',packet_size=4,date_type='minSpecific',op='0x0b'),
 0x0c: dict(name='DateTimeChange',packet_size=4,date_type='secSpecific',op='0x0c'),
 0x0d: dict(name='SensorSync',packet_size=4,date_type='minSpecific',op='0x0d'),
 0x0e: dict(name='CalBGForGH',packet_size=5,date_type='minSpecific',op='0x0e'),
 0x0f: dict(name='SensorCalFactor',packet_size=6,date_type='minSpecific',op='0x0f'),
 # 0x10: dict(name='10-Something',packet_size=7,date_type='minSpecific',op='0x10'),
 0x10: dict(name='10-Something',packet_size=4,date_type='minSpecific',op='0x10'),
 0x13: dict(name='19-Something',packet_size=0,date_type='prevTimestamp',op='0x13') */

import Foundation

public enum PumpGlucoseEventType: UInt8 {
    case dataEnd = 0x01
    case sensorWeakSignal = 0x02
    case sensorCal = 0x03
    case sensorTimestamp = 0x08
    case batteryChange = 0x0a
    case sensorStatus = 0x0b
    case dateTimeChange = 0x0c
    case sensorSync = 0x0d
    case calBGForGH = 0x0e
    case sensorCalFactor = 0x0f
    case glucoseSensorDataEvent
    
    public var eventType: PumpGlucoseEvent.Type {
        switch self {
        case .dataEnd:
            return DataEndPumpGlucoseEvent.self
//        case .sensorWeakSignal:
//            return SensorWeakSignalGlucoseEvent.self
//        case .sensorCal:
//            return SensorCalGlucoseEvent.self
        case .sensorTimestamp:
            return SensorTimestampGlucoseEvent.self
        case .batteryChange:
            return BatteryChangeGlucoseEvent.self
        case .sensorStatus:
            return SensorStatusGlucoseEvent.self
        case .dateTimeChange:
            return DateTimeChangeGlucoseEvent.self
        case .sensorSync:
            return SensorSyncGlucoseEvent.self
        case .calBGForGH:
            return CalBGForGHGlucoseEvent.self
        case .sensorCalFactor:
            return SensorCalFactorGlucoseEvent.self
        case .glucoseSensorDataEvent:
            return GlucoseSensorDataEvent.self
        default:
            return PlaceholderPumpGlucoseEvent.self
        }
    }
}
