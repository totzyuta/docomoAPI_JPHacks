//
//  CharacterRecognitionShapeData.h
//  docomo-characterrecognition-ios-sdk
//  (c) 2014 NTT DOCOMO, INC. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import "CharacterRecognitionPointData.h"

/**
 文字認識SDK： 領域形状データクラス。
 */
@interface CharacterRecognitionShapeData : NSObject

/**
 頂点の数
 
 */
@property NSInteger count;

/**
 頂点情報リスト
 
 @see CharacterRecognitionPointData
 */
@property NSMutableArray * point;

@end
