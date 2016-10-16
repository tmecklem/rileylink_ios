//
//  RelativeTimestampedGlucoseEvent.swift
//  RileyLink
//
//  Created by Timothy Mecklem on 10/15/16.
//  Copyright © 2016 Pete Schwamb. All rights reserved.
//

import Foundation

public protocol RelativeTimestampedGlucoseEvent : PumpGlucoseEvent {
    
    var timestamp: DateComponents {
        get set
    }
}
