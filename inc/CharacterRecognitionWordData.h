//
//  CharacterRecognitionWordData.h
//  docomo-characterrecognition-ios-sdk
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import "CharacterRecognitionShapeData.h"

/**
 文字認識SDK： 単語情報クラス。
 */
@interface CharacterRecognitionWordData : NSObject

/**
 単語の文字列
 
 */
@property NSString * text;
/**
 単語のスコア
 
*/
@property NSString * score;
/**
 単語のカテゴリ
 
 */
@property NSString * category;
/**
 単語領域形状
 
 @see CharacterRecognitionShapeData
 */
@property CharacterRecognitionShapeData * shape;

@end
