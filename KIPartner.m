//
//  KIPartner.m
//  kiva
//
//  Created by Matias Piipari on 26/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "KIPartner.h"


@implementation KIPartner
@synthesize identifier = _identifier;
@synthesize name = _name;
@synthesize status = _status;
@synthesize rating = _rating;
@synthesize imageItem = _imageItem;
@synthesize startDate = _startDate;
@synthesize countries = _countries;

//=========================================================== 
- (id)init
{
    self = [super init];
    if (self) {
        [self setIdentifier: 0];
        [self setName: nil];
        [self setStatus: nil];
        [self setRating: 0];
        [self setImageItem: nil];
        [self setStartDate: nil];
        [self setCountries: nil];
    }
    return self;
}


@end
