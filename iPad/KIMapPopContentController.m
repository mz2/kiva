    //
//  KIMapPopContentController.m
//  kiva
//
//  Created by Matias Piipari on 26/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import "KIMapPopContentController.h"
#import "KILoan.h"
#import "KIImageItem.h"
#import "KIAppDelegate_Pad.h"
#import "KIMapController.h"

@implementation KIMapPopContentController
@synthesize nameLabel = _nameLabel;
@synthesize locationLabel = _locationLabel;
@synthesize image = _image;
@synthesize loanAmountProgressLabel = _loanAmountProgressLabel;
@synthesize loanProgressIndicator = _loanProgressIndicator;
@synthesize activityLabel = _activityLabel;
@synthesize loanUseTextView = _loanUseTextView;
@synthesize parentController = _parentController;

@synthesize loan = _loan;

-(void) awakeFromNib {
	
	[[NSNotificationCenter defaultCenter] addObserver: self 
											 selector: @selector(contentReceived:) 
												 name: kKIMediaItemContentReceivedNotification 
											   object: nil];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

-(void) contentReceived:(NSNotification*) notification {
	KIMediaItem *item = notification.object;
	PCLog(@"Content received for media item %d (%@)", item.identifier, item);
	KILoan *loan = item.referringObject;
	if (loan == nil) return;
	
	if ([loan isEqual: self.loan] && [self.loan.imageItem contentIsAvailableForSize: KIMediaItemSizeW80H80]) {
		self.image.image = [loan.imageItem imageForSize: KIMediaItemSizeW80H80];
	}
}

-(void) setLoan:(KILoan*) loan {
	[self willChangeValueForKey:@"loan"];
	[loan retain];
	[_loan release];
	_loan = loan;
	
	if ([loan.imageItem contentIsAvailableForSize: KIMediaItemSizeW80H80]) {
		self.image.image = [loan.imageItem imageForSize: KIMediaItemSizeW80H80];
	} else {
		self.image.image = [UIImage imageNamed:@"loan.png"];
	}
	
	self.nameLabel.text = loan.name;
	
	NSString *townCountryStr = nil;
	if (self.loan.town != nil) {
		townCountryStr = [NSString stringWithFormat:@"%@, %@",loan.town,loan.country]; 
	} else {
		townCountryStr = [loan.country copy];
	}
	
	self.locationLabel.text = [NSString stringWithFormat:@"%@ (%@)",
							   townCountryStr,loan.formattedPostedDate];
	self.loanAmountProgressLabel.text = [NSString stringWithFormat:@"$%.1f of $%.1f funded", 
										 self.loan.fundedAmount, self.loan.loanAmount];
	self.loanProgressIndicator.progress = self.loan.fundedAmount / self.loan.loanAmount;
	
	self.activityLabel.text = [NSString stringWithFormat:@"%@ (%@)", self.loan.activity, self.loan.sector];
	self.loanUseTextView.text = self.loan.use;
	
	[self didChangeValueForKey:@"loan"];
}

-(IBAction) showMoreInfoAboutPartner:(id) sender {
	
	[[(KIMapController*)[self parentController] popOverController] dismissPopoverAnimated: YES];
	[(KIMapController*)[self parentController] showURL: [NSURL URLWithString:
														  [NSString stringWithFormat:
														   @"http://www.kiva.org/lend/%d",self.loan.identifier]]];
}

-(IBAction) showMoreInfoAboutLoan:(id) sender {
	[[(KIMapController*)[self parentController] popOverController] dismissPopoverAnimated: YES];
	[(KIMapController*)[self parentController] showURL: [NSURL URLWithString:
														 [NSString stringWithFormat:
														  @"http://www.kiva.org/lend/%d",self.loan.identifier]]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
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


- (void)dealloc
{
	[_nameLabel release];
	_nameLabel = nil;
	[_locationLabel release];
	_locationLabel = nil;
	[_image release];
	_image = nil;
	[_loanAmountProgressLabel release];
	_loanAmountProgressLabel = nil;
	[_loanProgressIndicator release];
	_loanProgressIndicator = nil;
	[_activityLabel release];
	_activityLabel = nil;
	[_loanUseTextView release];
	_loanUseTextView = nil;
	[_loan release];
	_loan = nil;
	
	[super dealloc];
}

@end
