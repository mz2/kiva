//
//  KIMapPopContentController.h
//  kiva
//
//  Created by Matias Piipari on 26/06/2010.
//  Copyright 2010 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KILoan;

@interface KIMapPopContentController : UIViewController {
	UILabel *_nameLabel;
	UILabel *_locationLabel;
	UIImageView *_image;
	UILabel *_loanAmountProgressLabel;
	UIProgressView *_loanProgressIndicator;
	UILabel *_activityLabel;
	UITextView *_loanUseTextView;
	
	
	KILoan *_loan;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UIImageView *image;
@property (nonatomic, retain) IBOutlet UILabel *loanAmountProgressLabel;
@property (nonatomic, retain) IBOutlet UIProgressView *loanProgressIndicator;
@property (nonatomic, retain) IBOutlet UILabel *activityLabel;
@property (nonatomic, retain) IBOutlet UITextView *loanUseTextView;

@property (nonatomic, retain) KILoan *loan;

@end
