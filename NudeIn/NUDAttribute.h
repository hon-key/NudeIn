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

#define NUD_LAZY_LOAD_ARRAY(array)\
- (NSMutableArray *)array { \
if (!_##array) { _##array = [NSMutableArray new]; } \
return _##array; \
}

#define NUD_VALUE_OF_RANGE(range) [NSValue valueWithBytes:&range objCType:@encode(NSRange)]


#define NUDAT_ASSIGN OBJC_ASSOCIATION_ASSIGN
#define NUDAT_RETAIN OBJC_ASSOCIATION_RETAIN
#define NUDAT_RETAIN_NONATOMIC OBJC_ASSOCIATION_RETAIN_NONATOMIC
#define NUDAT_COPY OBJC_ASSOCIATION_COPY
#define NUDAT_COPY_NONATOMIC OBJC_ASSOCIATION_COPY_NONATOMIC

#define NUDAT_SYNTHESIZE(tag,type,prop,upperCaseProp) \
- (type)prop {return objc_getAssociatedObject(self, _cmd);} \
- (void)set##upperCaseProp:(type)_prop \
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
    NUDBold, NUDRegular, NUDMedium, NUDLight,
    NUDThin, NUDSemiBold, NUDUltraLight, NUDItalic,
};

typedef NS_ENUM(NSInteger, NUDUnderlineStyle) {
    NUD_ = NSUnderlineStyleSingle,       NUDDot = NSUnderlinePatternDot,              NUDByWord = NSUnderlineByWord,
    NUD__ = NSUnderlineStyleDouble,      NUDDotDot = NSUnderlinePatternDashDotDot,
    NUDThick_ = NSUnderlineStyleThick,   NUDDash = NSUnderlinePatternDash,
                                         NUDDashDot = NSUnderlinePatternDashDot,
                                         NUDDashDotDot = NSUnderlinePatternDashDotDot
};

typedef NS_OPTIONS(NSInteger, NUDShadowDirection) {
    NUDLeft   =  1 << 0,
    NUDTop    =  1 << 1,
    NUDRight  =  1 << 2,
    NUDBottom =  1 << 3
};

typedef NS_ENUM(NSUInteger, NUDAlignment) {
    NUDAliLeft = NSTextAlignmentLeft,
    NUDAliCenter = NSTextAlignmentCenter,
    NUDAliRight = NSTextAlignmentRight,
    NUDAliJustified = NSTextAlignmentJustified
};

typedef NS_ENUM(NSUInteger, NUDLineBreakMode) {
    NUDWord = NSLineBreakByWordWrapping,
    NUDChar = NSLineBreakByCharWrapping,
    NUDClip = NSLineBreakByClipping,
    NUDTr_head = NSLineBreakByTruncatingHead,
    NUDTr_tail = NSLineBreakByTruncatingTail,
    NUDTr_middle = NSLineBreakByTruncatingMiddle,
    
    NUDWord_HyphenationOn = NSUIntegerMax,
};

@class NUDText,NUDAttachment,NUDAttribute<T>,NUDAttributedAtachment<T>,NUDBase;

@protocol NUDTemplate;

@interface NUDBase : NSObject <NSCopying>

@property (nonatomic,assign,readwrite) BOOL implementedEmpty;

@property (nonatomic,assign,readonly) NSRange range;

- (id<NUDTemplate>)mergeTemplates:(NSArray<id<NUDTemplate>> *)templates;
- (void)mergeComp:(NUDBase *)comp;

- (NUDAttribute<NUDAttribute *> *)asText;
- (NUDAttributedAtachment<NUDAttributedAtachment *> *)asImage;

- (NSAttributedString *)attributedString;

@end

@interface NUDAttribute <className> : NUDBase

@property (nonatomic,readonly) NSArray *fontStyles;

// TODO : 匹配字符串
//- (NUDAB(NSString *))inText;

// font
- (NUDAB(NSUInteger))font;
- (NUDAB(NSString *,NSUInteger))fontName;
- (NUDAB(UIFont *))fontRes;
- (NUDAB(NUDFontStyle))fontStyle;
- (NUDAB(void))bold;

- (NUDAB(UIColor *))color;
- (NUDAB(UIColor *))mark;
- (NUDAB(NSUInteger,UIColor *))hollow;
- (NUDAB(NSUInteger,UIColor *))solid;
- (NUDAB(id target,SEL action))link;
- (NUDAB(NUDUnderlineStyle,UIColor *))_;
- (NUDAB(UIColor *))deprecated;
- (NUDAB(CGFloat))skew;
- (NUDAB(CGFloat))kern;
- (NUDAB(NSUInteger))ln;
- (NUDAB(BOOL))ligature;
- (NUDAB(void))letterpress;
- (NUDAB(CGFloat))vertical;
- (NUDAB(CGFloat))stretch;
- (NUDAB(void))reverse;
// shadow
- (NUDAB(void))shadow;
- (NUDAB(NUDShadowDirection))shadowDirection;
- (NUDAB(CGFloat,CGFloat))shadowOffset;
- (NUDAB(CGFloat))shadowBlur;
- (NUDAB(UIColor *))shadowColor;
- (NUDAB(NSShadow *))shadowRes;

// paragraph
- (NUDAB(CGFloat))lineSpacing; // spacingValue
- (NUDAB(CGFloat,CGFloat,CGFloat))lineHeight; //minimum,maximum,multiple
- (NUDAB(CGFloat,CGFloat))paraSpacing;//before,next
- (NUDAB(NUDAlignment))aligment;
- (NUDAB(CGFloat,CGFloat))indent; //head,tail
- (NUDAB(CGFloat))fl_headIndent;
- (NUDAB(NUDLineBreakMode))linebreak;

// TODO:重写link属性
//- (NUDAB(id,SEL))press;
//- (NUDAB(id,SEL))longPress;
- (NUDAB(NSString *))Highlighted;

- (void (^)(void))attach;
- (void (^)(NSString *,...))attachWith;

- (void (^)(void))apply;

#define nud_attachWith(...) attachWith(__VA_ARGS__,nil)
- (void (^)(NSString *,...))nud_attachWith;


@end

@interface NUDAttributedAtachment <className> : NUDBase

- (NUDAB(CGFloat,CGFloat))origin;
- (NUDAB(CGFloat))vertical;
- (NUDAB(CGFloat,CGFloat))size;
- (NUDAB(NSUInteger))ln;

- (void (^)(void))attach;
- (void (^)(NSString *,...))attachWith;

- (void (^)(void))apply;

- (void (^)(NSString *,...))nud_attachWith;

@end

@class NUDTextMaker;
@protocol NUDTemplate <NSObject,NSCopying>

@property (nonatomic,copy) NSString *identifier;
- (instancetype)initWithFather:(NUDTextMaker *)maker identifier:(NSString *)identifier;
- (void)mergeTemplate:(id<NUDTemplate>)tpl;

@end
