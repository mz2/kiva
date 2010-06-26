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
#import "KIMapPopContentController.h"

@implementation KIAppDelegate_Pad

@synthesize window;
@synthesize mapView = _mapView;
@synthesize loans = _loans;
@synthesize popOverController = _popOverController;
@synthesize popContentController = _popContentController;

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
	[[KIDataSource sharedDataSource] requestPartners];
	
	_loans = [[NSMutableSet alloc] init];
	
	PCLog(@"popover content controller: %@", self.popContentController);
	return YES;
}

-(void) awakeFromNib {
	PCLog(@"Awakening from NIB");
	self.popOverController = [[UIPopoverController alloc] initWithContentViewController:self.popContentController];
	self.popOverController.popoverContentSize = CGSizeMake(305, 235);
	self.popOverController.delegate = self;
	
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
			if (![[loan imageItem] contentIsAvailableForSize: KIMediaItemSizeResizedToMinDim50Bordered]) {
				PCLog(@"Requesting image content for size 80x80");
				view.image = [UIImage imageNamed:@"loan.png"];
				[[KIDataSource sharedDataSource] requestContentForMediaItem: [loan imageItem] size: KIMediaItemSizeW80H80];
			} else {
				view.image = [[loan imageItem] imageForSize: KIMediaItemSizeResizedToMinDim50Bordered];
				UIButton *profileButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)] autorelease];
				[profileButton setImage:
				 [UIImage imageWithContentsOfFile: [[loan imageItem] pathForSize:KIMediaItemSizeResizedToW32H32]] 
										 forState: UIControlStateNormal];
				[profileButton addTarget: self 
								action: @selector(doNothing:) 
					  forControlEvents: UIControlEventTouchUpInside];
				profileButton.tag = 1;
				view.leftCalloutAccessoryView = profileButton;
			}
			view.canShowCallout = NO;
		}

	} else {
		@throw [NSException exceptionWithName:@"KIUnexpectedAnnotationTypeException" 
									   reason:@"This should not have happened" 
									 userInfo:nil];
	}
	
	return view;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aview {
	PCLog(@"Did select annotation view");
	CGPoint leftTopPoint = [mapView convertCoordinate:aview.annotation.coordinate 
										toPointToView:mapView];
	
	CGFloat boxDY=leftTopPoint.y;
	CGFloat boxDX=leftTopPoint.x;
	NSLog(@"\nDX:%.1f,DY:%.1f\n",boxDX,boxDY);
	
	CGRect rect = CGRectMake(boxDX, boxDY, 2.0, 2.0);
	
	self.popContentController.loan = (KILoan*) aview.annotation;
	[self.popOverController presentPopoverFromRect: rect 
											inView: self.mapView 
						  permittedArrowDirections: UIPopoverArrowDirectionAny
										  animated: YES];
	
}

/*
- (void)mapView:(MKMapView *)mapView 
 annotationView:(MKAnnotationView *)aview 
calloutAccessoryControlTapped:(UIControl *)control{
	PCLog(@"Map view %@ annotation view %@ callout accessory tapped %@", mapView, aview, control);
	CGPoint leftTopPoint = [mapView convertCoordinate:aview.annotation.coordinate 
										 toPointToView:mapView];

	CGFloat boxDY=leftTopPoint.y;
	CGFloat boxDX=leftTopPoint.x;
	NSLog(@"\nDX:%.1f,DY:%.1f\n",boxDX,boxDY);
	
	CGRect rect = CGRectMake(boxDX-20.0, boxDY - 270.0 / 2.0, 260.0f, 270.0f);
	
	[self.popOverController presentPopoverFromRect: rect 
											inView: self.mapView 
						  permittedArrowDirections: UIPopoverArrowDirectionRight 
										  animated: YES];
	
	
}*/

 -(void) doNothing:(id) sender {
	 
	 
 }
				 
-(IBAction) refresh:(id) sender {
	[[KIDataSource sharedDataSource] requestNewLoansOnPage:1];
}

- (void)dealloc {
    [window release];
    [super dealloc];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return YES;
}

@end
