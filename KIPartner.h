//
//  KIPartner.h
//  kiva
//
//  Created by Matias Piipari on 26/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KIImageItem;

@interface KIPartner : NSObject {
	NSUInteger _identifier;
	NSString *_name;
	NSString *_status;
	NSUInteger _rating;
	KIImageItem *_imageItem;
	NSDate *_startDate;
	NSArray *_countries;
}

@property (nonatomic) NSUInteger identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *status;
@property (nonatomic) NSUInteger rating;
@property (nonatomic, retain) KIImageItem *imageItem;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSArray *countries;

@end
