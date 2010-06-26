//
//  UIImage.m
//  ImageRank
//
//  Created by Matias Piipari Pear Computers LLP on 19/12/2008.
//  Copyright 2008 Copyright 2008 Pear Computers LLP. All rights reserved.
//

#import "INResizeImageAllocator.h"
@implementation UIImage (INResizeImageAllocator)
+ (UIImage*)imageWithImage:(UIImage*)image 
              scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage*)imageWithImage:(UIImage*)image
                   scaleBy:(CGFloat)scaleFactor {
    CGSize newSize = CGSizeMake(image.size.width * scaleFactor,image.size.height * scaleFactor);
    return [UIImage imageWithImage:image scaledToSize:newSize];
}

+ (UIImage*)imageWithImage:(UIImage*)image
              scaleToWidth: (CGFloat)newWidth {
    CGFloat scaleFactor = newWidth / image.size.width;
    return [UIImage imageWithImage: image 
                           scaleBy: scaleFactor];
}

+ (UIImage*)imageWithImage:(UIImage*)image
             scaleToHeight: (CGFloat)newHeight {
    CGFloat scaleFactor = newHeight / image.size.height;
    return [UIImage imageWithImage: image scaleBy: scaleFactor];
}

- (UIImage*)scaleImageToSize:(CGSize)newSize
{
    return [UIImage imageWithImage:self scaledToSize:newSize];
}

@end
