//
//  AppDelegate_Pad.h
//  kiva
//
//  Created by Matias Piipari on 24/06/2010.
//  Copyright Wellcome Trust Sanger Institute 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KIAppDelegate_Pad : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	
	
	UINavigationController *_navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

