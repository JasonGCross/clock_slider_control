//
//  TimeRangeSlider.swift
//  clock_slider_view
//
//  Created by Jason Cross on 3/19/18.
//  Copyright © 2018 Cross Swim Training, Inc. All rights reserved.
//


import UIKit

enum LastDraggedThumbKnob {
    case startThumbKnob
    case finishThumbKnob
    case neitherThumbKnob
}

@IBDesignable
class TimeRangeSlider: UIControl {
    
    //MARK: - settable properties
    //*************************************************************************
    
    /**
     * Callback for when the user changes the range specified by the clock slider.
     * Do not use this property currently, as there is a bug in React-Native which
     * prevents the events from being received.
     * Instead, manually subscribe to the events using `NativeAppEventEmitter.addListener`,
     * even though that method is marked as obsolete.
     */
    //   var sliderChanged: RCTBubblingEventBlock?
    
    /**
     * The color of the track upon which the slider slides. This track is in a ring
     * shape, and is outside the clock face itself (the circle with numbers and marks).
     */
    @IBInspectable
    var outerRingBackgroundColor : UIColor = UIColor(red: 0.086,
                                                     green: 0.094,
                                                     blue: 0.090,
                                                     alpha: 1.00) {
        willSet {
            self.clockFaceView?.outerRingBackgroundColor = newValue
        }
    }
    
    /**
     * The color of the clock face itself (the circle with numbers and marks).
     */
    @IBInspectable
    var innerRingBackgroundColor: UIColor = UIColor.black {
        willSet {
            self.clockFaceView?.innerRingBackgroundColor = newValue
        }
    }
    
    /**
     * The foreground color of the clock face tick marks.
     */
    @IBInspectable
    var clockFaceTickMarkColor: UIColor = UIColor(red: 0.380,
                                                  green: 0.380,
                                                  blue: 0.380,
                                                  alpha: 1.00) {
        willSet {
            self.clockFaceView?.tickMarkColor = newValue
        }
    }
    
    @IBInspectable
    var clockFaceTextSize: Float = 14 {
        willSet {
            clockFaceFontAttributes[NSAttributedStringKey.font] = UIFont(name: self.clockFaceFont.fontName,
                                                                         size: CGFloat(newValue))
        }
    }
    
    @IBInspectable
    var elapsedTimeTextSize: Float = 20 {
        willSet {
            elapsedTimeFontAttributes[NSAttributedStringKey.font] = UIFont(name: self.elapsedTimeFont.fontName,
                                                                           size: CGFloat(newValue))
        }
    }
    
    /**
     * The foreground color of the clock face digits.
     */
    @IBInspectable
    var clockFaceTextColor: UIColor = UIColor(red: 0.380,
                                              green: 0.380,
                                              blue: 0.380,
                                              alpha: 1.00) {
        willSet {
            clockFaceFontAttributes[NSAttributedStringKey.foregroundColor] = newValue
        }
    }
    
    @IBInspectable
    var elapsedTimeTextColor: UIColor = UIColor(red: 0.380,
                                                green: 0.380,
                                                blue: 0.380,
                                                alpha: 1.00) {
        willSet {
            elapsedTimeFontAttributes[NSAttributedStringKey.foregroundColor] = newValue
        }
    }
    
    @IBInspectable
    var clockFaceFont: UIFont = UIFont.systemFont(ofSize: 14) {
        willSet {
            clockFaceFontAttributes[NSAttributedStringKey.font] = UIFont(name: newValue.fontName,
                                                                         size: CGFloat(self.elapsedTimeTextSize))
        }
    }
    
    var clockFaceFontName: NSString? {
        willSet {
            if let name: NSString = newValue {
                if let font : UIFont = UIFont.init(name: name as String,
                                                   size: CGFloat(self.clockFaceTextSize)) {
                    self.clockFaceFont = font
                }
            }
        }
    }
    
    @IBInspectable
    var elapsedTimeFont: UIFont = UIFont.systemFont(ofSize: 20) {
        willSet {
            elapsedTimeFontAttributes[NSAttributedStringKey.font] = UIFont(name: newValue.fontName,
                                                                           size: CGFloat(self.elapsedTimeTextSize))
        }
    }
    
    var elapsedTimeFontName: NSString? {
        willSet {
            if let name: NSString = newValue {
                if let font : UIFont = UIFont.init(name: name as String,
                                                   size: CGFloat(self.elapsedTimeTextSize)) {
                    self.elapsedTimeFont = font
                }
            }
        }
    }
    
    var clockFaceFontAttributes: [NSAttributedStringKey : AnyObject] = [NSAttributedStringKey : AnyObject]() {
        willSet {
            self.clockFaceView?.fontAttributes = newValue
        }
    }
    
    var elapsedTimeFontAttributes: [NSAttributedStringKey : AnyObject] = [NSAttributedStringKey : AnyObject]()
    
    
    
    /**
     * The image used for the thumbnail icon where the user places a finger to
     * drag the start location of the time range control.
     * This image should be 42 pixels and circular.
     * This image must be in the XCAssetCatalog.
     */
    @IBInspectable
    var startThumbnailImage : UIImage? {
        willSet {
            self.startKnobView.thumbnailImage = newValue
        }
    }
    
