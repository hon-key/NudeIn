//
//  HKAttribute.h
//  textExample
//
//  Created by 工作 on 2018/5/23.
//  Copyright © 2018年 com.CAI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define HKAttributeBlock(...) className (^)(__VA_ARGS__)
#define HKAttributeBlockImpl(...) ^className (__VA_ARGS__)

typedef NS_ENUM(NSUInteger, HKAttributeFontStyle) {
    HKBold, HKRegular, HKMedium, HKLight, HKThin, HKSemiBold, HKUltraLight, HKItalic,
};

@interface HKAttribute <className> : NSObject

// font
- (HKAttributeBlock(NSUInteger))font;
- (HKAttributeBlock(NSString *,NSUInteger))fontName;
- (HKAttributeBlock(UIFont *))fontRes;
- (HKAttributeBlock(HKAttributeFontStyle))fontStyle;
- (HKAttributeBlock(void))bold;

- (HKAttributeBlock(UIColor *))color;
- (HKAttributeBlock(UIColor *))mark;
- (HKAttributeBlock(NSUInteger,UIColor *))hollow;
- (HKAttributeBlock(id target,SEL action))link;
- (HKAttributeBlock(UIColor *))_;
- (HKAttributeBlock(UIColor *))deprecated;
- (HKAttributeBlock(CGFloat))skew;
- (HKAttributeBlock(CGFloat))kern;

- (HKAttributeBlock(void))attach;
// TODO: 模板功能，指定特定模板字符串，可以应用相应的模板
- (HKAttributeBlock(NSString *))attachWith;

@end
