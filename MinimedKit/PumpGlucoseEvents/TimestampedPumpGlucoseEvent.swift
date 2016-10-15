//
//  TimestampPumpGlucoseEvent.swift
//  RileyLink
//
//  Created by Timothy Mecklem on 10/14/16.
//  Copyright © 2016 Pete Schwamb. All rights reserved.
//

import Foundation

public protocol TimestampedPumpGlucoseEvent: PumpGlucoseEvent {
    
    var timestamp: DateComponents {
        get
    }
    
}