    /**
     * The image used for the thumbnail icon where the user places a finger to
     * drag the end location of the time range control.
     * This image should be 42 pixels and circular.
     * This image must be in the XCAssetCatalog.
     */
    @IBInspectable
    var finishTumbnailImage : UIImage?  {
        willSet {
            self.finishKnobView.thumbnailImage = newValue
        }
    }
    
    
    
    /**
     * The name of the image used for the thumbnail icon where the user places a finger to
     * drag the start location of the time range control.
     * This image should be 42 pixels and circular.
     * This image must be in the XCAssetCatalog.
     */
    var startThumbnailImageName: NSString? {
        willSet {
            if let name: NSString = newValue {
                self.startThumbnailImage = UIImage.init(named: name as String)
            }
        }
    }
    
    /**
     * The name of the image used for the thumbnail icon where the user places a finger to
     * drag the end location of the time range control.
     * This image should be 42 pixels and circular.
     * This image must be in the XCAssetCatalog.
     */
    var finishThumbnailImageName: NSString? {
        willSet {
            if let name: NSString = newValue {
                self.finishTumbnailImage = UIImage.init(named: name as String)
            }
        }
    }
    
    /**
     * One of two colors which comprise the gradient used to fill the slider track.
     * The track uses this primary color scheme when the time span is between 0 and 12 hours.
     * This color is closest to the start position.
     */
    @IBInspectable
    var firstDayGradientStartColor : UIColor = UIColor(red: 0.933,
                                                       green: 0.424,
                                                       blue: 0.149,
                                                       alpha: 1.00) {
        willSet {
            self.clockSliderView?.firstDayGradientStartColor = newValue
        }
    }
    
    /**
     * One of two colors which comprise the gradient used to fill the slider track.
     * The track uses this primary color scheme when the time span is between 0 and 12 hours.
     * This color is closest to the finish position.
     */
    @IBInspectable
    var firstDayGradientFinishColor : UIColor = UIColor(red: 0.965,
                                                        green: 0.965,
                                                        blue: 0.065,
                                                        alpha: 1.00) {
        willSet {
            self.clockSliderView?.firstDayGradientFinishColor = newValue
        }
    }
    
    /**
     * One of two colors which comprise the gradient used to fill the slider track.
     * The track switches to this alternate color scheme when the time span is between 12 and 24 hours.
     * This color is closest to the start position.
     */
    @IBInspectable
    var secondDayGradientStartColor : UIColor = UIColor(red: 0.072,
                                                        green: 0.878,
                                                        blue: 0.087,
                                                        alpha: 1.00) {
        willSet {
            self.clockSliderView?.secondDayGradientStartColor = newValue
        }
    }
    
    /**
     * One of two colors which comprise the gradient used to fill the slider track.
     * The track switches to this alternate color scheme when the time span is between 12 and 24 hours.
     * This color is closest to the finish position.
     */
    @IBInspectable
    var secondDayGradientFinishColor : UIColor = UIColor(red: 0.833,
                                                         green: 0.994,
                                                         blue: 0.342,
                                                         alpha: 1.00) {
        willSet {
            self.clockSliderView?.secondDayGradientFinishColor = newValue
        }
    }
    
    /**
     * Used to specify the number which will appear in the 12 o'clock position,
     * if desired to use something other than 12. For example, to display a zero.
     */
    @IBInspectable
    var customizedTwelveOClockCharacter: String? {
        willSet {
            self.clockFaceView?.customizedTwelveOClockCharacter = newValue
        }
    }
    
    /**
     * Set this to true to turn off displaying the numbers along the circumference of the clock face
     * (e.g. 1, 2, 3 for one o'clock, two o'clock, etc.)
     */
    @IBInspectable
    var omitClockFaceHourMarkingDigits = false {
        willSet {
            self.clockFaceView?.omitClockFaceTicks = newValue
        }
    }
    
    /**
     * Set this to true to turn off displaying the ticks along the circumference of the clock face.
     */
    @IBInspectable
    var omitClockFaceTicks = false
    
    /**
     * The number of minutes (assuming 720 minutes in a single clock face revolution)
     * between minor tick marks. The major tick marks are every hours, or 12 on the clock face.
     * Pass in 0 to indicate no minor ticks.
     *
     * - example setting minutesBetweenMinorTickMarks to 15 means 3 marks between every hour
     *   (  0 minutes - major tick
     *     15 minutes - minor tick
     *     30 minutes - minor tick
     *     45 minutes - minor tick
     *     60 minutes - major tick)
     */
    @IBInspectable
    var minutesBetweenMinorTickMarks = 15 {
        willSet {
            self.rotationEachMinorTick = CGFloat(Double.pi / 24.0) * CGFloat(60.0 / CGFloat(newValue))
        }
    }
    
    var clockFaceView : ClockFaceView?
    var clockSliderView: ClockSliderView?
    
    var elapsedTimeLabel: UILabel
    
    var startLockedToMidnight = false
    
    private var maxAllowedMinutes = 20 * 60
    
    /**
     * The granularity which the user is allowed to specify when selecting a time
     * duration. For example, if the increment duration is 15 minutes, and the user
     * slides the control to read 3:12, then upon the drag motion finishing, the
     * control will round the selected time interval to 3:15
     */
    var incrementDurationInMinutes: Int = 11
    
    var startTimeInMinutes: CGFloat {
        set {
            if (!self.startLockedToMidnight || (newValue == 0)) {
                sliderStartAngle = TimeRangeSlider.clockFaceAngle(newValue)
                self.clockModel.startTimeInMinutes = newValue
            }
        }
        get {
            return self.clockModel.startTimeInMinutes
        }
    }
    
