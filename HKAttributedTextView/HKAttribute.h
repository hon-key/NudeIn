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

#define HK_MAKE_TEMPLATE_ARRAY_FROM(firstArg,maker) [NSMutableArray new]; \
id<HKTemplate> tpl = [maker templateWithId:identifier]; \
if (tpl) { \
    [tpls addObject:tpl]; \
} \
va_list idList ; \
va_start(idList,firstArg); \
NSString *nextId; \
while ((nextId = va_arg(idList, NSString *))) { \
    tpl = [maker templateWithId:nextId]; \
    if (tpl) { \
        [tpls addObject:tpl]; \
    } \
} \
va_end(idList);

typedef NS_ENUM(NSUInteger, HKAttributeFontStyle) {
    HKBold, HKRegular, HKMedium, HKLight,
    HKThin, HKSemiBold, HKUltraLight, HKItalic,
};

typedef NS_ENUM(NSInteger, HKAttributeUnderlineStyle) {
    HK_ = NSUnderlineStyleSingle,       HKDot = NSUnderlinePatternDot,              HKByWord = NSUnderlineByWord,
    HK__ = NSUnderlineStyleDouble,      HKDotDot = NSUnderlinePatternDashDotDot,
    HKThick_ = NSUnderlineStyleThick,   HKDash = NSUnderlinePatternDash,
                                        HKDashDot = NSUnderlinePatternDashDot,
                                        HKDashDotDot = NSUnderlinePatternDashDotDot
};

@protocol HKTemplate;

@interface HKBase : NSObject
- (id<HKTemplate>)mergeTemplates:(NSArray<id<HKTemplate>> *)templates;
@end

@interface HKAttribute <className> : HKBase

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
- (HKAB(HKAttributeUnderlineStyle,UIColor *))_;
- (HKAB(UIColor *))deprecated;
- (HKAB(CGFloat))skew;
- (HKAB(CGFloat))kern;
- (HKAB(NSUInteger))linefeed;

- (void (^)(void))attach;
- (void (^)(NSString *,...))attachWith;

#define hk_attachWith(...) attachWith(__VA_ARGS__,nil)
- (void (^)(NSString *,...))hk_attachWith;


@end

@interface HKAttachment <className> : HKBase

- (HKAB(CGFloat,CGFloat))origin;
- (HKAB(CGFloat))vertical;
- (HKAB(CGFloat,CGFloat))size;
- (HKAB(NSUInteger))linefeed;

- (void (^)(void))attach;
- (void (^)(NSString *,...))attachWith;

- (void (^)(NSString *,...))hk_attachWith;

@end

@class HKAttributedTextMaker;
@protocol HKTemplate <NSObject,NSCopying>

@property (nonatomic,copy) NSString *identifier;
- (instancetype)initWithFather:(HKAttributedTextMaker *)maker identifier:(NSString *)identifier;
- (void)mergeTemplate:(id<HKTemplate>)tpl;

@end
