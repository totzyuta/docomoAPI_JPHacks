//
//  CharacterRecognitionMessageData.h
//  docomo-characterrecognition-ios-sdk
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import <Foundation/Foundation.h>

/**
 文字認識SDK： エラーメッセージクラス。
 */
@interface CharacterRecognitionMessageData : NSObject

/**
 エラーメッセージ
 
 */
@property NSString * text;
/**
 エラー情報
 */
@property NSError * sdkError;


@end