    func setNewStartTime(minutes: CGFloat, angle: CGFloat) -> Void {
        if (!self.startLockedToMidnight || (minutes == 0)) {
            startTimeInMinutes = minutes
            sliderStartAngle = angle
            self.clockModel.startTimeInMinutes = minutes
        }
    }
    
    var finishTimeInMinutes: CGFloat {
        set {
            sliderEndAngle = TimeRangeSlider.clockFaceAngle(newValue)
            self.clockModel.finishTimeInMinutes = newValue
        }
        get {
            return self.clockModel.finishTimeInMinutes
        }
    }
    
    func setNewFinishTime(minutes: CGFloat, angle: CGFloat) -> Void {
        sliderEndAngle = angle
        self.clockModel.finishTimeInMinutes = minutes
    }
    
    var startDayOrNightString: String {
        set {
            self.clockModel.startDayOrNightString = newValue
        }
        get {
            return self.clockModel.startDayOrNightString
        }
    }
    
    var finishDayOrNightString: String {
        set {
            self.clockModel.finishDayOrNightString = newValue
        }
        get {
            return self.clockModel.finishDayOrNightString
        }
    }
    
    var selectedTimeRangeInMinutes: Int {
        get {
            return self.clockModel.timeRange
        }
    }
    
    
    
    //MARK: - constants
    //*************************************************************************
    
    internal let ringWidth : CGFloat = 44
    internal let hourMarkLineWidth : CGFloat = 2
    internal var rotationEachMinorTick : CGFloat = CGFloat(Double.pi / 24) {
        willSet {
            self.clockFaceView?.rotationEachMinorTick = newValue
        }
    }
    
    internal let thumbNailImageMargin : CGFloat = 2
    internal var clockRadius: CGFloat
    internal var radiusClockCenterToSliderTrackCenter: CGFloat
    /// one revolution of the clock contains 12 hours * 60 minutes
    internal static let ticksPerRevolution = 12 * 60
    internal static let calendar: Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
    internal var halfSliderTrackWidth : CGFloat
    
    // private variables
    internal var startKnobView: ThumbnailView
    internal var finishKnobView: ThumbnailView
    internal var sliderStartAngle: CGFloat {
        willSet {
            self.clockSliderView?.setClock(startAngle: newValue,
                                           finishAngle: self.sliderEndAngle,
                                           clockDuration: self.selectedTimeRangeInMinutes,
                                           rotationCount: self.clockModel.clockRotationCount)
        }
    }
    
    internal var sliderEndAngle: CGFloat {
        willSet {
            self.clockSliderView?.setClock(startAngle: self.sliderStartAngle,
                                           finishAngle: newValue,
                                           clockDuration: self.selectedTimeRangeInMinutes,
                                           rotationCount: self.clockModel.clockRotationCount)
        }
    }
    
    internal var clockModel: BaseClockModel
    internal var previousTouchPoint: CGPoint = CGPoint.zero
    
    /// minimum distance allowed to the center of the circle before drag events are ignored
    internal var dragTolerance: CGFloat = 30
    
    /// helps distinguish between the first and second rotation around the clock
    internal var clockRotationCount: ClockRotationCount {
        return self.clockModel.clockRotationCount
    }
    
    internal var lastDraggedThumbKnob: LastDraggedThumbKnob = .neitherThumbKnob
    internal var thumbWithHigherZIndex: LastDraggedThumbKnob = .neitherThumbKnob
    internal let angleEquivalentToOnePixel: CGFloat = CGFloat(Double.pi / 360.0)
    
    
    
    //MARK: - initialization
    //*************************************************************************
    
