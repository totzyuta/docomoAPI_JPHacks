//
//  CharacterRecognitionStatusData.h
//  docomo-characterrecognition-ios-sdk
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import "CharacterRecognitionJobData.h"
#import "CharacterRecognitionMessageData.h"

/**
 文字認識SDK： 情景画像からの文字認識依頼のレスポンス用データクラス。
 */
@interface CharacterRecognitionStatusData : NSObject

/**
 認識ジョブ情報
 
 @see CharacterRecognitionJobData
 */
@property CharacterRecognitionJobData * job;

/**
 エラー情報リスト

 @see CharacterRecognitionMessageData
 */
@property CharacterRecognitionMessageData * message;

@end
