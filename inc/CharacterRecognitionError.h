//
//  CharacterRecognitionError.h
//  docomo-characterrecognition-ios-sdk
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import <Foundation/Foundation.h>

/**
 */
typedef enum CharacterRecognitionErrorType : NSInteger
{
    CharacterRecognitionErrorParam = 100301,  // パラメータ不正
    CharacterRecognitionErrorAuth = 100302,  // 認証失敗
    CharacterRecognitionErrorSdkfail = 100303,  // SDK内処理失敗
    CharacterRecognitionErrorTimeout = 100304,  // タイムアウト
    CharacterRecognitionErrorCongestion = 100305,  // 輻輳規制
    CharacterRecognitionErrorServer = 100306,   // その他サーバーエラー
    CharacterRecognitionErrorData = 100307   // レスポンスデータエラー
    
}CharacterRecognitionErrorType;

/**
 エラー情報
 文字認識SDKのリクエスト送信の結果によりエラー定数を設定する。
 
 
 
 エラー定数
 
 
 CharacterRecognitionErrorParam パラメータ不正
 
 CharacterRecognitionErrorAuth  認証失敗
 
 CharacterRecognitionErrorSdkfail  SDK内処理失敗
 
 CharacterRecognitionErrorTimeout  タイムアウト
 
 CharacterRecognitionErrorCongestion  一時利用不可
 
 CharacterRecognitionErrorServer  その他サーバーエラー
 
 CharacterRecognitionErrorData  レスポンスデータエラー
 
 */
@interface CharacterRecognitionError : NSError

/** 文字認識より認識結果が取得できない場合のエラーメッセージ。 */
extern NSString * ERROR_MSG_07;
/** ファイルの存在チェックエラー。 */
extern NSString * ERROR_MSG_FILE_NOT_FOUND;

@end