//
//  KIDataSource.h
//  kiva
//
//  Created by Matias Piipari on 24/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIMediaItem.h"
@class ASINetworkQueue;

@interface KIDataSource : NSObject {
	NSMutableArray *_loans;
	NSMutableArray *_partners;
	
	@protected
	NSMutableSet *_loanIdentifiers;
	NSMutableDictionary *_mediaItemsByID;
	ASINetworkQueue *_queue;
	
	NSUInteger _loanPagesRetrieved;
}

@property (retain, readonly) NSMutableArray *loans;
@property (retain, readwrite) ASINetworkQueue *queue;

+ (id)sharedDataSource;

-(void) requestNewLoansOnPage:(NSUInteger)page;
-(void) requestPartners;
-(void) requestContentForMediaItem:(KIMediaItem*) mediaItem
							  size:(KIMediaItemSize) size;

-(KIMediaItem*) mediaItemByIdentifier:(NSUInteger) identifier;
@end
