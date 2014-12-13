//
//  SceneCharacterRecognition.h
//  docomo-characterrecognition-ios-sdk
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import "CharacterRecognitionStatusData.h"
#import "CharacterRecognitionRequestParam.h"
#import "CharacterRecognitionJobInfoRequestParam.h"
#import "CharacterRecognitionResultData.h"
#import "CharacterRecognitionError.h"
#import "SdkError.h"

/**
 文字認識SDK： 情景画像認識クラス
 
 */
@interface SceneCharacterRecognition : NSObject

@property  NSTimeInterval timeoutInterval;


/**
 初期化
 
 
 */
-(id)init;

/**
 情景画像からの文字認識を要求する。
 
 
 情景画像文字認識要求リクエストを送信する。
 
 レスポンスの受信が完了した時に、正常に受信した場合は認識結果データを引数で受け取る処理を応答受信完了時処理ハンドラ（onComplete）に、
 エラー応答の場合はエラー情報を引数で受け取る処理を応答受信エラー時処理ハンドラ（onError）に登録する。
 
 @return 文字認識SDKエラー情報(パラメータエラーの場合CharacterRecognitionErrorParamを、リクエストを送信した場合はnilを返す)
 @see CharacterRecognitionError
 
 @param requestParam 情景画像からの文字認識依頼のデータパラメータ
 @see CharacterRecognitionRequestParam
 
 @param onComplete 応答受信完了時処理ハンドラ
 レスポンス受信が完了した時に呼び出される結果取得処理メソッドを指定します。
 @param onError 応答受信エラー時処理ハンドラ
 レスポンス受信エラーが発生した時に呼び出されるエラー処理メソッドを指定します。
 @see CharacterRecognitionStatusData
*/
-(CharacterRecognitionError *)recognize:(CharacterRecognitionRequestParam *)requestParam
                             onComplete:(void (^)(CharacterRecognitionStatusData *))onComplete
                                onError:(void (^)(SdkError *))onError;

/**
 情景画像からの認識結果を取得する。
 
 
 文字認識結果取得リクエストを送信する。
 
 レスポンスの受信が完了した時に、正常に受信した場合は認識結果データを引数で受け取る処理を応答受信完了時処理ハンドラ（onComplete）に、
 エラー応答の場合はエラー情報を引数で受け取る処理を応答受信エラー時処理ハンドラ（onError）に登録する。
 
 @return 文字認識SDKエラー情報(パラメータエラーの場合CharacterRecognitionErrorParamを、リクエストを送信した場合はnilを返す)
 @see CharacterRecognitionError

 @param requestParam 認識結果取得リクエストパラメータ
 @see CharacterRecognitionJobInfoRequestParam

 @param onComplete 応答受信完了時処理ハンドラ
 レスポンス受信が完了した時に呼び出される認識結果処理メソッドを指定します。
 @param onError 応答受信エラー時処理ハンドラ
 レスポンス受信エラーが発生した時に呼び出されるエラー処理メソッドを指定します。
 @see CharacterRecognitionResultData
 */
-(CharacterRecognitionError *)getResult:(CharacterRecognitionJobInfoRequestParam *)requestParam
                             onComplete:(void (^)(CharacterRecognitionResultData *))onComplete
                                onError:(void (^)(SdkError *))onError;



/**
 情景画像からの認識結果を削除する。
 
 認識ジョブを進行状況に関わらず削除することができる。
 
 レスポンスの受信が完了した時に、正常に受信した場合は認識結果データを引数で受け取る処理を応答受信完了時処理ハンドラ（onComplete）に、
 エラー応答の場合はエラー情報を引数で受け取る処理を応答受信エラー時処理ハンドラ（onError）に登録する。
 
 @return 文字認識SDKエラー情報(パラメータエラーの場合CharacterRecognitionErrorParamを、リクエストを送信した場合はnilを返す)
 @see CharacterRecognitionError

 @param requestParam 削除リクエストパラメータ
 @see CharacterRecognitionJobInfoRequestParam

 @param onComplete 応答受信完了時処理ハンドラ
 レスポンス受信が完了した時に呼び出される処理メソッドを指定します。
 @param onError 応答受信エラー時処理ハンドラ
 レスポンス受信エラーが発生した時に呼び出されるエラー処理メソッドを指定します。
 @see CharacterRecognitionStatusData
 */
-(CharacterRecognitionError *)delete:(CharacterRecognitionJobInfoRequestParam *)requestParam
                          onComplete:(void (^)(CharacterRecognitionStatusData *))onComplete
                             onError:(void (^)(SdkError *))onError;


@end
