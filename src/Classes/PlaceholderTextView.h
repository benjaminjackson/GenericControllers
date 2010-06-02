// Taken from http://stackoverflow.com/questions/1328638/placeholder-in-uitextview

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView <UITextViewDelegate> {
  NSString *placeholder;
  UIColor *placeholderColor;
}

@property(nonatomic, retain) NSString *placeholder;
@property(nonatomic, retain) UIColor *placeholderColor;

- (void)textChanged:(NSNotification*)notification;

@end
