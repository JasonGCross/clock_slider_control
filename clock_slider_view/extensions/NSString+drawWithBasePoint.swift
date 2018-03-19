//
//  NSString+drawWithBasePoint.swift
//  clock_slider_view
//
//  Created by Jason Cross on 3/19/18.
//  Copyright © 2018 Cross Swim Training, Inc. All rights reserved.
//

import UIKit

extension NSString {
    
    func drawWithBasePoint(_ basePoint:CGPoint,
                           angle:CGFloat,
                           fontAttributes:[NSAttributedStringKey:AnyObject],
                           context:CGContext
        ) {
        
        let textSize:CGSize = self.size(withAttributes: fontAttributes)
        
        // sizeWithAttributes is only effective with single line NSString text
        // use boundingRectWithSize for multi line text
        
        let t:CGAffineTransform   =   CGAffineTransform(translationX: basePoint.x, y: basePoint.y)
        let r:CGAffineTransform   =   CGAffineTransform(rotationAngle:angle)
        
        context.concatenate(t)
        context.concatenate(r)
        
        self.draw(at: CGPoint(x:-1 * textSize.width / 2,
                              y: -1 * textSize.height / 2),
                  withAttributes: fontAttributes)
        
        context.concatenate(r.inverted())
        context.concatenate(t.inverted())
    }
}