    override init(frame: CGRect) {
        
        halfSliderTrackWidth = (ringWidth / 2.0)
        let diameter = CGFloat(fminf(Float(frame.size.width),
                                     Float(frame.size.height)))
        clockRadius = diameter / 2.0
        clockModel = DoubleHand24HourClockModel()
        clockModel.startTimeInMinutes = CGFloat(600)
        clockModel.setStartDayOrNight(.pm)
        clockModel.finishTimeInMinutes = CGFloat(420)
        clockModel.setFinishDayOrNight(.am)
        
        // uses the fact that lines are stroked half on each side of the line
        radiusClockCenterToSliderTrackCenter = clockRadius - halfSliderTrackWidth
        sliderStartAngle = TimeRangeSlider.clockFaceAngle(self.clockModel.startTimeInMinutes)
        sliderEndAngle = TimeRangeSlider.clockFaceAngle(self.clockModel.finishTimeInMinutes)
        
        let thumbnailFrame = CGRect(x:0, y:0, width: ringWidth, height: ringWidth)
        startKnobView = ThumbnailView.init(_frame: thumbnailFrame,
                                           _ringWidth: ringWidth,
                                           _clockRadius: clockRadius)
        startKnobView.isUserInteractionEnabled = false
        finishKnobView = ThumbnailView.init(_frame: thumbnailFrame,
                                            _ringWidth: ringWidth,
                                            _clockRadius: clockRadius)
        finishKnobView.isUserInteractionEnabled = false
        
        elapsedTimeLabel = UILabel.init()
        
        // “A designated initializer must ensure that all of the properties introduced by its class are initialized before it delegates up to a superclass initializer.”
        // Excerpt From: Apple Inc. “The Swift Programming Language (Swift 2.2).” iBooks. https://itun.es/us/jEUH0.l
        super.init(frame: frame)
        
        let rect = CGRect(x:0, y:0, width:frame.width, height:frame.height)
        self.clockFaceView = ClockFaceView.init(_frame: rect,
                                                _ringWidth: self.ringWidth)
        self.clockFaceView?.isUserInteractionEnabled = false
        
        self.clockSliderView = ClockSliderView.init(_frame: rect,
                                                    _ringWidth: self.ringWidth,
                                                    _sliderStartAngle: sliderStartAngle,
                                                    _sliderEndAngle: sliderEndAngle,
                                                    _clockRotationCount: self.clockModel.clockRotationCount)
        self.clockSliderView?.isUserInteractionEnabled = false
        
        self.layer.addSublayer(self.clockFaceView!.layer)
        self.layer.addSublayer(self.clockSliderView!.layer)
        self.layer.addSublayer(self.startKnobView.layer)
        self.layer.addSublayer(self.finishKnobView.layer)
        self.thumbWithHigherZIndex = .finishThumbKnob
        
        self.layer.addSublayer(self.elapsedTimeLabel.layer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        let temporaryFrame = CGRect(x: 0, y: 0, width: 200, height: 200)
        halfSliderTrackWidth = (ringWidth / 2.0)
        var diameter = CGFloat(fminf(Float(temporaryFrame.size.width),
                                     Float(temporaryFrame.size.height)))
        clockRadius = diameter / 2.0
        clockModel = DoubleHand24HourClockModel()
        
        // uses the fact that lines are stroked half on each side of the line
        radiusClockCenterToSliderTrackCenter = clockRadius - halfSliderTrackWidth
        sliderStartAngle = TimeRangeSlider.clockFaceAngle(self.clockModel.startTimeInMinutes)
        sliderEndAngle = TimeRangeSlider.clockFaceAngle(self.clockModel.finishTimeInMinutes)
        
        var thumbnailFrame = CGRect(x:0, y:0, width: ringWidth, height: ringWidth)
        startKnobView = ThumbnailView.init(_frame: thumbnailFrame,
                                           _ringWidth: ringWidth,
                                           _clockRadius: clockRadius)
        finishKnobView = ThumbnailView.init(_frame: thumbnailFrame,
                                            _ringWidth: ringWidth,
                                            _clockRadius: clockRadius)
        
        elapsedTimeLabel = UILabel.init()
        super.init(coder: aDecoder)
        
        // now that self is available, need to clean up the properties which depend upon a true frame size
        diameter = CGFloat(fminf(Float(self.frame.size.width),
                                     Float(self.frame.size.height)))
        clockRadius = diameter / 2.0
        clockModel = DoubleHand24HourClockModel()
        clockModel.startTimeInMinutes = CGFloat(600)
        clockModel.setStartDayOrNight(.pm)
        clockModel.finishTimeInMinutes = CGFloat(420)
        clockModel.setFinishDayOrNight(.am)
        
        // uses the fact that lines are stroked half on each side of the line
        radiusClockCenterToSliderTrackCenter = clockRadius - halfSliderTrackWidth
        sliderStartAngle = TimeRangeSlider.clockFaceAngle(self.clockModel.startTimeInMinutes)
        sliderEndAngle = TimeRangeSlider.clockFaceAngle(self.clockModel.finishTimeInMinutes)
        
        thumbnailFrame = CGRect(x:0, y:0, width: ringWidth, height: ringWidth)
        startKnobView = ThumbnailView.init(_frame: thumbnailFrame,
                                           _ringWidth: ringWidth,
                                           _clockRadius: clockRadius)
        startKnobView.isUserInteractionEnabled = false
        finishKnobView = ThumbnailView.init(_frame: thumbnailFrame,
                                            _ringWidth: ringWidth,
                                            _clockRadius: clockRadius)
        finishKnobView.isUserInteractionEnabled = false
        
        let rect = CGRect(x:0, y:0, width:frame.width, height:frame.height)
        self.clockFaceView = ClockFaceView.init(_frame: rect,
                                                _ringWidth: self.ringWidth)
        self.clockFaceView?.isUserInteractionEnabled = false
        
        self.clockSliderView = ClockSliderView.init(_frame: rect,
                                                    _ringWidth: self.ringWidth,
                                                    _sliderStartAngle: sliderStartAngle,
                                                    _sliderEndAngle: sliderEndAngle,
                                                    _clockRotationCount: self.clockModel.clockRotationCount)
        self.clockSliderView?.isUserInteractionEnabled = false
        
        self.layer.addSublayer(self.clockFaceView!.layer)
        self.layer.addSublayer(self.clockSliderView!.layer)
        self.layer.addSublayer(self.startKnobView.layer)
        self.layer.addSublayer(self.finishKnobView.layer)
        self.thumbWithHigherZIndex = .finishThumbKnob
        
        self.layer.addSublayer(self.elapsedTimeLabel.layer)
    }
    
    
    
    //MARK: - touch handling
    //*************************************************************************
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        self.previousTouchPoint = touch.location(in: self)
        
        // hit test the thumbnail layers
        // we need to implement a Z-index here, so that the last dragged thumbnail gets dragged first
        // Three scenarios:
        //   1. the start knob is locked - never highlight it
        //   2. the finish knob is highlighted - consider it first
        //   3. the finish knob is NOT highlighted - consider it last
        
        // case 1
        if (self.startLockedToMidnight) {
            if (self.finishKnobView.frame.contains(self.previousTouchPoint)) {
                self.finishKnobView.isHighlighted = true
            }
        }
        else if (self.lastDraggedThumbKnob == LastDraggedThumbKnob.finishThumbKnob) {
            if (self.finishKnobView.frame.contains(self.previousTouchPoint)) {
                self.finishKnobView.isHighlighted = true
            }
            else if(self.startKnobView.frame.contains(self.previousTouchPoint)) {
                self.startKnobView.isHighlighted = true
            }
        }
        else {
            if(self.startKnobView.frame.contains(self.previousTouchPoint)) {
                self.startKnobView.isHighlighted = true
            }
            else if (self.finishKnobView.frame.contains(self.previousTouchPoint)) {
                self.finishKnobView.isHighlighted = true
            }
        }
        
        return true;
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint: CGPoint = touch.location(in: self)
        
        // 1. determine by how much the user has dragged
        guard let bestInterceptPoint = self.closestPointOnSliderCenterTrack(touchPoint) else {
            self.previousTouchPoint = touchPoint
            return false
        }
        
        self.previousTouchPoint = touchPoint
        var mappedIntercept = self.mapScreenPointToSliderCenterTrackPoint(bestInterceptPoint)
        if (mappedIntercept.x > self.radiusClockCenterToSliderTrackCenter) {
            mappedIntercept = CGPoint(x: self.radiusClockCenterToSliderTrackCenter, y: mappedIntercept.y)
        }
        else if (mappedIntercept.x < -self.radiusClockCenterToSliderTrackCenter) {
            mappedIntercept = CGPoint(x: -self.radiusClockCenterToSliderTrackCenter, y: mappedIntercept.y)
        }
        
        if (mappedIntercept.y > self.radiusClockCenterToSliderTrackCenter) {
            mappedIntercept = CGPoint(x: mappedIntercept.x, y: self.radiusClockCenterToSliderTrackCenter)
        }
        else if (mappedIntercept.y < -self.radiusClockCenterToSliderTrackCenter) {
            mappedIntercept = CGPoint(x: mappedIntercept.x, y: -self.radiusClockCenterToSliderTrackCenter)
        }
        let (minutes, angle) = self.minutesForThumnailCenter(mappedIntercept)
        
        // 2. update the value of the max or min minutes
        if(self.startKnobView.isHighlighted && !self.startLockedToMidnight) {
            self.setNewStartTime(minutes: minutes, angle: angle)
            self.lastDraggedThumbKnob = .startThumbKnob
        }
        else if (self.finishKnobView.isHighlighted) {
            self.setNewFinishTime(minutes: minutes, angle: angle)
            self.lastDraggedThumbKnob = .finishThumbKnob
        }
        
        // 3. Update the UI state
        self.setNeedsDisplay()
        
        // 4. Notify observers that the change has taken place
        self.sendActions(for: UIControlEvents.valueChanged)
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        // during tracking, we want a smooth animation, so allow selecting any number of minutes
        // after the user is finished, clean up by moving to the nearest allowable minute
        
        var newTimeSpan = DoubleHand24HourClockModel.timeSpanBetween(self.startTimeInMinutes,
                                                                     finishTime: self.finishTimeInMinutes)
        if (self.clockRotationCount == .second) {
            newTimeSpan += 720
        }
        
        
        if(self.startKnobView.isHighlighted) {
            if !(newTimeSpan <= CGFloat(self.maxAllowedMinutes)) {
                let currentEndThumb = self.clockSliderView!.thumbnailCenterPoint(self.finishTimeInMinutes)
                self.startTimeInMinutes = self.maximumAllowedStartMinutesStartingFromFinishThumbCenter(currentEndThumb)
            }
            self.startTimeInMinutes = CGFloat(TimeRangeSlider.roundMinutesToMatchIncrementDuration(self.startTimeInMinutes,
                                                                                                   incrementDuration: self.incrementDurationInMinutes))
        }
        else if (self.finishKnobView.isHighlighted) {
            if !(newTimeSpan <= CGFloat(self.maxAllowedMinutes)) {
                let currentStartThumb = self.clockSliderView!.thumbnailCenterPoint(self.startTimeInMinutes)
                self.finishTimeInMinutes = self.maximumAllowedFinishMinutesStartingFromStartThumbCenter(currentStartThumb)
            }
            self.finishTimeInMinutes =  CGFloat(TimeRangeSlider.roundMinutesToMatchIncrementDuration(self.finishTimeInMinutes,
                                                                                                     incrementDuration: self.incrementDurationInMinutes))
        }
        
        self.setNeedsDisplay()
        self.sendActions(for: UIControlEvents.valueChanged)
        
        self.startKnobView.isHighlighted = false
        self.finishKnobView.isHighlighted = false
    }
    
