//
//  KIDataSource.m
//  kiva
//
//  Created by Matias Piipari on 24/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "KIDataSource.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "SBJSONScanner.h"
#import "KIPagingInfo.h"
#import "KILoansResponse.h"
#import "KILoan.h"
#import "KIPartner.h"
#import "KICountry.h"
#import "KIPartnersResponse.h"
#import "KIMediaItem.h"
#import "KIImageItem.h"

@implementation KIDataSource
@synthesize loans = _loans;
@synthesize queue = _queue;

-(void) requestNewLoansOnPage:(NSUInteger)page {
	PCLog(@"Requesting new loans on page %d", page);
	if (page == 1) {//reset
		_loanPagesRetrieved = 0;
	}
	ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:
						   [NSURL URLWithString:[NSString stringWithFormat:@"http://api.kivaws.org/v1/loans/newest.json?page=%d",page]]];
	req.delegate = self;
	req.didFinishSelector = @selector(newLoansRequestFinished:);
	req.didFailSelector	= @selector(newLoansRequestFailed:);
	
	[self.queue addOperation: req];
	[self.queue go];
}

-(void) newLoansRequestFinished:(ASIHTTPRequest*) req {
	PCLog(@"New loans request finished");
	SBJSONScanner *scanner = [[[SBJSONScanner alloc] initWithString: [req responseString]] autorelease];
	
	NSDictionary *dict = nil;
	[scanner scanDictionary: &dict];
	
	if (dict != nil) {
		KIPagingInfo *pagingInfo = [[[KIPagingInfo alloc] initFromDictionary: [dict objectForKey:@"paging"]] autorelease];
		
		KILoansResponse *response = [[[KILoansResponse alloc] init] autorelease];
		[response setPagingInfo: pagingInfo];
		
		NSMutableArray *loans = [NSMutableArray array];
		NSArray *loanDicts = [dict objectForKey:@"loans"];
		for (NSDictionary *loanDict in loanDicts) {
			KILoan *loan = [[[KILoan alloc] initFromDictionary: loanDict] autorelease];
			[loans addObject: loan];
		
			NSNumber *loanID = [NSNumber numberWithInt: loan.identifier];
			if (![_loanIdentifiers containsObject: loanID]) {
				[_loanIdentifiers addObject: loanID];
				[_loans addObject: loan];
			} else {
				NSUInteger i = [_loans indexOfObject: loan];
				[_loans removeObjectAtIndex: i];
				[_loans insertObject: loan atIndex: i];
			}
		}
		for (KILoan *loan in loans) {
			if (loan.imageItem != nil) {
				NSNumber *identifier = [NSNumber numberWithInt: loan.imageItem.identifier];
				[_mediaItemsByID setObject: loan.imageItem 
									forKey: identifier];
			}
		}
		
		if (_loanPagesRetrieved < pagingInfo.page) {
			_loanPagesRetrieved = pagingInfo.page;
		}
		
		if (_loanPagesRetrieved < 5) {
			PCLog(@"Retrieving next page (%d)", _loanPagesRetrieved+1);
			[self requestNewLoansOnPage: _loanPagesRetrieved+1];
		}
		
		[response setLoans: loans];
		[[NSNotificationCenter defaultCenter] postNotificationName: kKILoansRequestFinishedNotification
															object: response];
		
		
	}
}

-(void) newLoansRequestFailed:(ASIHTTPRequest*) req {
	PCLog(@"New loans request failed:%@", [[req error] localizedDescription]);
}

