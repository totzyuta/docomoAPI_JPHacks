//
//  CharacterRecognitionRequestParam.h
//  docomo-characterrecognition-ios-sdk
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import <UIKIT/UIImage.h>
#import "CharacterRecognitionError.h"

/**
 文字認識SDK： 画像からの文字認識結果取得のリクエスト用データクラス
 */
@interface CharacterRecognitionRequestParam : NSObject

/**
 認識言語
 
 */
@property NSString *lang;

/**
 画像データ
 
 */
@property UIImage *imageData;

/**
 コンテンツタイプ
 
 */
@property NSString *imageContentType;

/**
 画像ファイルパス
 
 */
@property NSString *filePath;

/**
 パラメータチェック処理
 
 
 @return エラー情報　正常の場合nilを、パラメータエラーの場合CharacterRecognitionErrorParamをエラー情報のcodeに設定して返す。
 */
-(CharacterRecognitionError *)check;


@end
