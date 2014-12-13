//
//  LineViewController.m
//  CharacterRecognitionSample
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import <UIKit/UIKit.h>
#import "LineViewController.h"
#import "LineCharacterRecognition.h"

@interface LineViewController ()

@end


@implementation LineViewController
{
NSArray * imageFile;
}

@synthesize imageFilePath;
@synthesize langSelect;
@synthesize result;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)doSelectImage:(id)sender {
    UIActionSheet *as = [[UIActionSheet alloc] init];
    as.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    as.delegate = self;
    as.title = @"画像選択";
    [as addButtonWithTitle: [imageFile objectAtIndex:0]];
    [as addButtonWithTitle: [imageFile objectAtIndex:1]];
    [as addButtonWithTitle: [imageFile objectAtIndex:2]];
    [as addButtonWithTitle: [imageFile objectAtIndex:3]];
    [as addButtonWithTitle: [imageFile objectAtIndex:4]];
    [as showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet*)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    imageFilePath.text = [imageFile objectAtIndex:buttonIndex];
    
    NSRange searchResult = [imageFilePath.text rangeOfString:@"jpn"];
    if(searchResult.location == NSNotFound){
        langSelect.selectedSegmentIndex=1;
    }
    else {
        langSelect.selectedSegmentIndex=0;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageFilePath.layer.borderWidth=1;
    imageFilePath.layer.borderColor=[[UIColor blackColor]CGColor];
    imageFilePath.layer.cornerRadius=2;
    imageFilePath.contentInset = UIEdgeInsetsMake(-6, 0, 0, 0);
    imageFilePath.returnKeyType = UIReturnKeyDone;
    imageFilePath.delegate = self;
    imageFilePath.text = @"line_jpn.png";
    
    imageFile = [NSArray arrayWithObjects:@"line_jpn.png", @"line_eng.png", @"line_jpn.jpg", @"line_eng.jpg", @"line_eng.gif", nil];

}

- (void) textViewDidChange: (UITextView*) textView {
    // 改行を入力したらソフトウェアキーボードを閉じる
    NSRange searchResult = [imageFilePath.text rangeOfString:@"\n"];
    if (searchResult.location != NSNotFound) {
        imageFilePath.text = [imageFilePath.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [imageFilePath resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doLineRecognition:(id)sender {
    // 行画像文字認識
    [self sendCharacterRecognitionRequest];
}

- (IBAction)line:(id)sender {
    
}


/**
 行画像文字認識要求送信
 */
-(void)sendCharacterRecognitionRequest
{
    CharacterRecognitionRequestParam * requestParam = [[CharacterRecognitionRequestParam alloc]init];
    switch( langSelect.selectedSegmentIndex ) {
        case 0 :
            requestParam.lang = @"jpn";
            break;
        default:
            requestParam.lang = @"eng";
            break;
    }
    requestParam.filePath = imageFilePath.text;
    requestParam.imageData = [UIImage imageNamed:requestParam.filePath];

    result.text = @"";

    // 認識結果取得処理クラスを作成
    LineCharacterRecognition * recognition = [[LineCharacterRecognition alloc]init];
    // 認識処理クラスにリクエストデータを渡し、レスポンスデータを取得する
    CharacterRecognitionError *err =
    [recognition recognize:requestParam
         onComplete:^(CharacterRecognitionResultData *resultData)
    {
        [self receiveCharacterRecognitionRequest:resultData];
    } onError:^(NSError *error) {
        [self myAlert:error];
    }];
    if(err){
        [self myAlert:err];
    }
    
}

/**
 情景画像文字認識要求レスポンス受信
 */
-(void)receiveCharacterRecognitionRequest:(CharacterRecognitionResultData *)resultData
{
    result.text = @"";
    
    NSString *text = @"";
    if ( resultData.message.sdkError ) {
        [self myAlert:resultData.message.sdkError];
        return;
    }
    if ( resultData.message.text ) {
        text = [NSString stringWithFormat:@"メッセージ=%@\n", resultData.message.text];
    }
    
    if ( resultData.job ) {
        text = [NSString stringWithFormat:@"%@ジョブID=%@\n", text, resultData.job.id];
        text = [NSString stringWithFormat:@"%@進行状況=%@\n", text, resultData.job.status];
        text = [NSString stringWithFormat:@"%@処理受付時刻=%@\n", text, resultData.job.queue_time];
    }

    if ([@"success" isEqualToString: resultData.job.status] ) {
        
        text = [NSMutableString stringWithFormat:@"%@抽出した全ての単語の情報の出力\n", text];
        text = [NSMutableString stringWithFormat:@"%@抽出した全ての単語の情報の数：%@\n", text, resultData.words.count];
        
        for (CharacterRecognitionWordData * word in resultData.words.word) {
            text = [NSMutableString stringWithFormat:@"%@　単語情報の出力：\n", text];
            text = [NSMutableString stringWithFormat:@"%@　　単語の文字列：%@\n", text, word.text];
            text = [NSMutableString stringWithFormat:@"%@　　単語のスコア：%@\n", text, word.score];
            text = [NSMutableString stringWithFormat:@"%@　　単語のカテゴリ：%@\n", text, word.category];
            text = [NSMutableString stringWithFormat:@"%@　　単語領域形状の出力：\n", text];
            text = [NSMutableString stringWithFormat:@"%@　　　頂点の数：%d\n", text, (int)word.shape.count];
            text = [NSMutableString stringWithFormat:@"%@　　　頂点情報の出力：\n", text];
            for (CharacterRecognitionPointData * point in word.shape.point) {
                text = [NSMutableString stringWithFormat:@"%@　　　x座標, y座標(ピクセル単位)：%d, %d\n", text, (int)point.x, (int)point.y];
            }
        }
    }
    if (nil != resultData.message) {
        text = [NSMutableString stringWithFormat:@"%@エラーメッセージ：%@\n", text, resultData.message.text];
    }
    result.text = text;
}

-(void)myAlert:(NSError *)error
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc]
             initWithTitle: error.domain
             message:[NSString stringWithFormat:@"ErrorCode:%d\nMessage:%@",
                      (int)error.code,
                      error.localizedDescription]
             delegate:nil
             cancelButtonTitle:nil
             otherButtonTitles:@"OK", nil
             ];
    [alert show];
    result.text = @"";
}
@end
