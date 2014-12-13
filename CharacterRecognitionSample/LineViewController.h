//
//  LineViewController.h
//  CharacterRecognitionSample
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import <UIKit/UIKit.h>

@interface LineViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextView *imageFilePath;
@property (weak, nonatomic) IBOutlet UISegmentedControl *langSelect;
@property (weak, nonatomic) IBOutlet UITextView *result;

@end
