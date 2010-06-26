//
//  KILoan.m
//  kiva
//
//  Created by Matias Piipari on 24/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "KILoan.h"
#import "KIImageItem.h"

#import <CoreLocation/CoreLocation.h>

@implementation KILoan

@synthesize name = _name;
@synthesize location = _location;
@synthesize postedDate = _postedDate;
@synthesize activity = _activity;
@synthesize identifier = _identifier;
@synthesize use = _use;
@synthesize descriptionByLanguage = _descriptionByLanguage;
@synthesize fundedAmount = _fundedAmount;
@synthesize partnerIdentifier = _partnerIdentifier;
@synthesize imageItem = _imageItem;
@synthesize borrowerCount = _borrowerCount;
@synthesize loanAmount = _loanAmount;
@synthesize status = _status;
@synthesize sector = _sector;
@synthesize town = _town;
@synthesize country = _country;

//=========================================================== 
// - (id)init
//
//=========================================================== 
- (id)init
{
    self = [super init];
    if (self) {
        [self setName: nil];
        [self setLocation: nil];
		[self setTown: nil];
		[self setCountry: nil];
        [self setPostedDate: nil];
        [self setActivity: nil];
        [self setIdentifier: 0];
        [self setUse: nil];
        [self setDescriptionByLanguage: nil];
        [self setFundedAmount: 0];
        [self setPartnerIdentifier: 0];
        [self setImageItem: nil];
        [self setBorrowerCount: 0];
        [self setLoanAmount: 0];
        [self setStatus: nil];
        [self setSector: nil];
    }
    return self;
}

-(id) initFromDictionary:(NSDictionary*) dict {
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setTimeStyle:NSDateFormatterFullStyle];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	self = [self init];
	if (self != nil) {
		[self setName: [dict objectForKey:@"name"]];
		NSString *latLonPair = [[[dict objectForKey:@"location"] 
								 objectForKey: @"geo"] 
								objectForKey:@"pairs"];
		NSArray *latLon = [latLonPair componentsSeparatedByString:@" "];

		CLLocationCoordinate2D coords;		
		coords.latitude = [[latLon objectAtIndex: 0] doubleValue];
		coords.longitude = [[latLon objectAtIndex: 1] doubleValue];
		[self setLocation:[[[CLLocation alloc] initWithCoordinate:coords
														altitude:0
											  horizontalAccuracy:kCLLocationAccuracyKilometer 
												verticalAccuracy:kCLLocationAccuracyKilometer 
													   timestamp:[NSDate date]] autorelease]];
		[self setCountry: [[dict objectForKey:@"location"] objectForKey:@"country"]];
		[self setTown: [[dict objectForKey:@"location"] objectForKey:@"town"]];
		
		[self setPostedDate: [dateFormatter dateFromString: [dict objectForKey: @"posted_date"]]];
		if (self.postedDate == nil) {
			PCLog(@"WARNING! Parsing posted date failed from string '%@'", [dict objectForKey:@"posted_date"]);
		}
		[self setActivity: [dict objectForKey:@"activity"]];
		[self setIdentifier: [[dict objectForKey:@"id"] intValue]];
		[self setUse: [dict objectForKey: @"use"]];
		[self setDescriptionByLanguage: [dict objectForKey:@"description"]];
		[self setFundedAmount: [[dict objectForKey:@"funded_amount"] doubleValue]];
		[self setPartnerIdentifier: [[dict objectForKey:@"partner_id"] intValue]];
		
		[self setImageItem:[[[KIImageItem alloc] initFromDictionary: [dict objectForKey:@"image"]] autorelease]];
		[[self imageItem] setReferringObject: self]; //this is a weak ref
		
		[self setBorrowerCount: [[dict objectForKey:@"borrower_count"] intValue]];
		[self setLoanAmount: [[dict objectForKey:@"loan_amount"] doubleValue]];
		[self setStatus: [dict objectForKey: @"status"]];
		[self setSector: [dict objectForKey: @"sector"]];
		
	}
	return self;
}

-(BOOL) isEqual:(id)object {
	if (![object isKindOfClass:[KILoan class]]) return NO;
	
	KILoan *otherObj = (KILoan*) object;
	
	return otherObj.identifier == self.identifier;
}

// MKAnnotation

-(CLLocationCoordinate2D) coordinate {
	return self.location.coordinate;
}

-(NSString*) title {
	return [self name];
}

-(NSString*) subtitle {
	return [self activity];
}

-(NSString*) formattedPostedDate {
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setLocale: [NSLocale currentLocale]];
	[formatter setDateStyle: NSDateFormatterMediumStyle];
	[formatter setTimeStyle: NSDateFormatterNoStyle];
	
	return [formatter stringFromDate: self.postedDate];
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    [_name release];
    _name = nil;
    [_location release];
    _location = nil;
	[_country release];
	_country = nil;
	[_town release];
	_town = nil;
    [_postedDate release];
    _postedDate = nil;
    [_activity release];
    _activity = nil;
    [_use release];
    _use = nil;
    [_descriptionByLanguage release];
    _descriptionByLanguage = nil;
    [_imageItem release];
    _imageItem = nil;
    [_status release];
    _status = nil;
    [_sector release];
    _sector = nil;
	
    [super dealloc];
}




@end
