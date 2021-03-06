//
//  NightscoutPumpEvents.swift
//  RileyLink
//
//  Created by Pete Schwamb on 3/9/16.
//  Copyright © 2016 Pete Schwamb. All rights reserved.
//

import Foundation
import MinimedKit

class NightscoutPumpEvents: NSObject {
    
    class func translate(_ events: [TimestampedHistoryEvent], eventSource: String) -> [NightscoutTreatment] {
        var results = [NightscoutTreatment]()
        var lastBolusWizard: BolusWizardEstimatePumpEvent?
        var lastBolusWizardDate: Date?
        var lastBasalRate: TempBasalPumpEvent?
        var lastBasalRateDate: Date?
        var lastBasalDuration: TempBasalDurationPumpEvent?
        var lastBasalDurationDate: Date?
        for event in events {
            switch event.pumpEvent {
            case let bgReceived as BGReceivedPumpEvent:
                let entry = BGCheckNightscoutTreatment(
                    timestamp: event.date,
                    enteredBy: eventSource,
                    glucose: bgReceived.amount,
                    glucoseType: .Meter,
                    units: .MGDL)  // TODO: can we tell this from the pump?
                results.append(entry)
            case let bolusNormal as BolusNormalPumpEvent:
                var carbs = 0
                var ratio = 0.0
                
                if let wizard = lastBolusWizard, let bwDate = lastBolusWizardDate , event.date.timeIntervalSince(bwDate) <= 2 {
                    carbs = wizard.carbohydrates
                    ratio = wizard.carbRatio
                }
                let entry = BolusNightscoutTreatment(
                    timestamp: event.date,
                    enteredBy: eventSource,
                    bolusType: bolusNormal.duration > 0 ? .Square : .Normal,
                    amount: bolusNormal.amount,
                    programmed: bolusNormal.programmed,
                    unabsorbed: bolusNormal.unabsorbedInsulinTotal,
                    duration: bolusNormal.duration,
                    carbs: carbs,
                    ratio: ratio)
                
                results.append(entry)
            case let bolusWizard as BolusWizardEstimatePumpEvent:
                lastBolusWizard = bolusWizard
                lastBolusWizardDate = event.date
            case let tempBasal as TempBasalPumpEvent:
                lastBasalRate = tempBasal
                lastBasalRateDate = event.date
            case let tempBasalDuration as TempBasalDurationPumpEvent:
                lastBasalDuration = tempBasalDuration
                lastBasalDurationDate = event.date
            default:
                break
            }
            
            if let basalRate = lastBasalRate, let basalDuration = lastBasalDuration, let basalRateDate = lastBasalRateDate, let basalDurationDate = lastBasalDurationDate
                , fabs(basalRateDate.timeIntervalSince(basalDurationDate)) <= 2 {
                let entry = basalPairToNSTreatment(basalRate, basalDuration: basalDuration, eventSource: eventSource, timestamp: event.date)
                results.append(entry)
                lastBasalRate = nil
                lastBasalRateDate = nil
                lastBasalDuration = nil
                lastBasalDurationDate = nil
            }
        }
        return results
    }
    
    private class func basalPairToNSTreatment(_ basalRate: TempBasalPumpEvent, basalDuration: TempBasalDurationPumpEvent, eventSource: String, timestamp: Date) -> TempBasalNightscoutTreatment {
        let absolute: Double? = basalRate.rateType == .Absolute ? basalRate.rate : nil
        return TempBasalNightscoutTreatment(
            timestamp: timestamp,
            enteredBy: eventSource,
            temp: basalRate.rateType == .Absolute ? .Absolute : .Percentage,
            rate: basalRate.rate,
            absolute: absolute,
            duration: basalDuration.duration)
    }
}