    //MARK: - private helpers
    //*************************************************************************
    
    fileprivate func maximumAllowedStartMinutesStartingFromFinishThumbCenter(_ screenPoint: CGPoint) -> CGFloat {
        var value: CGFloat = 0
        
        let minutesToTravelBackwards: CGFloat = CGFloat(self.maxAllowedMinutes).truncatingRemainder(dividingBy: 720.0)
        let innerAngle: CGFloat = TimeRangeSlider.clockFaceAngle(minutesToTravelBackwards)
        value = self.findMinutesOnClockCircle(screenPoint,
                                              innerAngle: innerAngle,
                                              clockwise: false)
        return value
    }
    
    fileprivate func maximumAllowedFinishMinutesStartingFromStartThumbCenter(_ screenPoint: CGPoint) -> CGFloat {
        var value: CGFloat = 0
        
        let desiredFinishMinutes: CGFloat = CGFloat(self.maxAllowedMinutes).truncatingRemainder(dividingBy: 720.0)
        let innerAngle: CGFloat = TimeRangeSlider.clockFaceAngle(desiredFinishMinutes)
        value = self.findMinutesOnClockCircle(screenPoint,
                                              innerAngle: innerAngle,
                                              clockwise: true)
        return value
    }
    
    fileprivate func findMinutesOnClockCircle(_ screenPointA: CGPoint, innerAngle: CGFloat, clockwise: Bool) -> CGFloat {
        // see this site: http://math.stackexchange.com/questions/275201/how-to-find-an-end-point-of-an-arc-given-another-end-point-radius-and-arc-dire
        let mappedPointA = self.mapScreenPointToSliderCenterTrackPoint(screenPointA)
        let angleToStartPoint = CGFloat(atan2(mappedPointA.y, mappedPointA.x))
        var angleToEndPoint = clockwise ? (angleToStartPoint - innerAngle) : (angleToStartPoint + innerAngle)
        if (angleToEndPoint < 0) {
            angleToEndPoint += CGFloat(2 * Double.pi)
        }
        
        let Bx = self.radiusClockCenterToSliderTrackCenter * cos(angleToEndPoint)
        let By = self.radiusClockCenterToSliderTrackCenter * sin(angleToEndPoint)
        let pointB = CGPoint(x:Bx, y:By)
        let value = self.minutesForThumnailCenter(pointB).minutes
        return value
    }
    
