//
//  CharacterRecognitionJobData.h
//  docomo-characterrecognition-ios-sdk
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import <Foundation/Foundation.h>

/**
 文字認識SDK： 認識ジョブ情報クラス。
 */
@interface CharacterRecognitionJobData : NSObject

/**
 認識ジョブのID
 
 */
@property NSString * id;
/**
 進行状況
 
 */
@property NSString * status;
/**
 受付時刻
 
 */
@property NSString * queue_time;

@end
