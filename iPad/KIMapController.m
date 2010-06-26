    //
//  KIMapController.m
//  kiva
//
//  Created by Matias Piipari on 26/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "KIMapController.h"
#import "KIDataSource.h"
#import "KILoansResponse.h"
#import "KILoan.h"
#import "KIImageItem.h"
#import "KIMapPopContentController.h"
#import "KIWebController.h"

@implementation KIMapController
@synthesize mapView = _mapView;
@synthesize loans = _loans;
@synthesize popOverController = _popOverController;
@synthesize popContentController = _popContentController;
@synthesize webController = _webController;

-(void) awakeFromNib {
	PCLog(@"Awakening from NIB");
	self.popOverController = [[UIPopoverController alloc] initWithContentViewController:self.popContentController];
	self.popOverController.popoverContentSize = CGSizeMake(305, 285);
	self.popOverController.delegate = self;
	
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

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


-(void) showURL:(NSURL*) url {
	NSURLRequest *requestObj = [NSURLRequest requestWithURL: url];
	
	
	[self.navigationController presentModalViewController: self.webController animated: YES];
	[self.webController.webView loadRequest: requestObj];
}

-(void) doNothing:(id) sender {
	
	
}

-(IBAction) refresh:(id) sender {
	[[KIDataSource sharedDataSource] requestNewLoansOnPage:1];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return YES;
}

@end
