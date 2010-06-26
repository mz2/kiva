//
//  KILoansResponse.h
//  kiva
//
//  Created by Matias Piipari on 24/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KIPagingInfo;

@interface KILoansResponse : NSObject {
	KIPagingInfo *_pagingInfo;
	NSArray *_loans;
}

@property (nonatomic, retain) KIPagingInfo *pagingInfo;
@property (nonatomic, retain) NSArray *loans;

@end
