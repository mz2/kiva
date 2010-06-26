//
//  AppDelegate_Pad.m
//  kiva
//
//  Created by Matias Piipari on 24/06/2010.
//  Copyright Wellcome Trust Sanger Institute 2010. All rights reserved.
//

#import "KIAppDelegate_Pad.h"
#import "KIDataSource.h"
#import "KILoansResponse.h"
#import "KILoan.h"
#import "KIImageItem.h"

@implementation KIAppDelegate_Pad

@synthesize window;
@synthesize mapView = _mapView;
@synthesize loans = _loans;

- (BOOL)application:(UIApplication *)application 
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch
	
    [window makeKeyAndVisible];
	
	[[NSNotificationCenter defaultCenter] addObserver: self 
											 selector: @selector(newLoansReceived:) 
												 name: kKILoansRequestFinishedNotification 
											   object: nil];
	
	[[NSNotificationCenter defaultCenter] addObserver: self 
											 selector: @selector(mediaItemContentReceived:) 
												 name: kKIMediaItemContentReceivedNotification 
											   object: nil];
	
	[[KIDataSource sharedDataSource] requestNewLoansOnPage:1];
	
	_loans = [[NSMutableSet alloc] init];
	return YES;
}

-(void) newLoansReceived:(NSNotification*) notification {
	PCLog(@"Notification: %@", notification);
	
	KILoansResponse *response = (KILoansResponse*)notification.object;
	
	for (KILoan *loan in response.loans) {
		if (![self.loans containsObject: loan]) {
			[self.mapView addAnnotation: loan];
		}
	}
}

-(void) mediaItemContentReceived:(NSNotification*) notification {
	KIMediaItem *item = notification.object;
	PCLog(@"Content received for media item %d (%@)", item.identifier, item);
	KILoan *loan = item.referringObject;
	if (loan == nil) return;
	
	PCLog(@"Media item %@ links to loan %@", item, loan);
	if ([self.mapView.annotations containsObject: loan]) {
		[self.mapView removeAnnotation: loan];
	}
	
	[self.mapView addAnnotation: loan];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView 
			viewForAnnotation:(id <MKAnnotation>)annotation {
	static NSString *kLoanAnnotation = @"KILoanAnnotation";
	
	MKAnnotationView *view = nil;
	if ([annotation isKindOfClass: [KILoan class]]) {
		view = [mapView dequeueReusableAnnotationViewWithIdentifier: kLoanAnnotation];
		if (view == nil) {
			view = [[MKAnnotationView alloc] initWithAnnotation: annotation 
												reuseIdentifier: kLoanAnnotation];
			KILoan *loan = (KILoan*) annotation;
			//PCLog(@"Image item for loan: %@", [loan imageItem]);
			if (![[loan imageItem] contentIsAvailableForSize: KIMediaItemSizeResizedToMinDim42Bordered]) {
				PCLog(@"Requesting image content for size 80x80");
				view.image = [UIImage imageNamed:@"loan.png"];
				[[KIDataSource sharedDataSource] requestContentForMediaItem: [loan imageItem] size: KIMediaItemSizeW80H80];
			} else {
				view.image = [[loan imageItem] imageForSize: KIMediaItemSizeResizedToMinDim42Bordered];
			}
			view.canShowCallout = YES;
		}

	} else {
		@throw [NSException exceptionWithName:@"KIUnexpectedAnnotationTypeException" 
									   reason:@"This should not have happened" 
									 userInfo:nil];
	}
	
	return view;
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
