//
//  BaseClockModel.swift
//  clock_slider_view
//
//  Created by Jason Cross on 3/19/18.
//  Copyright © 2018 Cross Swim Training, Inc. All rights reserved.
//


import UIKit






/**
 Unlike a normal clock, this clock has two hour hands, and no minute hands.
 One hour hand represents start time, the other finish time.
 Each hand moves in very fine movements, such that its angle can be used to
 determine a time in hours, minutes, seconds, and fraction of seconds.
 */
protocol BaseClockModel {
    
    var startTime: TimeOfDay {get set}
    var finishTime: TimeOfDay {get set}
    
    /// helps distinguish between the first and second rotation around the clock
    var clockRotationCount: ClockRotationCount {get set}
    var maximumTimeDuration: Int? {get set}
    
    var startTimeInMinutes: CGFloat {get set}
    var finishTimeInMinutes: CGFloat {get set}
    var startDayOrNightString: String {get set}
    var finishDayOrNightString: String {get set}
    var timeRange: Int {get}
    
    mutating func advanceRotationCountIfAllowed()
    
    mutating func setStartDayOrNight(_ dayOrNight: DayOrNight) -> Void
    mutating func setFinishDayOrNight(_ dayOrNight: DayOrNight) -> Void
    mutating func incrementDuration(minutes: Int)
    mutating func setInitialDuration(minutes: Int)
    static func convertMinutesToSafeMinutes(_ unsafeMinutes: CGFloat) -> CGFloat
    
    mutating func changeRotationCountIfNeeded(_ oldTimeRange: CGFloat, newTimeRange: CGFloat)
    static func timeSpanBetween(_ startTime: CGFloat, finishTime:CGFloat) -> CGFloat
    
    var test_startTimeOfDayModel: TimeOfDay {get}
    var test_finishTimeOfDayModel: TimeOfDay {get}
    
}


extension BaseClockModel {
    
    var startDayOrNightString: String {
        set {
            self.startTime.amORpm = DayOrNight(rawValue: newValue)!
        }
        get {
            return self.startTime.amORpm.rawValue
        }
    }
    
    var finishDayOrNightString: String {
        set {
            self.finishTime.amORpm = DayOrNight(rawValue: newValue)!
        }
        get {
            return self.finishTime.amORpm.rawValue
        }
    }
    
    static func timeSpanBetween(_ startTime: CGFloat, finishTime:CGFloat) -> CGFloat {
        // we cannot just perform simple subtraction because we are dealing with a clock
        // meaning from 11:00pm to 3:00am crosses the day boundary,
        // which must be taken into account
        
        let calendar: Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        
        var startTimeComponents = DateComponents()
        var finishTimeComponents = DateComponents()
        startTimeComponents.minute = Int(round(startTime))
        finishTimeComponents.minute = Int(round(finishTime))
        
        guard let startTimeDateObject = calendar.date(from: startTimeComponents),
            var finishTimeDateObject = calendar.date(from: finishTimeComponents) else {
                return 0
        }
        
        // have we taken into account the "crossing-midnight-boundary" issue yet?
        if (finishTimeDateObject < startTimeDateObject) {
            // add another 12 hours to the finish
            finishTimeComponents.hour = 12
            guard let adjustedFinishObject = calendar.date(from: finishTimeComponents) else {
                return 0
            }
            finishTimeDateObject = adjustedFinishObject
        }
        
        let secondDifference = finishTimeDateObject.timeIntervalSince(startTimeDateObject)
        let selectedTime: CGFloat = CGFloat(round(secondDifference / 60.0))
        
        return selectedTime
    }
    
    mutating func advanceRotationCountIfAllowed() {
        if (self.maximumTimeDuration == nil) || (self.maximumTimeDuration! > 720) {
            self.clockRotationCount.incrementCount()
        }
    }
    
    mutating func setStartDayOrNight(_ dayOrNight: DayOrNight) -> Void {
        self.startTime.amORpm = dayOrNight
    }
    
    mutating func setFinishDayOrNight(_ dayOrNight: DayOrNight) -> Void {
        self.finishTime.amORpm = dayOrNight
    }
    
    mutating func setInitialDuration(minutes: Int) {
        let safeMinutes = SingleHand12HourClockModel.convertMinutesToSafeMinutes(CGFloat(minutes))
        let newQuadrant = ClockQuadrant.mapMinutesToQuandrant(safeMinutes)
        self.finishTime.quadrant = newQuadrant
        self.finishTime.minutes = CGFloat(minutes)
        if (minutes >= 720) {
            self.advanceRotationCountIfAllowed()
        }
    }
    
    static func convertMinutesToSafeMinutes(_ unsafeMinutes: CGFloat) -> CGFloat {
        var safeMinutes = unsafeMinutes.truncatingRemainder(dividingBy: CGFloat(720))
        if (safeMinutes < 0) {
            safeMinutes = CGFloat(720) + safeMinutes
        }
        return safeMinutes
    }
    
    internal mutating func changeRotationCountIfNeeded(_ oldTimeRange: CGFloat, newTimeRange: CGFloat) {
        
        // the arc between start and finish is almost a complete circle, then changes over to a small circle
        if ((oldTimeRange > 640.0) && (oldTimeRange < 720.0) && (newTimeRange >= 0) && (newTimeRange <= 60.0)) {
            self.advanceRotationCountIfAllowed()
        }
            // the arc between start and finish is almost zero, then changes over to an almost complete small circle
        else if ((newTimeRange > 640.0) && (newTimeRange < 720.0) && (oldTimeRange >= 0) && (oldTimeRange <= 60.0)) {
            self.clockRotationCount.decrementCount()
        }
    }
    
    
    var test_startTimeOfDayModel: TimeOfDay {
        return self.startTime
    }
    
    var test_finishTimeOfDayModel: TimeOfDay {
        return self.finishTime
    }
    
}

