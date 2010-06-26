//
//  KIWebController.h
//  kiva
//
//  Created by Matias Piipari on 26/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KIWebController : UIViewController {
	UIWebView *_webView;
	
	id _parentController;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, assign) IBOutlet id parentController;

-(IBAction) dismiss:(id) sender;

@end