-(void) requestContentForMediaItem:(KIMediaItem*) mediaItem
							  size:(KIMediaItemSize) size {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	
	NSString *sizeStr = [KIMediaItem sizeString: size];
	NSString *urlStr = [NSString stringWithFormat:@"http://www.kiva.org/img/%@/%d.jpg",sizeStr, mediaItem.identifier];
	NSURL *url = [NSURL URLWithString: urlStr];
	ASIHTTPRequest *req = 
	[[ASIHTTPRequest alloc] initWithURL: url];
	req.delegate = self;
	req.didFinishSelector = @selector(contentRequestFinished:);
	req.didFailSelector = @selector(contentRequestFailed:);
	req.downloadDestinationPath = [documentsDirectoryPath stringByAppendingPathComponent:
								   [NSString stringWithFormat:@"%d_%@.jpg", mediaItem.identifier, sizeStr]];
	req.temporaryFileDownloadPath = [documentsDirectoryPath stringByAppendingPathComponent:
									 [NSString stringWithFormat:@"%d_%@.jpg.tmp", mediaItem.identifier, sizeStr]];
	[req setAllowResumeForFileDownloads:YES];
	PCLog(@"Making a request for media item %d", mediaItem.identifier);
	[req setUserInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:mediaItem.identifier],[NSNumber numberWithInt: size],nil] 
												 forKeys:[NSArray arrayWithObjects:kKIMediaItemIdentifierKey,kKIMediaItemSizeKey, nil]]];
	[_queue addOperation: req];
	[_queue go];
	
	PCLog(@"URL:'%@'",[url description]);
}

-(KIMediaItem*) mediaItemByIdentifier:(NSUInteger)identifier {
	return [_mediaItemsByID objectForKey:[NSNumber numberWithInt: identifier]];
}

-(void) contentRequestFinished:(ASIHTTPRequest*) req {
	NSNumber *size = [[req userInfo] objectForKey:kKIMediaItemSizeKey];
	NSUInteger sizeId = [size intValue];
	NSUInteger itemId = [[[req userInfo] objectForKey:kKIMediaItemIdentifierKey] intValue];
	KIMediaItem *mediaItem = [self mediaItemByIdentifier: itemId];
	
	if (sizeId == KIMediaItemSizeW80H80) {
		UIImage *img = [UIImage imageWithContentsOfFile: [mediaItem pathForSize: KIMediaItemSizeW80H80]];
		UIImage *resizedImage  = [UIImage imageWithImage:img scaledToSize:CGSizeMake(32, 32)];
		NSData *jpegData = UIImageJPEGRepresentation(resizedImage, 1.0);
		
		NSError *err = nil;
		[jpegData writeToFile:[mediaItem pathForSize:KIMediaItemSizeResizedToW32H32] 
					  options:0 
						error:&err];
		
		UIImage *resizedTo50WidthImage  = [UIImage imageWithImage:img scaleToWidth: 50];
		
		err = nil;
		NSData *resizedTo50JpegData = UIImageJPEGRepresentation(resizedTo50WidthImage, 1.0);
		[resizedTo50JpegData writeToFile:[mediaItem pathForSize:KIMediaItemSizeResizedToMinDim50] 
								 options:0 
								   error:&err];
		
		UIImage *borderedImage = [resizedTo50WidthImage borderedImageWithRect:CGRectMake(0, 0, resizedTo50WidthImage.size.width, resizedTo50WidthImage.size.height) 
													 radius:6.0 
												borderColor:[UIColor clearColor] 
												borderWidth:0.0];
		
		NSData *pngDataBordered = UIImagePNGRepresentation(borderedImage);
		if (err != nil) {
			PCLog(@"Writing resized media item to file failed"); 
		}
		
		err = nil;
		[pngDataBordered writeToFile:[mediaItem pathForSize:KIMediaItemSizeResizedToMinDim50Bordered] 
					  options:0 
						error:&err];
	}

	PCLog(@"ID:%d", itemId);
	NSParameterAssert(mediaItem != nil);
	
	[[NSNotificationCenter defaultCenter] postNotificationName: kKIMediaItemContentReceivedNotification 
														object: mediaItem 
													  userInfo: nil];

}

-(void) contentRequestFailed:(ASIHTTPRequest*) req {
	PCLog(@"Content request failed: %@", [[req error] description]);
}


