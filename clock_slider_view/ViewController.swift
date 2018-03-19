//
//  ViewController.swift
//  clock_slider_view
//
//  Created by Jason Cross on 3/19/18.
//  Copyright © 2018 Cross Swim Training, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sliderControl: TimeRangeSlider!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    
    @IBAction func sliderValueChanged(sender: TimeRangeSlider) {
        var startMinutes = sender.startTimeInMinutes
        var finishMinutes = sender.finishTimeInMinutes
        let timeSpanMinutes = sender.selectedTimeRangeInMinutes
        
        if (sender.startDayOrNightString == DayOrNight.pm.rawValue) {
            startMinutes += CGFloat(720); // one half day equals 12 hours times 60 minutes
        }
        if (sender.finishDayOrNightString == DayOrNight.pm.rawValue) {
            finishMinutes += CGFloat(720);
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let startComponents = DateComponents(calendar: calendar, timeZone: nil, era: nil, year: nil, month: nil, day: nil, hour: nil, minute: Int(round(startMinutes)), second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        let finishComponents = DateComponents(calendar: calendar, timeZone: nil, era: nil, year: nil, month: nil, day: nil, hour: nil, minute: Int(round(finishMinutes)), second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        let totalComponents = DateComponents(calendar: calendar, timeZone: nil, era: nil, year: nil, month: nil, day: nil, hour: nil, minute: timeSpanMinutes, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        
        guard let startDate = calendar.date(from: startComponents),
           let finishDate = calendar.date(from: finishComponents),
           let totalDate = calendar.date(from: totalComponents) else { return }

        let startString = formatter.string(from: startDate) + " \(sender.startDayOrNightString)"
        let finishString = formatter.string(from: finishDate) + " \(sender.finishDayOrNightString)"
        let totalString = formatter.string(from: totalDate)
        
        self.startLabel.text = startString
        self.endLabel.text = finishString
        self.totalLabel.text = totalString
    }


}

