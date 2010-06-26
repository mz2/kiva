//
//  KICountry.m
//  kiva
//
//  Created by Matias Piipari on 26/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "KICountry.h"


@implementation KICountry
@synthesize isoCode = _isoCode;
@synthesize region = _region;
@synthesize name = _name;
@synthesize location = _location;

- (id)init
{
    self = [super init];
    if (self) {
        [self setIsoCode: nil];
        [self setRegion:nil];
        [self setName: nil];
        [self setLocation: nil];
    }
    return self;
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    [_isoCode release];
    _isoCode = nil;
    [_region release];
    _region = nil;
    [_name release];
    _name = nil;
    [_location release];
    _location = nil;
	
    [super dealloc];
}




@end
