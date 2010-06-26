//
//  KILoansResponse.m
//  kiva
//
//  Created by Matias Piipari on 24/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "KILoansResponse.h"


@implementation KILoansResponse
@synthesize pagingInfo = _pagingInfo;
@synthesize loans = _loans;


//=========================================================== 
// - (id)init
//
//=========================================================== 
- (id)init
{
    self = [super init];
    if (self) {
        [self setPagingInfo: nil];
        [self setLoans: nil];
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
    [_loans release];
    _loans = nil;
	
    [super dealloc];
}





@end
