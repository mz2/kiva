//
//  KIImageItem.m
//  kiva
//
//  Created by Matias Piipari on 24/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "KIImageItem.h"


@implementation KIImageItem

-(id) initFromDictionary:(NSDictionary*) dict {
	self = [super initFromDictionary: dict];
	
	if (self != nil) {
		//foo
	}
	
	return self;
}



-(UIImage*) imageForSize:(KIMediaItemSize) size {
	NSNumber *sizeNum = [NSNumber numberWithInt: size];
	if ([_imagesPerSize objectForKey: sizeNum] == nil) {
		[_imagesPerSize setObject: [UIImage imageWithContentsOfFile:[self pathForSize: size]] 
						   forKey: sizeNum];
	}
	
	return [_imagesPerSize objectForKey: sizeNum];
}

@end
