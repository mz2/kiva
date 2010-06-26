//
//  KIPagingInfo.h
//  kiva
//
//  Created by Matias Piipari on 24/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KIPagingInfo : NSObject {
	NSUInteger _page;
	NSUInteger _total;
	NSUInteger _pageSize;
	NSUInteger _pages;
}

@property (nonatomic) NSUInteger page;
@property (nonatomic) NSUInteger total;
@property (nonatomic) NSUInteger pageSize;
@property (nonatomic) NSUInteger pages;

-(id) initFromDictionary:(NSDictionary*) dict;
@end
