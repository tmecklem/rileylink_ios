//
//  TimestampReferenceGlucoseEvent.swift
//  RileyLink
//
//  Created by Timothy Mecklem on 10/16/16.
//  Copyright © 2016 Pete Schwamb. All rights reserved.
//

import Foundation

public protocol TimestampReferenceGlucoseEvent : PumpGlucoseEvent {
    
    var timestamp: DateComponents {
        get
    }
}
