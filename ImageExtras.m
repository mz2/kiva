//
//  ImageViewExtras.m
//  PointDontShout
//
//  Created by Matias Piipari on 2/18/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "ImageExtras.h"


@implementation UIImage(ImageExtras)

CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
};


- (UIImage *)borderedImageWithRect: (CGRect)dstRect radius:(CGFloat)radius 
                       borderColor: (UIColor*) color
                       borderWidth: (CGFloat) borderWidth {
    UIImage *maskedImage = nil;
    
    radius = MIN(radius, .5 * MIN(CGRectGetWidth(dstRect), CGRectGetHeight(dstRect)));
    CGRect interiorRect = CGRectInset(dstRect, radius, radius);
    
    UIGraphicsBeginImageContext(dstRect.size);
    CGContextRef maskedContextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(maskedContextRef);
    
    CGMutablePathRef borderPath = CGPathCreateMutable();
    CGContextBeginPath(maskedContextRef);
    CGPathAddArc(borderPath, NULL, CGRectGetMinX(interiorRect), CGRectGetMinY(interiorRect), radius, DegreesToRadians(180), DegreesToRadians(270), NO);
    CGPathAddArc(borderPath, NULL, CGRectGetMaxX(interiorRect), CGRectGetMinY(interiorRect), radius, DegreesToRadians(270.0), DegreesToRadians(360.0), NO);
    CGPathAddArc(borderPath, NULL, CGRectGetMaxX(interiorRect), CGRectGetMaxY(interiorRect), radius, DegreesToRadians(0.0), DegreesToRadians(90.0), NO);
    CGPathAddArc(borderPath, NULL, CGRectGetMinX(interiorRect), CGRectGetMaxY(interiorRect), radius, DegreesToRadians(90.0), DegreesToRadians(180.0), NO);
    
    CGContextAddPath(maskedContextRef, borderPath);
    CGContextClosePath(maskedContextRef);
    CGContextClip(maskedContextRef);
    
    /*
    borderPath = CGPathCreateMutable();
    CGPathAddArc(borderPath, NULL, CGRectGetMinX(interiorRect), CGRectGetMinY(interiorRect), radius, DegreesToRadians(180), DegreesToRadians(270), NO);
    CGPathAddArc(borderPath, NULL, CGRectGetMaxX(interiorRect), CGRectGetMinY(interiorRect), radius, DegreesToRadians(270.0), DegreesToRadians(360.0), NO);
    CGPathAddArc(borderPath, NULL, CGRectGetMaxX(interiorRect), CGRectGetMaxY(interiorRect), radius, DegreesToRadians(0.0), DegreesToRadians(90.0), NO);
    CGPathAddArc(borderPath, NULL, CGRectGetMinX(interiorRect), CGRectGetMaxY(interiorRect), radius, DegreesToRadians(90.0), DegreesToRadians(180.0), NO);    
    CGContextAddPath(maskedContextRef, borderPath);
    CGContextSetStrokeColorWithColor(maskedContextRef, [[UIColor blackColor] CGColor]);
    CGContextSetLineWidth(maskedContextRef, borderWidth);
    CGContextStrokePath (maskedContextRef);
    */
    
    [self drawInRect: dstRect];
    
    
    maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(maskedContextRef);
    UIGraphicsEndImageContext();
    
    return maskedImage;
}
@end
