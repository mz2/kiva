//
//  KIMapController.h
//  kiva
//
//  Created by Matias Piipari on 26/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class KIMapPopContentController;
@class KIWebController;

@interface KIMapController : UIViewController <MKMapViewDelegate,UIPopoverControllerDelegate, UIWebViewDelegate> {
	MKMapView *_mapView;
	
	UIPopoverController *_popOverController;
	KIMapPopContentController *_popContentController;
	
	KIWebController *webController;
	
@protected
	NSMutableSet *_loans;
}

@property (nonatomic, retain) NSMutableSet *loans;

@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@property (nonatomic, retain) UIPopoverController *popOverController;
@property (nonatomic, retain) IBOutlet KIMapPopContentController *popContentController;

@property (nonatomic, retain) IBOutlet KIWebController *webController;

-(IBAction) refresh:(id) sender;
-(void) showURL:(NSURL*) url;

@end
