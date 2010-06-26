//
//  AppDelegate_Pad.m
//  kiva
//
//  Created by Matias Piipari on 24/06/2010.
//  Copyright Wellcome Trust Sanger Institute 2010. All rights reserved.
//

#import "KIAppDelegate_Pad.h"


@implementation KIAppDelegate_Pad
@synthesize window;
@synthesize navigationController = _navigationController;

-(void) awakeFromNib {
	[window addSubview: self.navigationController.view]; 
	[window makeKeyAndVisible];	 
}

- (BOOL)application:(UIApplication *)application 
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch
	
	return YES;
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

- (void)dealloc {
    [window release];
    [super dealloc];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return YES;
}

@end
