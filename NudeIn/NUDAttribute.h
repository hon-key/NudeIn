//  NUDAttribute.h
//  Copyright (c) 2018 HJ-Cai
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "NudeIn-Prefix.h"

#define NUDAB(...) className (^)(__VA_ARGS__)

#define NUDABI(...) ^id (__VA_ARGS__)

#define NUDAT(method,...) \
self.parasiticalObj.method(__VA_ARGS__); \
return self; \

#define NUDAT_ASSIGN OBJC_ASSOCIATION_ASSIGN
#define NUDAT_RETAIN OBJC_ASSOCIATION_RETAIN
#define NUDAT_RETAIN_NONATOMIC OBJC_ASSOCIATION_RETAIN_NONATOMIC
#define NUDAT_COPY OBJC_ASSOCIATION_COPY
#define NUDAT_COPY_NONATOMIC OBJC_ASSOCIATION_COPY_NONATOMIC

#define NUDAT_SYNTHESIZE(tag,type,prop) \
- (type)prop {return objc_getAssociatedObject(self, _cmd);} \
- (void)setIdentifier:(type)_prop \
{ objc_setAssociatedObject(self, @selector(prop), _prop, tag);}

#define NUD_MAKE_TEMPLATE_ARRAY_FROM(firstArg,maker) [NSMutableArray new]; \
id<NUDTemplate> tpl = [maker templateWithId:identifier]; \
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

typedef NS_ENUM(NSUInteger, NUDFontStyle) {
    HKBold, HKRegular, HKMedium, HKLight,
    HKThin, HKSemiBold, HKUltraLight, HKItalic,
};

typedef NS_ENUM(NSInteger, NUDUnderlineStyle) {
    HK_ = NSUnderlineStyleSingle,       HKDot = NSUnderlinePatternDot,              HKByWord = NSUnderlineByWord,
    HK__ = NSUnderlineStyleDouble,      HKDotDot = NSUnderlinePatternDashDotDot,
    HKThick_ = NSUnderlineStyleThick,   HKDash = NSUnderlinePatternDash,
                                        HKDashDot = NSUnderlinePatternDashDot,
                                        HKDashDotDot = NSUnderlinePatternDashDotDot
};

@protocol NUDTemplate;

@interface NUDBase : NSObject
- (id<NUDTemplate>)mergeTemplates:(NSArray<id<NUDTemplate>> *)templates;
@end

@interface NUDAttribute <className> : NUDBase

@property (nonatomic,readonly) NSArray *fontStyles;

// font
- (NUDAB(NSUInteger))font;
- (NUDAB(NSString *,NSUInteger))fontName;
- (NUDAB(UIFont *))fontRes;
- (NUDAB(NUDFontStyle))fontStyle;
- (NUDAB(void))bold;

- (NUDAB(UIColor *))color;
- (NUDAB(UIColor *))mark;
- (NUDAB(NSUInteger,UIColor *))hollow;
- (NUDAB(id target,SEL action))link;
- (NUDAB(NUDUnderlineStyle,UIColor *))_;
- (NUDAB(UIColor *))deprecated;
- (NUDAB(CGFloat))skew;
- (NUDAB(CGFloat))kern;
- (NUDAB(NSUInteger))linefeed;

- (void (^)(void))attach;
- (void (^)(NSString *,...))attachWith;

#define hk_attachWith(...) attachWith(__VA_ARGS__,nil)
- (void (^)(NSString *,...))hk_attachWith;


@end

@interface NUDAttributedAtachment <className> : NUDBase

- (NUDAB(CGFloat,CGFloat))origin;
- (NUDAB(CGFloat))vertical;
- (NUDAB(CGFloat,CGFloat))size;
- (NUDAB(NSUInteger))linefeed;

- (void (^)(void))attach;
- (void (^)(NSString *,...))attachWith;

- (void (^)(NSString *,...))hk_attachWith;

@end

@class NUDTextMaker;
@protocol NUDTemplate <NSObject,NSCopying>

@property (nonatomic,copy) NSString *identifier;
- (instancetype)initWithFather:(NUDTextMaker *)maker identifier:(NSString *)identifier;
- (void)mergeTemplate:(id<NUDTemplate>)tpl;

@end
