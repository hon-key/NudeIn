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

#define HKAT(method,...) \
self.parasiticalObj.method(__VA_ARGS__); \
return self; \

#define HKAT_ASSIGN OBJC_ASSOCIATION_ASSIGN
#define HKAT_RETAIN OBJC_ASSOCIATION_RETAIN
#define HKAT_RETAIN_NONATOMIC OBJC_ASSOCIATION_RETAIN_NONATOMIC
#define HKAT_COPY OBJC_ASSOCIATION_COPY
#define HKAT_COPY_NONATOMIC OBJC_ASSOCIATION_COPY_NONATOMIC

#define HKAT_SYNTHESIZE(tag,type,prop) \
- (type)prop {return objc_getAssociatedObject(self, _cmd);} \
- (void)setIdentifier:(type)_prop \
{ objc_setAssociatedObject(self, @selector(prop), _prop, tag);}

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
- (HKAB(NSUInteger))linefeed;

- (void (^)(void))attach;
- (void (^)(NSString *))attachWith;


@end

@interface HKAttachment <className> : NSObject

- (HKAB(CGFloat,CGFloat))origin;
- (HKAB(CGFloat))vertical;
- (HKAB(CGFloat,CGFloat))size;
- (HKAB(NSUInteger))linefeed;

- (void (^)(void))attach;
- (void (^)(NSString *))attachWith;

@end

@class HKAttributedTextMaker;
@protocol HKTemplate <NSObject>

@property (nonatomic,copy) NSString *identifier;
- (instancetype)initWithFather:(HKAttributedTextMaker *)maker identifier:(NSString *)identifier;

@end
