//
//  AbstractGenericViewController.m
//  iContractor
//
//  Created by Jeff LaMarche on 2/18/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

#import "AbstractGenericViewController.h"


@implementation AbstractGenericViewController

@synthesize saveButtonTitle, blockHideWhenFinished, hideSaveButton;

- (void)viewWillAppear:(BOOL)animated 
{
  if (saveButtonTitle == nil) {
    saveButtonTitle = NSLocalizedString(@"Save", @"Save - for button to save changes");
  }
  if (!self.hideSaveButton) {
  	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
  									 initWithTitle:NSLocalizedString(@"Cancel", @"Cancel - for button to cancel changes")
  									 style:UIBarButtonItemStylePlain
  									 target:self
  									 action:@selector(cancel)];
  	self.navigationItem.leftBarButtonItem = cancelButton;
  	[cancelButton release];
  	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
  								   initWithTitle:saveButtonTitle
  								   style:UIBarButtonItemStylePlain
  								   target:self
  								   action:@selector(save)];
  	self.navigationItem.rightBarButtonItem = saveButton;
  	[saveButton release];
	}
	[super viewWillAppear:animated];
}
-(IBAction)cancel
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save
{
  if (!self.blockHideWhenFinished) {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (void)dealloc
{
  [saveButtonTitle release];
  [super dealloc];
}
@end
