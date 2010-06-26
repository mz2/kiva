//
//  ImageViewExtras.h
//  PointDontShout
//
//  Created by Matias Piipari on 2/18/09.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage(ImageExtras)

- (UIImage *)borderedImageWithRect: (CGRect)dstRect radius:(CGFloat)radius 
                       borderColor: (UIColor*) color
                       borderWidth: (CGFloat) bw;

@end
