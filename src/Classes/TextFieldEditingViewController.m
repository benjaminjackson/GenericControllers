#import "TextFieldEditingViewController.h"
#import "UIColor-Table.h"

@implementation TextFieldEditingViewController

@synthesize fieldNames;
@synthesize fieldKeys;
@synthesize fieldValues;
@synthesize delegate;
@synthesize changedValues;
@synthesize textFieldBeingEdited;
@synthesize shouldClearOnEditing;
@synthesize blockFirstFieldFocusOnViewDidAppear;
@synthesize finalReturnKeyType;

- (id)initWithStyle:(UITableViewStyle)style
{
	if (self = [super initWithStyle:style])
	{
		for (int i =0; i < MAX_ELEMENTS; i++) {
			keyboardTypes[i] = UIKeyboardTypeAlphabet;
			secureFields[i] = NO;
		}
	}
	return self;
}
-(IBAction)textFieldDone:(id)sender
{
	UITableViewCell *cell = (UITableViewCell *)[[(UIView *)sender superview] superview];
	UITableView *table = (UITableView *)[cell superview];
	NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
	NSUInteger row = [textFieldIndexPath row];
	row++;
	if (row >= [fieldNames count]) {
    [self save];
	}
		
	NSUInteger newIndex[] = {0, row};
	NSIndexPath *newPath = [NSIndexPath indexPathWithIndexes:newIndex length:2];
	UITableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:newPath];
	UITextField *nextField = nil;
	for (UIView *oneView in nextCell.contentView.subviews)
	{
		if ([oneView isMemberOfClass:[UITextField class]])
			nextField = (UITextField *)oneView;
	}
	[nextField becomeFirstResponder];
	
}
- (void)viewDidAppear:(BOOL)animated
{
	NSUInteger firstRowIndices[] = {0,0};
	NSIndexPath *firstRowPath = [NSIndexPath indexPathWithIndexes:firstRowIndices length:2];
	UITableViewCell *firstCell = [self.tableView cellForRowAtIndexPath:firstRowPath];
	UITextField *firstCellTextField = nil;
	for (UIView *oneView in firstCell.contentView.subviews)
	{
		if ([oneView isMemberOfClass:[UITextField class]])
			firstCellTextField = (UITextField *)oneView;
	}
	if (!blockFirstFieldFocusOnViewDidAppear) {
	  [firstCellTextField becomeFirstResponder];
	}
	[super viewDidAppear:animated];
}
-(IBAction)save
{
	if (textFieldBeingEdited != nil)
		[changedValues replaceObjectAtIndex:textFieldBeingEdited.tag withObject:textFieldBeingEdited.text];

  [self.delegate valuesDidChange:[self dictionaryForChangedValues]];
  [super save];
}

- (NSDictionary *)dictionaryForChangedValues
{
  return [NSMutableDictionary dictionaryWithObjects:changedValues forKeys:fieldKeys];
}

- (void)dismissKeyboard
{
  for( unsigned int i = 0; i < [fieldNames count]; i += 1 )
  {
    [[self textFieldAtRowIndex:i] resignFirstResponder];
  }
}

-(void)setKeyboardType:(UIKeyboardType)theType forIndex:(NSUInteger)index
{
  keyboardTypes[index] = theType;
}

-(void)setIsSecureField:(BOOL)isSecure forIndex:(NSUInteger)index
{
  secureFields[index] = isSecure;
}

#pragma mark -
- (void)setFieldNames:(NSArray *)theFieldNames
{
	[theFieldNames retain];
	[fieldNames release];
	fieldNames = theFieldNames;
}
- (void)setFieldValues:(NSArray *)theFieldValues
{
	[theFieldValues retain];
	[fieldValues release];
	fieldValues = theFieldValues;
	changedValues = [theFieldValues mutableCopy];
}
- (void)dealloc 
{
	[fieldNames release];
	[fieldKeys release];
	[fieldValues release];
	[changedValues release];
	[textFieldBeingEdited release];
  [super dealloc];
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [fieldNames count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *textFieldCellIdentifier = @"textFieldCellIdentifier";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:textFieldCellIdentifier] autorelease];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 25)];
    label.textAlignment = UITextAlignmentRight;
    label.tag = kDefaultLabelTag;
    UIFont *font = [UIFont boldSystemFontOfSize:12.0];
    label.textColor = [UIColor tableCellNonEditableTextColor];
    label.font = font;
    [cell.contentView addSubview:label];
    [label release];


    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 190, 25)];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;

    textField.clearsOnBeginEditing = shouldClearOnEditing;
    [textField setDelegate:self];
    [textField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [cell.contentView addSubview:textField];
  }
  UILabel *label = (UILabel *)[cell.contentView viewWithTag:kDefaultLabelTag];
	UITextField *textField = nil;
	for (UIView *oneView in cell.contentView.subviews)
	{
		if ([oneView isMemberOfClass:[UITextField class]])
			textField = (UITextField *)oneView;
	}
	
	label.text = [fieldNames objectAtIndex:[indexPath row]];

  if ([[changedValues objectAtIndex:[indexPath row]] isKindOfClass:[NSString class]]) {
  	textField.text = [changedValues objectAtIndex:[indexPath row]];
  } else {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  	[formatter setDateFormat:@"MMMM dd, yyyy"];
    textField.text = [formatter stringFromDate:[changedValues objectAtIndex:[indexPath row]]];
    [formatter release];
  }
	textField.tag = [indexPath row];
  if ([indexPath row] == [fieldKeys count] - 1) {
    if (finalReturnKeyType != nil) {
      textField.returnKeyType = finalReturnKeyType;
    } else {
      textField.returnKeyType = UIReturnKeyDone;
    }
	} else {
    textField.returnKeyType = UIReturnKeyNext;
	}
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	textField.keyboardType = keyboardTypes[[indexPath row]];
  textField.secureTextEntry = secureFields[[indexPath row]];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITextField *)textFieldAtRowIndex:(int)rowIndex
{
  NSIndexPath *rowPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
  
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:rowPath];
	UITextField *cellTextField = nil;
	for (UIView *oneView in cell.contentView.subviews)
	{
		if ([oneView isMemberOfClass:[UITextField class]])
			cell = (UITextField *)oneView;
	}
  return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView 
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	// prevents the rows from being selected.
	return nil;
}
#pragma mark -
#pragma mark Text Field Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	self.textFieldBeingEdited = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
  NSString *value = textField.text;
  if (value == nil) {
    value = @"";
  }
	[changedValues replaceObjectAtIndex:textField.tag withObject:value];
}

@end