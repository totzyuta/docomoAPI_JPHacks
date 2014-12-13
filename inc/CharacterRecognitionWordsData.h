//
//  CharacterRecognitionWordsData.h
//  docomo-characterrecognition-ios-sdk
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import "CharacterRecognitionWordData.h"

/**
 文字認識SDK： 単語情報リストクラス。
 */
@interface CharacterRecognitionWordsData : NSObject

/**
 画像から抽出した単語の数
 
 */
@property NSString * count;

/**
 単語情報リスト
 
 @see CharacterRecognitionWordData
 */
@property NSMutableArray * word;

@end
