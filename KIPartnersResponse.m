//
//  KIPartnersResponse.m
//  kiva
//
//  Created by Matias Piipari on 26/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "KIPartnersResponse.h"


@implementation KIPartnersResponse
@synthesize pagingInfo = _pagingInfo;
@synthesize partners = _partners;

//=========================================================== 
// - (id)init
//
//=========================================================== 
- (id)init
{
    self = [super init];
    if (self) {
        [self setPagingInfo: nil];
        [self setPartners: nil];
    }
    return self;
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    [_pagingInfo release];
    _pagingInfo = nil;
    [_partners release];
    _partners = nil;
	
    [super dealloc];
}


@end
