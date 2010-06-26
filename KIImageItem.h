//
//  KIImageItem.h
//  kiva
//
//  Created by Matias Piipari on 24/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIMediaItem.h"

@interface KIImageItem : KIMediaItem {

}

-(UIImage*) imageForSize:(KIMediaItemSize) size;

@end
