//
//  DoubleHand12HourClockModel.swift
//  clock_slider_view
//
//  Created by Jason Cross on 3/19/18.
//  Copyright © 2018 Cross Swim Training, Inc. All rights reserved.
//


import UIKit


struct DoubleHand12HourClockModel : BaseClockModel {
    
    internal var startTime: TimeOfDay = TimeOfDay()
    internal var finishTime: TimeOfDay = TimeOfDay()
    internal var clockRotationCount: ClockRotationCount = ClockRotationCount.first
    var maximumTimeDuration: Int?
    
    var startTimeInMinutes: CGFloat {
        set {
            let safeMinutes = SingleHand12HourClockModel.convertMinutesToSafeMinutes(newValue)
            
            
            // decide whether or not this single hand represents daytime or night time
            // note that this decision depends explicitly on the 12 o'clock position
            let newQuadrant = ClockQuadrant.mapMinutesToQuandrant(safeMinutes)
            if (newQuadrant != self.startTime.quadrant) {
                if ((newQuadrant == .fourth) && (self.startTime.quadrant == .first)) {
                    self.startTime.amORpm.switchDaylightDescription()
                }
                else if ((newQuadrant == .first) && (self.startTime.quadrant == .fourth)) {
                    self.startTime.amORpm.switchDaylightDescription()
                }
                self.startTime.quadrant = newQuadrant
            }
            
            // decide whether or not we are changing between a single or double clock rotation
            // note that this decision may happen at any clock position for either hand
            let oldTimeRange = SingleHand12HourClockModel.timeSpanBetween(self.startTime.minutes,
                                                                          finishTime: self.finishTime.minutes)
            let newTimeRange = SingleHand12HourClockModel.timeSpanBetween(safeMinutes,
                                                                          finishTime: self.finishTime.minutes)
            self.changeRotationCountIfNeeded(oldTimeRange,
                                             newTimeRange: newTimeRange)
            
            self.startTime.minutes = safeMinutes
        }
        get {
            return self.startTime.minutes
        }
    }
    
    var finishTimeInMinutes: CGFloat {
        set {
            let safeMinutes = SingleHand12HourClockModel.convertMinutesToSafeMinutes(newValue)
            
            // decide whether or not this single hand represents daytime or night time
            // note that this decision depends explicitly on the 12 o'clock position
            let newQuadrant = ClockQuadrant.mapMinutesToQuandrant(safeMinutes)
            if (newQuadrant != self.finishTime.quadrant) {
                if ((newQuadrant == .fourth) && (self.finishTime.quadrant == .first)) {
                    self.finishTime.amORpm.switchDaylightDescription()
                }
                else if ((newQuadrant == .first) && (self.finishTime.quadrant == .fourth)) {
                    self.finishTime.amORpm.switchDaylightDescription()
                }
                self.finishTime.quadrant = newQuadrant
            }
            
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
    
    mutating func incrementDuration(minutes: Int) { }
    mutating func setInitialDuration(minutes: Int) {
        self.incrementDuration(minutes: minutes)
    }
}

