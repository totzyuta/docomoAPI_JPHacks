//
//  GetResultViewController.m
//  CharacterRecognitionSample
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import "GetResultViewController.h"
#import "RecognitionViewController.h"
#import "AuthApiKey.h"
#import "SceneCharacterRecognition.h"
#import "CharacterRecognitionWordData.h"

@interface GetResultViewController ()
-(void)onError:(NSError *)error;
-(void)onComplete:(CharacterRecognitionResultData *)resultData;
@end

@implementation GetResultViewController

@synthesize jobid;
@synthesize result;

- (void)viewWillAppear:(BOOL)animated
{
    UITabBarController *controller = self.tabBarController;
    RecognitionViewController * resultVC = [controller.viewControllers objectAtIndex: 0];
    jobid.text = resultVC.jobidstr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    jobid.layer.borderWidth=1;
    jobid.layer.borderColor=[[UIColor blackColor]CGColor];
    jobid.layer.cornerRadius=2;
    jobid.contentInset = UIEdgeInsetsMake(-6, 0, 0, 0);
    jobid.returnKeyType = UIReturnKeyDone;
    jobid.delegate = self;
}

- (void) textViewDidChange: (UITextView*) textView {
    // 改行を入力したらソフトウェアキーボードを閉じる
    NSRange searchResult = [jobid.text rangeOfString:@"\n"];
    if (searchResult.location != NSNotFound) {
        jobid.text = [jobid.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [jobid resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doGetResult:(id)sender {
    // 情景画像文字認識結果取得
    [self sendCharacterRecognitionJobInfoRequest:jobid.text];
}

/**
 情景画像文字認識要求送信
 */
-(void)sendCharacterRecognitionJobInfoRequest:(NSString *)pjobid
{
    // 認識結果取得リクエストデータクラスを作成してジョブIDをセットする
    CharacterRecognitionJobInfoRequestParam * requestParam = [[CharacterRecognitionJobInfoRequestParam alloc] init];
    requestParam.jobid = pjobid;
    
    // 認識結果取得処理クラスを作成
    SceneCharacterRecognition * recognition = [[SceneCharacterRecognition alloc] init];
    result.text = @"";
    // 認識処理クラス　状態取得メソッドにリクエストデータ
    CharacterRecognitionError *err =
    [recognition getResult:requestParam
                onComplete:^(CharacterRecognitionResultData *resultData) {
                    [self onComplete:resultData];
                } onError:^(NSError *error) {
                    [self onError:error];
                }];
    if(err)
    {
        [self onError:err];
    }
}

-(void)onError:(NSError *)error
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc]
             initWithTitle:error.domain
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
/**
 情景画像文字認識要求受信
 */
-(void)onComplete:(CharacterRecognitionResultData *)resultData
{
    result.text = @"";
    NSString *text = @"";
    if ( resultData.message.sdkError ) {
        UIAlertView *alert;
        alert = [[UIAlertView alloc]
                 initWithTitle: resultData.message.sdkError.domain
                 message:[NSString stringWithFormat:@"ErrorCode:%d\nMessage:%@",
                          (int)resultData.message.sdkError.code,
                          resultData.message.sdkError.localizedDescription]
                 delegate:nil
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil
                 ];
        [alert show];
        result.text = @"";
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
    
    if ([@"queue" isEqualToString: resultData.job.status] ||
        [@"process" isEqualToString: resultData.job.status]) {
        // 処理が未完了のため文字認識処理が完了するのを1秒間待つ
        [NSThread sleepForTimeInterval:1.0];
        // 結果取得リクエストを再送する
        [self sendCharacterRecognitionJobInfoRequest:resultData.job.id];
        return;
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
    if ( ![resultData.message.text isEqual:[NSNull null]]) {
        text = [NSMutableString stringWithFormat:@"%@エラーメッセージ：%@\n", text, resultData.message.text];
    }
    result.text = text;
    
}

@end
