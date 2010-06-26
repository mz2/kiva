//
//  AppDelegate_Pad.h
//  kiva
//
//  Created by Matias Piipari on 24/06/2010.
//  Copyright Wellcome Trust Sanger Institute 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class KIMapPopContentController;

@interface KIAppDelegate_Pad : NSObject <UIApplicationDelegate,MKMapViewDelegate,UIPopoverControllerDelegate> {
    UIWindow *window;
	
	MKMapView *_mapView;
	
	UIPopoverController *_popOverController;
	KIMapPopContentController *_popContentController;
	
	
	@protected
	NSMutableSet *_loans;
}

@property (nonatomic, retain) NSMutableSet *loans;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@property (nonatomic, retain) UIPopoverController *popOverController;
@property (nonatomic, retain) IBOutlet KIMapPopContentController *popContentController;

-(IBAction) refresh:(id) sender;

@end