-(void) requestPartners {
	ASIHTTPRequest *req = 
		[ASIHTTPRequest requestWithURL:
		 [NSURL URLWithString:@"http://api.kivaws.org/v1/partners.json"]];
	req.delegate = self;
	req.didFinishSelector = @selector(partnersRequestFinished:);
	req.didFailSelector = @selector(partnersRequestFailed:);
}

-(void) partnersRequestFinished:(ASIHTTPRequest*) req {
	SBJSONScanner *scanner = [[SBJSONScanner alloc] init];
	
	NSMutableDictionary *dict = nil;
	[scanner scanDictionary: &dict];
	KIPagingInfo *info = 
		[[KIPagingInfo alloc] initFromDictionary: [dict objectForKey:@"paging"]];
	NSMutableArray *partners = [NSMutableArray array];
	
	NSArray *pDicts = [dict objectForKey:@"partners"];
	for (NSDictionary *pDict in pDicts) {
		KIPartner *partner = [[[KIPartner alloc] init] autorelease];
		partner.name = [pDict objectForKey:@"name"];
		partner.identifier = [[pDict objectForKey:@"id"] intValue];
		partner.status = [pDict objectForKey:@"status"];
		partner.rating = [[pDict objectForKey:@"rating"] intValue];
		partner.startDate = [pDict objectForKey:@"start_date"];
		
		NSMutableArray *countries = [NSMutableArray array];
		NSArray *cArray = [pDict objectForKey:@"countries"];
		for (NSDictionary *cDict in cArray) {
			KICountry *country = [[[KICountry alloc] init] autorelease];
			country.isoCode = [cDict objectForKey:@"iso_code"];
			country.name = [cDict objectForKey:@"name"];
			NSString *latLonPair = [[cDict objectForKey:@"location"] objectForKey:@"geo"];
			
			NSArray *latLon = [latLonPair componentsSeparatedByString:@" "];
			CLLocationCoordinate2D coords;
			coords.latitude = [[latLon objectAtIndex: 0] intValue];
			coords.longitude = [[latLon objectAtIndex: 1] intValue];
			CLLocation *location = 
				[[CLLocation alloc] initWithCoordinate:coords 
											  altitude:0 
									horizontalAccuracy:0 
									  verticalAccuracy:0 
											 timestamp:[NSDate date]];
			country.location = location;
			[countries addObject: country];
		}
		partner.countries = countries;
		
		[partners addObject: partner];
	}
	
	KIPartnersResponse *response = [[[KIPartnersResponse alloc] init] autorelease];
	response.pagingInfo = info;
	response.partners = partners;
	
	[[NSNotificationCenter defaultCenter] 
		postNotificationName: kKIPartnersRequestFinishedNotification object: response];
}

-(void) partnersRequestFailed:(ASIHTTPRequest*) req {
	PCLog(@"Requesting partners failed:  %@", [[req error] localizedDescription]);
}

//init stuff
-(id) init {
	PCLog(@"Initialising data source");
	self = [super init];
	if (self != nil) {
		_queue = [[ASINetworkQueue alloc] init];
		_loans = [[NSMutableArray alloc] init];
		_loanIdentifiers = [[NSMutableSet alloc] init];
		_mediaItemsByID = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

static KIDataSource *sharedInstance = nil; 

+ (void)initialize
{
    if (sharedInstance == nil)
        sharedInstance = [[self alloc] init];
}

+ (id)sharedDataSource
{
    //Already set by +initialize.
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone*)zone
{
    //Usually already set by +initialize.
    @synchronized(self) {
        if (sharedInstance) {
            //The caller expects to receive a new object, so implicitly retain it
            //to balance out the eventual release message.
            return [sharedInstance retain];
        } else {
            //When not already set, +initialize is our caller.
            //It's creating the shared instance, let this go through.
            return [super allocWithZone:zone];
        }
    }
	
	return nil;
}

- (void)dealloc
{
    [_loans release],_loans = nil;
    [_loanIdentifiers release],_loanIdentifiers = nil;
	[_mediaItemsByID release],_mediaItemsByID = nil;
    [_queue release],_queue = nil;
	
    [super dealloc];
}

@end
