//
//  ClockSliderView.swift
//  clock_slider_view
//
//  Created by Jason Cross on 3/19/18.
//  Copyright © 2018 Cross Swim Training, Inc. All rights reserved.
//


import UIKit

class ClockSliderView: UIView {
    var ringWidth: CGFloat
    let rotationEachHour : CGFloat
    let numberOfHours = 12
    internal var sliderStartAngle: CGFloat
    internal var sliderEndAngle: CGFloat
    internal var clockDuration: Int = 0
    internal var clockRotationCount: ClockRotationCount
    let radiusClockCenterToSliderTrackCenter: CGFloat
    let clockRadius: CGFloat
    let halfSliderTrackWidth : CGFloat
    let centerSliderTrackRadiusSquared: CGFloat
    var firstDayGradientStartColor : UIColor = UIColor(red: 0.933,
                                                       green: 0.424,
                                                       blue: 0.149,
                                                       alpha: 1.00) {
        didSet {
            self.breakStartAndFinishColorsIntoComponents()
        }
    }
    var firstDayGradientFinishColor : UIColor = UIColor(red: 0.965,
                                                        green: 0.965,
                                                        blue: 0.065,
                                                        alpha: 1.00) {
        didSet {
            self.breakStartAndFinishColorsIntoComponents()
        }
    }
    var secondDayGradientStartColor : UIColor = UIColor(red: 0.072,
                                                        green: 0.878,
                                                        blue: 0.087,
                                                        alpha: 1.00) {
        didSet {
            self.breakStartAndFinishColorsIntoComponents()
        }
    }
    var secondDayGradientFinishColor : UIColor = UIColor(red: 0.833,
                                                         green: 0.994,
                                                         blue: 0.342,
                                                         alpha: 1.00) {
        didSet {
            self.breakStartAndFinishColorsIntoComponents()
        }
    }
    internal var firstDayStartRed: CGFloat = 0
    internal var firstDayStartGreen: CGFloat = 0
    internal var firstDayStartBlue: CGFloat = 0
    internal var firstDayStartAlpha: CGFloat = 0
    internal var firstDayEndRed:  CGFloat = 0
    internal var firstDayEndGreen:  CGFloat = 0
    internal var firstDayEndBlue: CGFloat = 0
    internal var firstDayEndAlpha: CGFloat = 0
    internal var secondDayStartRed: CGFloat = 0
    internal var secondDayStartGreen: CGFloat = 0
    internal var secondDayStartBlue: CGFloat = 0
    internal var secondDayStartAlpha: CGFloat = 0
    internal var secondDayEndRed:  CGFloat = 0
    internal var secondDayEndGreen:  CGFloat = 0
    internal var secondDayEndBlue: CGFloat = 0
    internal var secondDayEndAlpha: CGFloat = 0
    internal let screenScale: CGFloat
    internal let angleEquivalentToOnePixel: CGFloat = CGFloat(Double.pi / 360.0)
    internal let thresholdForAdjustingArcRaduis = 2
    
    
    
    init(_frame: CGRect,
         _ringWidth: CGFloat,
         _sliderStartAngle: CGFloat,
         _sliderEndAngle: CGFloat,
         _clockRotationCount: ClockRotationCount) {
        ringWidth = _ringWidth
        rotationEachHour = CGFloat(CGFloat(2 * Double.pi) / CGFloat(self.numberOfHours))
        halfSliderTrackWidth = (ringWidth / 2.0)
        screenScale = UIScreen.main.scale
        let diameter = CGFloat(fminf(Float(_frame.size.width),
                                     Float(_frame.size.height)))
        clockRadius = diameter / 2.0
        
        // uses the fact that lines are stroked half on each side of the line
        radiusClockCenterToSliderTrackCenter = clockRadius - halfSliderTrackWidth
        centerSliderTrackRadiusSquared = (radiusClockCenterToSliderTrackCenter * radiusClockCenterToSliderTrackCenter)
        sliderStartAngle = _sliderStartAngle
        sliderEndAngle = _sliderEndAngle
        clockRotationCount = _clockRotationCount
        
        super.init(frame: _frame)
        
        self.breakStartAndFinishColorsIntoComponents()
        self.backgroundColor = UIColor.clear
    }
    
