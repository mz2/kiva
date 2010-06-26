//
//  KICountry.h
//  kiva
//
//  Created by Matias Piipari on 26/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;

@interface KICountry : NSObject {
	NSString *_isoCode;
	NSString *_region;
	NSString *_name;
	CLLocation *_location;
}

@property (nonatomic, copy) NSString *isoCode;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) CLLocation *location;

@end
