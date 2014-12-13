//
//  CharacterRecognitionJobInfoRequestParam.h
//  docomo-characterrecognition-ios-sdk
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import <Foundation/Foundation.h>

/**
 文字認識SDK： 情景画像からの認識結果取得(処理状態/単語)、認識結果削除のAPIリクエスト用データクラス
 */
@interface CharacterRecognitionJobInfoRequestParam : NSObject

/**
 認識ジョブのID
 
 */
@property NSString * jobid;

@end
