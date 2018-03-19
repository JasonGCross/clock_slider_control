//
//  ClockQuadrant.swift
//  clock_slider_view
//
//  Created by Jason Cross on 3/19/18.
//  Copyright © 2018 Cross Swim Training, Inc. All rights reserved.
//

import UIKit

enum ClockQuadrant {
    case first, second, third, fourth
    
    static func mapPointToQuadrant(_ point: CGPoint) -> ClockQuadrant {
        if (point.x >= 0) {
            if  (point.y >= 0) {
                return ClockQuadrant.first
            }
            else {
                return ClockQuadrant.second
            }
        }
        else {
            if (point.y >= 0) {
                return ClockQuadrant.fourth
            }
        }
        return ClockQuadrant.third
    }
    
    static func mapMinutesToQuandrant(_ minutes: CGFloat) -> ClockQuadrant {
        var safeMinutes: CGFloat = minutes
        if (minutes >= 720.0) {
            safeMinutes = CGFloat(720) * round(minutes / 720.0)
        }
        else if (minutes < 0) {
            var negativeSaveMinutes = -minutes
            if (negativeSaveMinutes >= 720) {
                negativeSaveMinutes = CGFloat(720) * round(minutes / 720.0)
            }
            safeMinutes = CGFloat(720) - negativeSaveMinutes
        }
        
        if (safeMinutes >= 0) && (safeMinutes < 180) {
            return ClockQuadrant.first
        }
        else if (safeMinutes >= 180) && (safeMinutes < 360) {
            return ClockQuadrant.second
        }
        else if (safeMinutes >= 360) && (safeMinutes < 540) {
            return ClockQuadrant.third
        }
        else {
            return ClockQuadrant.fourth
        }
    }
}

