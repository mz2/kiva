//
//  KILoan.h
//  kiva
//
//  Created by Matias Piipari on 24/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class CLLocation;
@class KIImageItem;

@interface KILoan : NSObject <MKAnnotation> {
	NSString *_name;
	
	CLLocation *_location;
	NSString *_town;
	NSString *_country;
	
	NSDate *_postedDate;
	NSString *_activity;
	NSUInteger _identifier;
	NSString *_use;
	NSDictionary *_descriptionByLanguage;
	
	double _fundedAmount;
	NSUInteger _partnerIdentifier;
	
	KIImageItem *_imageItem;
	
	NSUInteger _borrowerCount;
	double _loanAmount;
	
	NSString *_status;
	NSString *_sector;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) NSString *town;
@property (nonatomic, retain) NSString *country;

@property (nonatomic, retain) NSDate *postedDate;
@property (nonatomic, retain, readonly) NSString *formattedPostedDate;
@property (nonatomic, copy) NSString *activity;
@property (nonatomic) NSUInteger identifier;
@property (nonatomic, copy) NSString *use;
@property (nonatomic, retain) NSDictionary *descriptionByLanguage;
@property (nonatomic) double fundedAmount;
@property (nonatomic) NSUInteger partnerIdentifier;
@property (nonatomic, retain) KIImageItem *imageItem;
@property (nonatomic) NSUInteger borrowerCount;
@property (nonatomic) double loanAmount;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *sector;

-(id) initFromDictionary:(NSDictionary*) dict;
@end
