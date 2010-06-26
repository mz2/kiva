//
//  KIMediaItem.m
//  kiva
//
//  Created by Matias Piipari on 24/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "KIMediaItem.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@implementation KIMediaItem
@synthesize identifier = _identifier;
@synthesize templateIdentifier = _templateIdentifier;
@synthesize referringObject = _referringObject;

//=========================================================== 
// - (id)init
//
//=========================================================== 
- (id)init
{
    self = [super init];
    if (self) {
        [self setIdentifier: 0];
        [self setTemplateIdentifier: 0];
		_imagesPerSize = [[NSMutableDictionary alloc] init];
		_referringObject = nil;
    }
    return self;
}

-(id) initFromDictionary:(NSDictionary*) dictionary {
	self = [self init];
	if (self != nil) {
		self.identifier = [[dictionary objectForKey:@"id"] intValue];
		self.templateIdentifier = [[dictionary objectForKey:@"template_id"] intValue];
	}
	
	return self;
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
	[_imagesPerSize release], _imagesPerSize = nil;
    [super dealloc];
}


-(NSString*) pathForSize:(KIMediaItemSize) size {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *sizeStr = [KIMediaItem sizeString: size];
	
	return [documentsDirectoryPath stringByAppendingPathComponent: 
			[NSString stringWithFormat:@"%d_%@.jpg", self.identifier, sizeStr]];
}

+(NSString*) sizeString:(KIMediaItemSize) size {
	if (size == KIMediaItemSizeW80H80) {
		return @"w80h80";
	} else if (size == KIMediaItemSizeW200H200) {
		return @"w200h200";
	} else if (size == KIMediaItemSizeW325H250) {
		return @"w325h250";
	} else if (size == KIMediaItemSizeW450H360) {
		return @"w450h360";
	} else if (size == KIMediaItemSizeFullSize) {
		return @"fullsize";
	} else if (size == KIMediaItemSizeResizedToW32H32) {
		return @"w32h32";
	} else if (size == KIMediaItemSizeResizedToMinDim50) {
		return @"dim42max";
	} else if (size == KIMediaItemSizeResizedToMinDim50Bordered) {
		return @"dim42max-bordered";
	}
	
	return nil;
}

-(BOOL) contentIsAvailableForSize:(KIMediaItemSize) size {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *sizeStr = [KIMediaItem sizeString: size];
	
	return [[NSFileManager defaultManager] fileExistsAtPath: [documentsDirectoryPath stringByAppendingPathComponent:
															  [NSString stringWithFormat:@"%d_%@.jpg", self.identifier, sizeStr]]];
}

@end