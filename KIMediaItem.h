//
//  KIMediaItem.h
//  kiva
//
//  Created by Matias Piipari on 24/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum KIMediaItemSize {
	KIMediaItemSizeW80H80 = 1,
	KIMediaItemSizeW200H200 = 2,
	KIMediaItemSizeW325H250 = 3,
	KIMediaItemSizeW450H360 = 4,
	KIMediaItemSizeFullSize = 5,
	KIMediaItemSizeResizedToW32H32 = 6,
	KIMediaItemSizeResizedToMinDim42 = 7,
	KIMediaItemSizeResizedToMinDim42Bordered = 8
} KIMediaItemSize;

@interface KIMediaItem : NSObject {
	NSUInteger _identifier;
	NSUInteger _templateIdentifier;
	
	id _referringObject;
	
	@protected
	NSMutableDictionary *_imagesPerSize;
}

@property (nonatomic) NSUInteger identifier;
@property (nonatomic) NSUInteger templateIdentifier;
@property (nonatomic,assign) id referringObject;

+(NSString*) sizeString:(KIMediaItemSize) size;
-(NSString*) pathForSize:(KIMediaItemSize) size;
-(BOOL) contentIsAvailableForSize:(KIMediaItemSize) size;

-(id) initFromDictionary:(NSDictionary*) dictionary;

@end
