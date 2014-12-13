//
//  DeleteViewController.h
//  CharacterRecognitionSample
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import <UIKit/UIKit.h>

@interface DeleteViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *jobid;
@property (weak, nonatomic) IBOutlet UITextView *result;

@end
