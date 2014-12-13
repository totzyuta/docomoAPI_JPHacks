//
//  RecognitionViewController.m
//  CharacterRecognitionSample
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import "RecognitionViewController.h"
#import "AuthApiKey.h"
#import "SceneCharacterRecognition.h"
#import "CharacterRecognitionWordData.h"
#import "CharacterRecognitionMessageData.h"

@interface RecognitionViewController ()
-(void)onError:(NSError *)error;
@end

@implementation RecognitionViewController
{
  NSArray * imageFile;
  int flag;
  NSInteger * count;
  NSMutableArray *wordsArray; // ここにデータが格納される
}

@synthesize imageFilePath;
@synthesize langSelect;
@synthesize result;
@synthesize jobidstr;

NSString * const APIKEY = @"4a55716339737974574b694f317665794f423133625273344f766b4f73516e71344f62755052794f436139";

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 開発者ポータルから取得したAPIキーの設定
    [AuthApiKey initializeAuth:APIKEY];
    // Initialize
    jobidstr=@"";
    flag = 0;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buttonPushed:(id)sender {
  NSLog(@"%@", wordsArray);
}



/**
 情景画像文字認識要求送信（こいつがおおもとのメソッド）
 */
// - (IBAction)buttonPushed:(id)sender {
- (IBAction)doRecognition:(id)sender {
// -(void)sendCharacterRecognitionRequest:(UIImage *)image
// -(void)sendCharacterRecognitionRequest
// {
  flag=1;
    // 認識要求処理リクエストデータクラスを作成してパラメータをセットする
    CharacterRecognitionRequestParam * requestParam = [[CharacterRecognitionRequestParam alloc] init];
    requestParam.lang = @"jpn";
    // requestParam.imageData = image;
    imageFilePath.text = @"scene_jpn.jpg";
    requestParam.filePath = imageFilePath.text;
    requestParam.imageData = [UIImage imageNamed:requestParam.filePath];
    result.text = @"";
    // 認識要求処理クラスを作成
    SceneCharacterRecognition * recognition = [[SceneCharacterRecognition alloc] init];
    recognition.timeoutInterval=300.0;
    
    // 認識処理クラスにリクエストデータを渡し、レスポンスデータを取得する
    CharacterRecognitionError *err =
    [recognition recognize:requestParam
     onComplete:^(CharacterRecognitionStatusData *statusData) {
         [self onComplete:statusData];
     } onError:^(SdkError *error) {
         [self onError:error];
     }];
    if(err){
        [self onError:err];
    }
}

/**
 エラーダイアログ表示
 
 @param error エラー情報
 */
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
 情景画像文字認識要求送信/情景画像文字認識要求レスポンス受信
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

/**
 情景画像文字認識要求受信
 */
-(NSMutableArray *)onComplete:(CharacterRecognitionResultData *)resultData
{
  if (flag==1) {
  CharacterRecognitionStatusData *statusData = resultData;
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
        return NULL;
        
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
    if (statusData.job.id && ![statusData.job.id isEqual:[NSNull null]]){
            jobidstr = statusData.job.id;
    }
    NSLog(@"jobidstr:%@",jobidstr);
    [self sendCharacterRecognitionJobInfoRequest:(NSString *)jobidstr];
    flag = 2;
  }else if(flag==2){
  
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
        return NULL;
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
        return NULL;
    }
    // NSMutableArray *wordsArray = [NSMutableArray array];
    wordsArray = [[NSMutableArray alloc] init];
    if ([@"success" isEqualToString: resultData.job.status] ) {
      for (CharacterRecognitionWordData * word in resultData.words.word) {
        NSMutableArray *points = [NSMutableArray array];
        for (CharacterRecognitionPointData * point in word.shape.point) {
          NSNumber *pointx = [NSNumber numberWithInt:(int)point.x];
          NSNumber *pointy = [NSNumber numberWithInt:(int)point.y];
          [points addObject:pointx];
          [points addObject:pointy];
        }
        NSDictionary *wordData = [NSDictionary dictionaryWithObjectsAndKeys:
                                    word.text, @"word",
                                    points[0], @"x1",
                                    points[1], @"y1",
                                    points[2], @"x2",
                                    points[3], @"y2",
                                    points[4], @"x3",
                                    points[5], @"y3",
                                    points[6], @"x4",
                                    points[7], @"y4", nil];
        [wordsArray addObject:wordData];
      }
    }
    if ( ![resultData.message.text isEqual:[NSNull null]]) {
        text = [NSMutableString stringWithFormat:@"%@エラーメッセージ：%@\n", text, resultData.message.text];
    }
    NSLog(@"%@", wordsArray);
    flag = 0;
    return wordsArray;
  }
  
  return NULL;
 
}
@end
