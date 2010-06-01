//
//  AbstractGenericViewController.h
//  iContractor
//
//  Created by Jeff LaMarche on 2/18/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AbstractGenericViewController : UITableViewController 
{
  NSString *saveButtonTitle;
  BOOL blockHideWhenFinished;
  BOOL hideSaveButton;
}
@property (retain) NSString *saveButtonTitle;
@property (nonatomic) BOOL blockHideWhenFinished;
@property (nonatomic) BOOL hideSaveButton;
-(IBAction)cancel;
@end
