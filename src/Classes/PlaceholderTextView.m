#import "PlaceholderTextView.h"

@implementation PlaceholderTextView

@synthesize placeholder, placeholderColor;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setPlaceholder:@""];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
  }
  return self;
}

- (void)textChanged:(NSNotification *)notification {
  if ([[self placeholder] length] == 0)
    return;
  if ([[self text] length] == 0) {
    [[self viewWithTag:999] setAlpha:1];
  } else {
    [[self viewWithTag:999] setAlpha:0];
  }

}

- (void)drawRect:(CGRect)rect {
  if ([[self placeholder] length] > 0) {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.bounds.size.width - 16, self.bounds.size.height)];
    [self addSubview:label];
    [label release];

    [label setFont:self.font];
    [label setTextColor:self.placeholderColor];
    [label setText:self.placeholder];
    [label setAlpha:0];
    [label setTag:999];
    [label setNumberOfLines:100];
    [label setLineBreakMode:UILineBreakModeWordWrap];
    [self sendSubviewToBack:label];
    
    CGSize labelSize = [label.text sizeWithFont:label.font 
  	  constrainedToSize:label.frame.size lineBreakMode:label.lineBreakMode];
    CGRect frame = label.frame;
    frame.size.height = labelSize.height;
    label.frame = frame;
  }
  if ([[self text] length] == 0 && [[self placeholder] length] > 0) {
    [[self viewWithTag:999] setAlpha:1];
  }
  [super drawRect:rect];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super dealloc];
}


@end
