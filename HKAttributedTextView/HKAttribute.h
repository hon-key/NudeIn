//
//  HKAttribute.h
//  textExample
//
//  Created by 工作 on 2018/5/23.
//  Copyright © 2018年 com.CAI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define HKAB(...) className (^)(__VA_ARGS__)
#define HKABI(...) ^id (__VA_ARGS__)

typedef NS_ENUM(NSUInteger, HKAttributeFontStyle) {
    HKBold, HKRegular, HKMedium, HKLight,
    HKThin, HKSemiBold, HKUltraLight, HKItalic,
};

@interface HKAttribute <className> : NSObject

@property (nonatomic,readonly) NSArray *fontStyles;

// font
- (HKAB(NSUInteger))font;
- (HKAB(NSString *,NSUInteger))fontName;
- (HKAB(UIFont *))fontRes;
- (HKAB(HKAttributeFontStyle))fontStyle;
- (HKAB(void))bold;

- (HKAB(UIColor *))color;
- (HKAB(UIColor *))mark;
- (HKAB(NSUInteger,UIColor *))hollow;
- (HKAB(id target,SEL action))link;
- (HKAB(UIColor *))_;
- (HKAB(UIColor *))deprecated;
- (HKAB(CGFloat))skew;
- (HKAB(CGFloat))kern;

- (void (^)(void))attach;
// TODO: 模板功能，指定特定模板字符串，可以应用相应的模板
- (void (^)(NSString *))attachWith;


@end
