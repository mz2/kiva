//
//  KIWebController.m
//  kiva
//
//  Created by Matias Piipari on 26/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "KIWebController.h"


@implementation KIWebController
@synthesize webView = _webView;
@synthesize parentController;


-(void) awakeFromNib {
	
}


-(IBAction) dismiss:(id) sender {
	[[[self parentController] navigationController] dismissModalViewControllerAnimated: YES];
}

	
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Overriden to allow any orientation.
	return YES;
}

-(void) dealloc {
	[_webView release], _webView = nil;
	
	[super dealloc];
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

@end