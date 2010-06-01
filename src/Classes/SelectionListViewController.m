//
//  SelectionListViewController.m
//  iContractor
//
//  Created by Jeff LaMarche on 2/18/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

#import "SelectionListViewController.h"


@implementation SelectionListViewController
@synthesize list;
@synthesize lastIndexPath;
@synthesize initialSelection;
@synthesize delegate;
-(IBAction)save
{
  if (lastIndexPath == nil) {
    [self cancel];
    return;
  }
  [self.delegate rowChosen:[lastIndexPath row] fromArray:list];
  [super save];
}
#pragma mark -
- (id)initWithStyle:(UITableViewStyle)style
{
	initialSelection = -1;
	return self;
}
- (void)viewWillAppear:(BOOL)animated 
{
	// Check to see if user has indicated a row to be selected, and set it
	if (initialSelection > - 1 && initialSelection < [list count])
	{
		NSUInteger newIndex[] = {0, initialSelection};
		NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
		self.lastIndexPath = newPath;
		[newPath release];
	}
	
    [super viewWillAppear:animated];
}
- (void)dealloc 
{
	[list release];
	[lastIndexPath release];
    [super dealloc];
}
#pragma mark -
#pragma mark Tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [list count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *SelectionListCellIdentifier = @"SelectionListCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectionListCellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:SelectionListCellIdentifier] autorelease];
    }
    
	NSUInteger row = [indexPath row];
	NSUInteger oldRow = [lastIndexPath row];
	cell.text = [list objectAtIndex:row];
	cell.accessoryType = (row == oldRow && lastIndexPath != nil) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int newRow = [indexPath row];
	int oldRow = [lastIndexPath row];
	if (newRow != oldRow || lastIndexPath == nil)
	{
	  if (!self.hideSaveButton) {
	    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
  		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		
  		UITableViewCell *oldCell = [tableView cellForRowAtIndexPath: lastIndexPath]; 
  		oldCell.accessoryType = UITableViewCellAccessoryNone;
	  }
		
		self.lastIndexPath = indexPath;
	}
	if (self.hideSaveButton) {
    [self save];
	} else {
	  [tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}
- (void)rowChosen:(NSInteger)row fromArray:(NSArray *)theList
{

}
@end