    func setClock(startAngle: CGFloat,
                  finishAngle: CGFloat,
                  clockDuration: Int,
                  rotationCount: ClockRotationCount) {
        self.sliderStartAngle = startAngle
        self.sliderEndAngle = finishAngle
        self.clockDuration = clockDuration
        self.clockRotationCount = rotationCount
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func breakStartAndFinishColorsIntoComponents() -> Void {
        self.firstDayGradientStartColor.getRed(&firstDayStartRed,
                                               green: &firstDayStartGreen,
                                               blue: &firstDayStartBlue,
                                               alpha: &firstDayStartAlpha)
        
        self.firstDayGradientFinishColor.getRed(&firstDayEndRed,
                                                green: &firstDayEndGreen,
                                                blue: &firstDayEndBlue,
                                                alpha: &firstDayEndAlpha)
        
        self.secondDayGradientStartColor.getRed(&secondDayStartRed,
                                                green: &secondDayStartGreen,
                                                blue: &secondDayStartBlue,
                                                alpha: &secondDayStartAlpha)
        
        self.secondDayGradientFinishColor.getRed(&secondDayEndRed,
                                                 green: &secondDayEndGreen,
                                                 blue: &secondDayEndBlue,
                                                 alpha: &secondDayEndAlpha)
    }
    
    
    
    
    func thumbnailCenterPoint(_ minutes: CGFloat) -> CGPoint {
        var value = CGPoint.zero
        
        //                      opposite
        //                    |---------
        //                    |        /
        //                    |       /
        //           adjacent |      /
        //                    |     /  hypoteneuse
        //                    |    /
        //                    | O /
        //                    |  /
        //                    | /
        //                    |/
        //
        // Picture a clock face, with 12 o'clock in the expected north position.
        // In iOS, any arc drawing is done starting from the X-plane, which would be at 3 o'clock.
        // To compensate for this, start all arc drawing from 1/4 turn counter-clockwise: - Pi/2.
        // Therefore picture one line segment heading directly north, to 12 o'clock.
        // The second line segment will where the hour hand would be at 1 o'clock.
        // The angle is between these two lines
        let angle = TimeRangeSlider.clockFaceAngle(minutes)
        
        // We know the length of the line segment from the center of the clock to the 1 o'clock position
        let hypoteneuse = radiusClockCenterToSliderTrackCenter
        
        // Now draw a line from the center of the "ring", or the 1 o'clock position,
        // horizontally straight across (to the left), which will intersect the 12 o'clock line
        var opposite: CGFloat
        
        // Now use geometry to solve for the opposite length
        // using this formula: sin(theta) = oposite / hypoteneuse
        // which gives: opposite = sin(theta) * hypoteneuse
        opposite = sin(angle) * hypoteneuse
        
        // likewise the adjacent may be found
        // using the formula: cos(theta) = adjacent / hypoteneuse
        let adjacent: CGFloat = cos(angle) * hypoteneuse
        
        // Remember that the X-axis runs from the center of the clock to the 3 o'clock position
        // And the Y-axis runs between 6 o'clock and 12 o'clock, but running up is negative.
        // Also remember that our drawRect uses a translated coordinate system;
        // without translation, the origin would be in the upper left corder
        value = CGPoint(x: opposite + clockRadius,
                        y: -adjacent + clockRadius)
        return value
    }
    
    
    
    
    
    
    
    
    override func draw(_ rect: CGRect) {
        
        let context : CGContext? = UIGraphicsGetCurrentContext()
        
        // If you want to fill a shape with a shading, you use that shape to modify the clipping area to that shape and paint the shading. You can’t directly use a shading to stroke a shape, but you can achieve the equivalent effect in Tiger and later versions by using the function CGContextReplacePathWithStrokedPath to create a path whose interior is the area that would have been painted by stroking the current path. Clipping to the resulting path and then drawing the shading produces the same result as stroking with the shading.
        context?.saveGState()
        
        context?.setShouldAntialias(true)
        
        // we want to do all the drawing using the center of the clock as the origin
        // to achieve this, translate the view
        context?.translateBy(x: clockRadius, y: clockRadius)
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(self.ringWidth)
        
        // drawArc only "works" under certain conditions:
        //  - moving from the start angle to the end angle must be in the positive direction
        //  - so always start with the start angle at 0
        //  - then adjust the end angle to be positive if required
        //  - don't interfere with the end angle if we don't have to
        let axisAdjustment = self.sliderStartAngle - CGFloat((Double.pi / 2.0))
        context?.rotate(by: axisAdjustment)
        var drawableEndAngle = self.sliderEndAngle - self.sliderStartAngle
        
        // when the start and finish hands are the same, we want the clock to draw a complete arc,
        // except when the hour is supposed to be zero -- in that case, we don't want any arc drawn
        if(abs(drawableEndAngle) < angleEquivalentToOnePixel) {
            if (self.clockDuration > thresholdForAdjustingArcRaduis ){
                drawableEndAngle -= angleEquivalentToOnePixel
            }
        }
        
        if (drawableEndAngle < 0) {
            drawableEndAngle += CGFloat(2.0 * Double.pi)
        }
        
        let useFirstRotationColors = (self.clockRotationCount == .first)
        let startColor = useFirstRotationColors ? self.firstDayGradientStartColor : self.secondDayGradientStartColor
        
        let startRed = useFirstRotationColors ? self.firstDayStartRed : self.secondDayStartRed
        let startGreen = useFirstRotationColors ? self.firstDayStartGreen : self.secondDayStartGreen
        let startBlue = useFirstRotationColors ? self.firstDayStartBlue : self.secondDayStartBlue
        let endRed = useFirstRotationColors ? self.firstDayEndRed : self.secondDayEndRed
        let endGreen = useFirstRotationColors ? self.firstDayEndGreen : self.secondDayEndGreen
        let endBlue = useFirstRotationColors ? self.firstDayEndBlue : self.secondDayEndBlue
        
        // draw the slider colored donut segment in three stages:
        // 1. the start end cap
        // 2. the middle segment
        // 3. the finish end cap
        
        //
        // 1. the start end cap
        //
        let drawableStartAngle = CGFloat(0)
        context?.beginPath()
        context?.addArc(center: rect.origin,
                        radius: radiusClockCenterToSliderTrackCenter,
                        startAngle: drawableStartAngle - self.angleEquivalentToOnePixel,
                        endAngle: drawableStartAngle,
                        clockwise: false)
        context?.setStrokeColor(startColor.cgColor)
        context?.strokePath()
        
        //
        // 2. the middle segment
        //
        // create a path whose interior is the area that would have been painted by stroking the current path
        context?.beginPath()
        context?.addArc(center: rect.origin,
                        radius: radiusClockCenterToSliderTrackCenter,
                        startAngle: drawableStartAngle,
                        endAngle: drawableEndAngle,
                        clockwise: false)
        context?.setStrokeColor(startColor.cgColor)
        context?.replacePathWithStrokedPath()
        
        // Clipping to the resulting path
        context?.clip()
        
        
        // shade each "slice" of the donut using a different linear gradient
        
        // without this, there is a drawing bug which is visible by dark artifacts as part of the gradient
        // It appears as though the drawing routine is "skipping" some of the fill between sections
        // This is visible by setting the sliceOverlapToHideBorder to zero, and setting the
        // numberOfRequiredSlices to a small number (e.g. 5)
        let sliceOverlapToHideBorder = CGFloat(Double.pi / 120.0)
        
        let gradientStartAngle: CGFloat = drawableStartAngle
        let gradientEndAngle: CGFloat = drawableEndAngle - sliceOverlapToHideBorder
        let angleDifference: CGFloat = gradientEndAngle - gradientStartAngle
        let arcDistance: CGFloat = abs(angleDifference * clockRadius)
        
        // how many slices do we need? assuming a screen resolution of 3X, select 3 x the arc distance
        var numberOfRequiredSlices: Int = abs(Int(round(arcDistance * traitCollection.displayScale)))/10
        numberOfRequiredSlices = 36

        let angleIncrementPerSlice = min(abs(angleDifference / CGFloat(numberOfRequiredSlices)), 256)
        
        var sliceStartAngle: CGFloat = gradientStartAngle
        
        for sliceNumber in 0...numberOfRequiredSlices - 1 {
            context?.saveGState()
            let fraction : CGFloat = CGFloat(sliceNumber + 1) / CGFloat(numberOfRequiredSlices)
            let sliceColor = UIColor(red: (fraction * endRed + (1-fraction) * startRed ),
                                     green: (fraction * endGreen + (1-fraction) * startGreen),
                                     blue: (fraction * endBlue + (1-fraction) * startBlue),
                                     alpha: 1)
            let sliceEndAngle = sliceStartAngle + angleIncrementPerSlice
            
            context?.beginPath()
            context?.move(to: rect.origin)
            context?.addArc(center: rect.origin,
                            radius: clockRadius,
                            startAngle: sliceStartAngle,
                            endAngle: sliceEndAngle + sliceOverlapToHideBorder,
                            clockwise: false)
            context?.setFillColor(sliceColor.cgColor)
            context?.setStrokeColor(sliceColor.cgColor)
            context?.fillPath()
            
            context?.restoreGState()
            
            // increment for next iteration
            sliceStartAngle = sliceEndAngle
        }
        context?.restoreGState() // state started for the slider, closed here
        
        //
        // 3. the finish end cap
        //
        
        // handled by the control itself
        
        //
        // images for thumb sliders
        //
        
        // handled by the control itself
        
        
    }
    
    
    
    
}

