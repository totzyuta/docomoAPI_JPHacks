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
}

@synthesize imageFilePath;
@synthesize langSelect;
@synthesize result;
@synthesize jobidstr;

NSString * const APIKEY = @"4a55716339737974574b694f317665794f423133625273344f766b4f73516e71344f62755052794f436139";

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageFilePath.text = @"scene_jpn.png";

    // 開発者ポータルから取得したAPIキーの設定
    [AuthApiKey initializeAuth:APIKEY];
    
    imageFile = [NSArray arrayWithObjects:@"scene_jpn.png", @"scene_eng.png", @"scene_jpn.jpg", @"scene_eng.jpg", @"line_jpn.png", nil];
    jobidstr=@"";
  
  flag = 0;
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

/**
 情景画像文字認識要求送信
 */
// - (IBAction)buttonPushed:(id)sender {
-(void)sendCharacterRecognitionRequest:(UIImage *)image
{
  flag=1;
    // 認識要求処理リクエストデータクラスを作成してパラメータをセットする
    CharacterRecognitionRequestParam * requestParam = [[CharacterRecognitionRequestParam alloc] init];
    requestParam.lang = @"jpn";
    // requestParam.filePath = imageFilePath.text;
    // requestParam.imageData = [UIImage imageNamed:requestParam.filePath];
    requestParam.imageData = image;
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
  count = count + 1;
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
    NSMutableArray *wordsArray = [NSMutableArray array];
    wordsArray = [[NSMutableArray alloc] init];
    if ([@"success" isEqualToString: resultData.job.status] ) {
      text = [NSMutableString stringWithFormat:@"%@抽出した全ての単語の情報の出力\n", text];
      text = [NSMutableString stringWithFormat:@"%@抽出した全ての単語の情報の数：%@\n", text, resultData.words.count];
      for (CharacterRecognitionWordData * word in resultData.words.word) {
        text = [NSMutableString stringWithFormat:@"%@　単語情報の出力：\n", text];
        text = [NSMutableString stringWithFormat:@"%@　　単語の文字列：%@\n", text, word.text];
        // [wordsArray addObject:word.text];
        text = [NSMutableString stringWithFormat:@"%@　　単語のスコア：%@\n", text, word.score];
        text = [NSMutableString stringWithFormat:@"%@　　単語のカテゴリ：%@\n", text, word.category];
        text = [NSMutableString stringWithFormat:@"%@　　単語領域形状の出力：\n", text];
        text = [NSMutableString stringWithFormat:@"%@　　　頂点の数：%d\n", text, (int)word.shape.count];
        text = [NSMutableString stringWithFormat:@"%@　　　頂点情報の出力：\n", text];
        NSMutableArray *points = [NSMutableArray array];
        for (CharacterRecognitionPointData * point in word.shape.point) {
            text = [NSMutableString stringWithFormat:@"%@　　　x座標, y座標(ピクセル単位)：%d, %d\n", text, (int)point.x, (int)point.y];
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
    result.text = text;
    // NSLog([wordsArray[0] objectForKey:@"l1"]);
    NSLog(@"%@", wordsArray);
    flag = 0;
    return wordsArray;
  }
  
  return NULL;
 
}
@end
