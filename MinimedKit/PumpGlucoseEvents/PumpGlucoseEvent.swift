//
//  PumpGlucoseEvent.swift
//  RileyLink
//
//  Created by Timothy Mecklem on 10/14/16.
//  Copyright © 2016 Pete Schwamb. All rights reserved.
//

import Foundation

public protocol PumpGlucoseEvent : DictionaryRepresentable {
    
    init?(availableData: Data, pumpModel: PumpModel)
    
    var rawData: Data {
        get
    }
    
    var length: Int {
        get
    }
    
}
