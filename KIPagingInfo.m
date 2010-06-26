//
//  KIPagingInfo.m
//  kiva
//
//  Created by Matias Piipari on 24/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "KIPagingInfo.h"


@implementation KIPagingInfo
@synthesize page = _page;
@synthesize total = _total;
@synthesize pageSize = _pageSize;
@synthesize pages = _pages;

- (id)init
{
    self = [super init];
    if (self) {
        [self setPage: 0];
        [self setTotal: 0];
        [self setPageSize: 0];
        [self setPages: 0];
    }
    return self;
}

-(id) initFromDictionary:(NSDictionary*) dict {
	self = [self init];
	if (self != nil) {
		[self setPage: [[dict objectForKey:@"page"] intValue]];
		
	}
	return self;
}
@end
