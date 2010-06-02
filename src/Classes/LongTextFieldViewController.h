//
//  LongTextFieldViewController.h
//  iContractor
//
//  Created by Jeff LaMarche on 2/10/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractGenericViewController.h"
#import "PlaceholderTextView.h"

@protocol LongTextFieldEditingViewControllerDelegate <NSObject>
@required
- (void)takeNewString:(NSString *)newValue;
@end

@interface LongTextFieldViewController : AbstractGenericViewController 
{
	NSString	*string;
	NSString	*placeholder;
	PlaceholderTextView	*textView;
	
	id<LongTextFieldEditingViewControllerDelegate>	delegate;
}
@property (nonatomic, retain) NSString *string;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, assign)  id <LongTextFieldEditingViewControllerDelegate> delegate;
- (void)save;
@end
