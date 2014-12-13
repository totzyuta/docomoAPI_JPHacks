//
//  DeleteViewController.m
//  CharacterRecognitionSample
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import "DeleteViewController.h"
#import "RecognitionViewController.h"
#import "AuthApiKey.h"
#import "SceneCharacterRecognition.h"
#import "CharacterRecognitionWordData.h"

@interface DeleteViewController ()

@end

@implementation DeleteViewController

@synthesize jobid;
@synthesize result;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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

- (IBAction)doDelete:(id)sender {
    // 取消リクエスト
    [self sendCharacterRecognitionDeleteRequest:jobid.text];
}

/**
 情景画像文字認識取消送信
 */
-(void)sendCharacterRecognitionDeleteRequest:(NSString *)pjobid
{
    // 認識結果取得リクエストデータクラスを作成してジョブIDをセットする
    CharacterRecognitionJobInfoRequestParam * requestParam = [[CharacterRecognitionJobInfoRequestParam alloc] init];
    requestParam.jobid = pjobid;
    
    // 認識結果取得処理クラスを作成
    SceneCharacterRecognition * recognition = [[SceneCharacterRecognition alloc] init];
    result.text = @"";
    // 認識処理クラス　状態取得メソッドにリクエストデータ

    CharacterRecognitionError *err =
    [recognition delete:requestParam
      onComplete:^(CharacterRecognitionStatusData *statusData)
    {
        [self receiveCharacterRecognitionDeleteResult:statusData];
    }onError:^(NSError *error) {
        [self myAlert:error];
    }];
    if (err) {
        [self myAlert:err];
    }
}

-(void)myAlert:(NSError *)error
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
 情景画像文字認識取消受信
 */
-(void)receiveCharacterRecognitionDeleteResult:(CharacterRecognitionStatusData *)statusData
{
    result.text = @"";
    
    NSString *text = @"";
    if ( statusData.message.sdkError ) {
        text = [NSString stringWithFormat:@"エラーコード=%d %@\n",
                (int)statusData.message.sdkError.code,
                statusData.message.sdkError.localizedDescription];
        UIAlertView *alert;
        alert = [[UIAlertView alloc]
                 initWithTitle: statusData.message.sdkError.domain
                 message:[NSString stringWithFormat:@"ErrorCode:%d\nMessage:%@",
                          (int)statusData.message.sdkError.code,
                          statusData.message.sdkError.localizedDescription]
                 delegate:nil
                 cancelButtonTitle:nil
                 otherButtonTitles:@"OK", nil
                 ];
        [alert show];
        result.text = text;
        return;
        
    }
    if ( statusData.message.text ) {
        text = [NSString stringWithFormat:@"メッセージ=%@\n", statusData.message.text];
    }
    
    if ( statusData.job ) {
        text = [NSString stringWithFormat:@"%@ジョブID=%@\n", text, statusData.job.id];
        text = [NSString stringWithFormat:@"%@進行状況=%@\n", text, statusData.job.status];
        text = [NSString stringWithFormat:@"%@処理受付時刻=%@\n", text, statusData.job.queue_time];
    }
    result.text = text;
}

@end
