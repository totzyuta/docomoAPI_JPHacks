//
//  CharacterRecognitionResultData.h
//  docomo-characterrecognition-ios-sdk
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import "CharacterRecognitionJobData.h"
#import "CharacterRecognitionMessageData.h"
#import "CharacterRecognitionWordsData.h"

/**
 文字認識SDK： 情景画像文字認識結果クラス。
 */
@interface CharacterRecognitionResultData : NSObject

/**
 認識ジョブ情報
 
 @see CharacterRecognitionJobData
 */
@property CharacterRecognitionJobData *job;

/**
 エラー情報リスト

 @see CharacterRecognitionMessageData
 */
@property CharacterRecognitionMessageData *message;
/**
 単語情報リスト
 
 @see CharacterRecognitionWordsData
 */
@property CharacterRecognitionWordsData *words;

@end