    /**
     rounds the minutes passed in, such that the returned result is an even multiple
     of the increment duration.
     
     - example: round(74) where increment_duration is 15, returns 75
     
     - parameter minutes: the minutes which need to be rounded
     
     - returns: the rounded minutes
     */
    fileprivate static func roundMinutesToMatchIncrementDuration(_ minutes: CGFloat, incrementDuration: Int) -> Int {
        let remainder: CGFloat = minutes.truncatingRemainder(dividingBy: CGFloat(incrementDuration))
        let floor: Int = Int(round(minutes - remainder))
        let roundedRemainder: Int = Int(round(remainder / CGFloat(incrementDuration)) * CGFloat(incrementDuration))
        let roundedMinutes: Int = roundedRemainder + floor
        return roundedMinutes
    }
    
    /**
     takes a point from the normal screen system (origin is top left, with x increasing to the right,
     and y increasing downwards), and maps it to a point which may be used to perform geometric
     calculations based on a circle with its center in the center of the view, and the y axis
     increasing upwards instead of downwards, with a radius of the center of the slider track
     
     - parameter screenPoint: the point using the coordinates of this view object
     
     - returns: cartesianPoint the point using the cartesian coordinate system with the circle's radius at its center
     */
    fileprivate func mapScreenPointToSliderCenterTrackPoint(_ screenPoint: CGPoint) -> CGPoint {
        return CGPoint(x: screenPoint.x - self.clockRadius,
                       y: self.clockRadius - screenPoint.y)
    }
    
    /**
     takes a point from the coordinate system used to draw and perform calculations on the clock
     (with the center of the clock in the center of this view, and the y axis increasing upward),
     and maps it to a point which is the actual position in the view, using its normal coordinate system
     (origin is top left, with x increasing to the right and y increasing downwards)
     
     - parameter cartesianPoint: the point using the cartesian coordinate system with the circle's radius at its center
     
     - returns: screenPoint the point using the coordinates of this view object
     */
    fileprivate func mapSliderCenterTrackCoordinatePointToScreenPoint(_ cartesianPoint:  CGPoint) -> CGPoint {
        return CGPoint(x: cartesianPoint.x + self.clockRadius,
                       y: self.clockRadius - cartesianPoint.y)
    }
    
    fileprivate func closestPointOnSliderCenterTrack(_ dragPoint: CGPoint) -> CGPoint? {
        
        // Consider these options for where the drag point lies in relation to the circle
        //   1. The drag point is in the exact center of the circle
        //   2. The drag point is outside the circle
        //   3. The drag point is inside the circle
        //
        // the second two cases may be dealt with similarily
        // First find the equation describing the line formed by joining the circle origin, and the drag point
        // Next, find the two intercepts of the circle with this line (there must be exactly two, since the circle intersects the origin, it must pass through two sides of the circle no matter what angle)
        // Lastly, pick the closest of the two intercepts
        
        // in order to have intercepts with the axis, must translate the circle
        // may as well translate it so that the center of the circle is the origin
        
        let mappedDragPoint = CGPoint(x:dragPoint.x - self.clockRadius, y:dragPoint.y - self.clockRadius)
        let centerOfCircle = CGPoint.zero
        
        let distanceToCenter = mappedDragPoint.distanceToPoint(centerOfCircle)
        if (distanceToCenter < dragTolerance) {
            return nil
        }
        
        let circleCenter = centerOfCircle
        let h = centerOfCircle.x
        let k = centerOfCircle.y
        let r = self.radiusClockCenterToSliderTrackCenter
        
        let intercept = mappedDragPoint.closestInterceptPointToCircle(circleCenter,
                                                                      circleXIntercept: h,
                                                                      circleYIntercept: k,
                                                                      circleRadius: r)
        
        // remember to un-map the found point
        let value = CGPoint(x:intercept.x + self.clockRadius, y:intercept.y + self.clockRadius)
        return value
        
    }
    
