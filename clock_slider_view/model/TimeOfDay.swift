//
//  TimeOfDay.swift
//  clock_slider_view
//
//  Created by Jason Cross on 3/19/18.
//  Copyright © 2018 Cross Swim Training, Inc. All rights reserved.
//

import UIKit

struct TimeOfDay {
    var minutes: CGFloat = 0
    var amORpm: DayOrNight = .am
    var quadrant: ClockQuadrant = .first
}

extension TimeOfDay: Equatable {}

func ==(lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
    let areEqual = (abs(lhs.minutes - rhs.minutes) <= 0.0000001) &&
        lhs.amORpm == rhs.amORpm &&
        lhs.quadrant == rhs.quadrant
    
    return areEqual
}
