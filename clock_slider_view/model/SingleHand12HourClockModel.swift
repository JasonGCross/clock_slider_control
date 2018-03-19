//
//  SingleHand12HourClockModel.swift
//  clock_slider_view
//
//  Created by Jason Cross on 3/19/18.
//  Copyright © 2018 Cross Swim Training, Inc. All rights reserved.
//


import UIKit

struct SingleHand12HourClockModel : BaseClockModel {
    
    internal var startTime: TimeOfDay = TimeOfDay()
    internal var finishTime: TimeOfDay = TimeOfDay()
    internal var clockRotationCount: ClockRotationCount = ClockRotationCount.first
    var maximumTimeDuration: Int?
    
    var startTimeInMinutes: CGFloat {
        set {
            
        }
        get {
            return 0
        }
    }
    
    var finishTimeInMinutes: CGFloat {
        set {
            let safeMinutes = SingleHand12HourClockModel.convertMinutesToSafeMinutes(newValue)
            
            self.finishTime.quadrant = ClockQuadrant.mapMinutesToQuandrant(safeMinutes)
            
            // decide whether or not we are changing between a single or double clock rotation
            // note that this decision may happen at any clock position for either hand
            let oldTimeRange = SingleHand12HourClockModel.timeSpanBetween(self.startTime.minutes,
                                                                          finishTime: self.finishTime.minutes)
            let newTimeRange = SingleHand12HourClockModel.timeSpanBetween(self.startTime.minutes,
                                                                          finishTime: safeMinutes)
            self.changeRotationCountIfNeeded(oldTimeRange,
                                             newTimeRange: newTimeRange)
            
            self.finishTime.minutes = safeMinutes
        }
        get {
            return self.finishTime.minutes
        }
    }
    
    
    
    var timeRange: Int {
        get {
            var selectedTime: Int = Int(round(SingleHand12HourClockModel.timeSpanBetween(self.startTime.minutes,
                                                                                         finishTime: self.finishTime.minutes)))
            switch (clockRotationCount) {
            case .first:
                if (selectedTime > 720) {
                    selectedTime -= 720
                }
            case .second:
                if selectedTime < 720 {
                    selectedTime += 720
                }
            }
            return selectedTime
            
        }
    }
    
    mutating func advanceRotationCountIfAllowed() {}
    
    
    mutating func incrementDuration(minutes: Int) {
        self.finishTimeInMinutes = CGFloat(minutes)
        
    }
    
    
    
    
    
}