    fileprivate func minutesForThumnailCenter(_ cartesianCoordinatePoint: CGPoint) -> (minutes:CGFloat, angle:CGFloat) {
        let angle = self.clockFaceAngle(cartesianCoordinatePoint)
        if (angle.isNaN) {
            // try this calculation again
            let garbage = self.clockFaceAngle(cartesianCoordinatePoint)
            print("\(garbage)")
            return (0, 0)
        }
        let minutes = self.minutesForClockFaceAngle(angle)
        return (minutes, angle)
    }
    
    fileprivate func clockFaceAngle(_ cartesianCoordinateCirclePoint: CGPoint) -> CGFloat {
        
        // with the center of the clock face as the origin, we can use the diagram below
        //
        //                      x
        //                    |---------
        //                    |        /
        //                    |       /
        //                  y |      /
        //                    |     /  radius
        //                    |    /
        //                    | O /
        //                    |  /
        //                    | /
        //                    |/
        //
        // using this formula: sin(theta) = oposite / hypoteneuse
        // sin(angle) = x / radius
        // angle = asin(x / radius)
        
        // the above geometry only works when we are between 0 and 3 o'clock
        let quadrant: ClockQuadrant = ClockQuadrant.mapPointToQuadrant(cartesianCoordinateCirclePoint)
        
        switch (quadrant) {
        case .first:
            var angle = asin(cartesianCoordinateCirclePoint.x / CGFloat(self.radiusClockCenterToSliderTrackCenter))
            if (angle.isNaN) {
                angle = asin( round(cartesianCoordinateCirclePoint.x) / CGFloat(self.radiusClockCenterToSliderTrackCenter))
            }
            return angle
            
        case .second:
            var angle = asin(cartesianCoordinateCirclePoint.x / CGFloat(self.radiusClockCenterToSliderTrackCenter))
            if angle.isNaN {
                angle = asin(round(cartesianCoordinateCirclePoint.x) / CGFloat(self.radiusClockCenterToSliderTrackCenter))
            }
            angle = CGFloat(Double.pi) - angle
            return angle
            
        case .third:
            var angle = asin(-cartesianCoordinateCirclePoint.x / CGFloat(self.radiusClockCenterToSliderTrackCenter))
            if (angle.isNaN) {
                angle = asin( round(-cartesianCoordinateCirclePoint.x) / CGFloat(self.radiusClockCenterToSliderTrackCenter))
            }
            angle = CGFloat(Double.pi) + angle
            return angle
            
        case .fourth:
            var angle = asin(-cartesianCoordinateCirclePoint.x / CGFloat(self.radiusClockCenterToSliderTrackCenter))
            if (angle.isNaN) {
                angle = asin( round(-cartesianCoordinateCirclePoint.x) / CGFloat(self.radiusClockCenterToSliderTrackCenter))
            }
            angle = CGFloat(2.0 * Double.pi) - angle
            return angle
        }
    }
    
    fileprivate func minutesForClockFaceAngle(_ angle: CGFloat) -> CGFloat {
        // angle = (minutes / ticksPerRevolution) * 2 * Pi
        // angle / (2 * Pi) = (minutes / ticksPerRevolution)
        // minutes = (angle * ticksPerRevolution) / (2 * Pi)
        
        let value = (angle * CGFloat(TimeRangeSlider.ticksPerRevolution)) / CGFloat(2 * Double.pi)
        return value
    }
    
    /**
     provides mapping between the position on the clock of the *hour* hand (in minutes),
     and the angle of the *hour* hand from 12 o'clock
     
     - parameter screenMinutes: the number of minutes the hour hand has moved from 12 o'clock position
     
     - returns: clockFaceAngle the angle between the vertical (running to 12) and the current hour hand
     */
    static func clockFaceAngle(_ minutes: CGFloat) -> CGFloat {
        let numberOfTicks = minutes.truncatingRemainder(dividingBy: CGFloat(ticksPerRevolution))
        let value = (CGFloat(numberOfTicks) / CGFloat(ticksPerRevolution)) * CGFloat(2 * Double.pi)
        return value
    }
    
    func originForThumbnail(_ minutes: CGFloat) -> CGPoint {
        var value = CGPoint.zero
        let centerPoint = self.clockSliderView!.thumbnailCenterPoint(minutes)
        let originPoint = CGPoint(x:centerPoint.x - halfSliderTrackWidth,
                                  y:centerPoint.y - halfSliderTrackWidth)
        value = originPoint
        return value
    }
    
