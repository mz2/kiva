//
//  AppDelegate_Pad.h
//  kiva
//
//  Created by Matias Piipari on 24/06/2010.
//  Copyright Wellcome Trust Sanger Institute 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface KIAppDelegate_Pad : NSObject <UIApplicationDelegate,MKMapViewDelegate> {
    UIWindow *window;
	
	MKMapView *_mapView;
	
	@protected
	NSMutableSet *_loans;
}

@property (nonatomic, retain) NSMutableSet *loans;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@end

