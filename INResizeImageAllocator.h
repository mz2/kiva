//
//  UIImage.h
//  ImageRank
//
//  Created by Matias Piipari Pear Computers LLP on 19/12/2008.
//  Copyright 2008 Copyright 2008 Pear Computers LLP. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@interface UIImage (INResizeImageAllocator)

+ (UIImage*)imageWithImage: (UIImage*)image
              scaledToSize: (CGSize)newSize;

+ (UIImage*)imageWithImage:(UIImage*)image
              scaleBy: (CGFloat)scaleFactor;

+ (UIImage*)imageWithImage:(UIImage*)image
              scaleToWidth: (CGFloat)newWidth;

+ (UIImage*)imageWithImage:(UIImage*)image
              scaleToHeight: (CGFloat)newHeight;

- (UIImage*) scaleImageToSize:(CGSize)newSize;

@end