    internal func updateThumbLayers() -> Void {
        
        let originForStartSlider = self.originForThumbnail(self.startTimeInMinutes)
        let originForFinishSlider = self.originForThumbnail(self.finishTimeInMinutes)
        self.startKnobView.frame.origin = originForStartSlider
        self.finishKnobView.frame.origin = originForFinishSlider
        
        let useFirstRotationColors = (self.clockRotationCount == .first)
        let finishColor = useFirstRotationColors ? self.firstDayGradientFinishColor : self.secondDayGradientFinishColor
        
        self.finishKnobView.drawableEndAngle = self.sliderEndAngle
        self.finishKnobView.thumbnailColor = finishColor
        self.finishKnobView.setNeedsDisplay()
        self.startKnobView.setNeedsDisplay()
        
        // drawing order should take into account which end is highlighted
        // note: last drawn is on top (higher Z-index)
        if ((self.lastDraggedThumbKnob == .finishThumbKnob) &&
            (self.thumbWithHigherZIndex != .finishThumbKnob)) {
            self.finishKnobView.layer.removeFromSuperlayer()
            self.startKnobView.layer.removeFromSuperlayer()
            self.layer.addSublayer(self.startKnobView.layer)
            self.layer.addSublayer(self.finishKnobView.layer)
            self.thumbWithHigherZIndex = .finishThumbKnob
        }
        else if ((self.lastDraggedThumbKnob == .startThumbKnob) &&
            (self.thumbWithHigherZIndex != .startThumbKnob)) {
            self.finishKnobView.layer.removeFromSuperlayer()
            self.startKnobView.layer.removeFromSuperlayer()
            self.layer.addSublayer(self.finishKnobView.layer)
            self.layer.addSublayer(self.startKnobView.layer)
            self.thumbWithHigherZIndex = .startThumbKnob
        }
    }
    
    internal func updateElapsedTime() -> Void {
        let minutes = self.selectedTimeRangeInMinutes
        var dateTimeComponents = DateComponents.init()
        dateTimeComponents.minute = minutes
        let dateTimeObject = TimeRangeSlider.calendar.date(from: dateTimeComponents)
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        var hourString = 0
        var minuteString = 0
        if let safeDateObject: Date = dateTimeObject {
            hourString = TimeRangeSlider.calendar.component(Calendar.Component.hour, from: safeDateObject)
            minuteString = TimeRangeSlider.calendar.component(Calendar.Component.minute, from: safeDateObject)
        }
        let timeString: NSString = NSString.init(string: "\(hourString)hrs \(minuteString)min")
        let attributedTimeString = NSAttributedString(string: timeString as String, attributes: self.elapsedTimeFontAttributes)
        self.elapsedTimeLabel.attributedText = attributedTimeString
        let maxSize = CGSize(width: self.clockRadius, height: 100)
        var elapsedTimeSize : CGSize = self.elapsedTimeLabel.sizeThatFits(maxSize)
        elapsedTimeSize = CGSize(width: ceil(elapsedTimeSize.width),
                                 height: ceil(elapsedTimeSize.height))
        self.elapsedTimeLabel.layer.bounds = CGRect(origin: CGPoint.zero, size: elapsedTimeSize)
        self.elapsedTimeLabel.layer.position = CGPoint(x:clockRadius,
                                                       y:clockRadius)
    }
    
    
    //MARK: - drawing
    //*************************************************************************
    
    override func draw(_ rect: CGRect) {
        let currentContext : CGContext? = UIGraphicsGetCurrentContext()
        
        currentContext?.saveGState()
        currentContext?.setShouldAntialias(true)
        
        // we want to do all the drawing using the center of the clock as the origin
        // to achieve this, translate the view
        currentContext?.translateBy(x: clockRadius, y: clockRadius)
        
        //
        // the running time in the middle of the clock face
        //
        self.updateElapsedTime()
        
        // the slider and the thumbs
        self.clockSliderView?.setNeedsDisplay()
        self.updateThumbLayers()
        
        currentContext?.restoreGState()
    }
    
    //MARK: - testing
    //*************************************************************************
    
    func test_mapScreenPointToSliderCenterTrackPoint(_ screenPoint: CGPoint) -> CGPoint {
        return mapScreenPointToSliderCenterTrackPoint(screenPoint)
    }
    
    func test_mapCartesianCoordinatePointToScreenPoint(_ cartesianPoint:  CGPoint) -> CGPoint {
        return mapSliderCenterTrackCoordinatePointToScreenPoint(cartesianPoint)
    }
    
    func test_minutesForThumnailCenter(_ cartesianCoordinatePoint: CGPoint) -> CGFloat {
        return minutesForThumnailCenter(cartesianCoordinatePoint).minutes
    }
    
    func test_clockFaceAngle(_ minutes: CGFloat) -> CGFloat {
        return TimeRangeSlider.clockFaceAngle(minutes)
    }
    
    func test_minutesForClockFaceAngle(_ angle: CGFloat) -> CGFloat {
        return minutesForClockFaceAngle(angle)
    }
    
    func test_closestPointOnSliderCenterTrack(_ dragPoint: CGPoint) -> CGPoint? {
        return self.closestPointOnSliderCenterTrack(dragPoint)
    }
    
    func test_roundMinutesToMatchIncrementDuration(_ minutes: CGFloat, incrementDuration: Int) -> Int {
        return TimeRangeSlider.roundMinutesToMatchIncrementDuration(minutes, incrementDuration: incrementDuration)
    }
    
    func test_findMinutesOnClockCircle(_ screenPointA: CGPoint, innerAngle: CGFloat, clockwise: Bool) -> CGFloat {
        return findMinutesOnClockCircle(screenPointA, innerAngle: innerAngle, clockwise: clockwise)
    }
    
    func test_findFinishPointGivenStartPoint(_ screenPoint: CGPoint) -> CGFloat {
        return maximumAllowedFinishMinutesStartingFromStartThumbCenter(screenPoint)
    }
}

