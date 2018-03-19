//
//  ThumbnailView.swift
//  clock_slider_view
//
//  Created by Jason Cross on 3/19/18.
//  Copyright © 2018 Cross Swim Training, Inc. All rights reserved.
//


import UIKit

class ThumbnailView: UIView {
    
    @IBInspectable
    var thumbnailImage : UIImage?
    var thumbnailColor: UIColor?
    var isHighlighted: Bool = false
    
    let ringWidth: CGFloat
    let radiusClockCenterToSliderTrackCenter: CGFloat
    let clockRadius: CGFloat
    let halfSliderTrackWidth: CGFloat
    internal let angleEquivalentToOnePixel: CGFloat = CGFloat(Double.pi / 360.0)
    var drawableEndAngle: CGFloat = 0
    
    init(_frame: CGRect,
         _ringWidth: CGFloat,
         _clockRadius: CGFloat) {
        
        ringWidth = _ringWidth
        halfSliderTrackWidth = (ringWidth / 2.0)
        clockRadius = _clockRadius
        radiusClockCenterToSliderTrackCenter = clockRadius - halfSliderTrackWidth
        super.init(frame: _frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context : CGContext? = UIGraphicsGetCurrentContext()
        
        if (nil != self.thumbnailColor) {
            context?.saveGState()
            
            context?.setFillColor(thumbnailColor!.cgColor)
            context?.beginPath()
            let center = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
            
            context?.addArc(center: center,
                            radius: halfSliderTrackWidth,
                            startAngle: drawableEndAngle - CGFloat((Double.pi / 2.0)),
                            endAngle: drawableEndAngle + CGFloat((Double.pi / 2.0)),
                            clockwise: false)
            context?.closePath()
            context?.fillPath()
            
            context?.restoreGState()
        }
        
        // draw the end thumb last
        if (nil != self.thumbnailImage) {
            let imageRect = CGRect(x: 2,
                                   y: 2,
                                   width: rect.size.width - 4,
                                   height: rect.size.height - 4)
            self.thumbnailImage!.draw(in: imageRect)
        }
    }
    
}

