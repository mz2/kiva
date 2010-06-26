//
//  KIPartnersResponse.h
//  kiva
//
//  Created by Matias Piipari on 26/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KIPagingInfo;

@interface KIPartnersResponse : NSObject {
	KIPagingInfo *_pagingInfo;
	NSArray *_partners;
}

@property (nonatomic, retain) KIPagingInfo *pagingInfo;
@property (nonatomic, retain) NSArray *partners;

@end
