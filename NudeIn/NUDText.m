//  NUDText.m
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


#import "NUDText.h"
#import "NUDTextView.h"
#import "NUDTextMaker.h"
#import "NUDAction.h"
#import "NUDTextUpdate.h"
#import "UIImage+NUDPainter.h"
#import "NUDParagraphStyle.h"
#import <objc/runtime.h>

@interface NUDText ()

@property (nonatomic,strong) NSMutableDictionary<NSAttributedStringKey, id> *attributes;

@property (nonatomic,copy,readwrite) NSString *string;

@property (nonatomic,weak) NUDTextMaker *father;

// TODO: inText
@property (nonatomic,strong) NSMutableArray<NUDText *> *innerTexts;
@property (nonatomic,copy) NSString *highlightedTpl;
@property (nonatomic,strong) NUDSelector *selector;

@property (nonatomic,assign) NSUInteger countOfLinefeed;
@property (nonatomic,strong) NUDShadowTag *shadowTag;

@end

@interface NUDTextTemplate ()

@property (nonatomic,strong) NUDText *parasiticalObj;

@property (nonatomic,strong) NUDSelector *tplLinkSelector;

@end


@implementation NUDText


- (instancetype)initWithFather:(NUDTextMaker *)maker string:(NSString *)str {
    if (self = [super init]) {
        _attributes = [NSMutableDictionary new];
        _father = maker;
        _string = str;
        _countOfLinefeed = NSUIntegerMax;

    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    NUDText *text = [super copyWithZone:zone];
    text.father = self.father;
    text.string = self.string;
    text.attributes = [self.attributes mutableCopy];
    text.countOfLinefeed = self.countOfLinefeed;
    text.update = self.update;
    text.highlightedTpl = self.highlightedTpl;
    text.shadowTag = [self.shadowTag copy];
    text.selector = [self.selector copy];
    return text;
}

- (void)mergeComp:(NUDBase *)comp {
    if ([comp isKindOfClass:[NUDText class]]) {
        NUDText *text = (NUDText *)comp;
        [super mergeComp:comp];
        self.father = text.father;
        self.string = text.string;
        self.attributes = [text.attributes mutableCopy];
        self.countOfLinefeed = text.countOfLinefeed;
        self.update = text.update;
        self.highlightedTpl = text.highlightedTpl;
        self.shadowTag = [text.shadowTag copy];
        self.selector = [text.selector copy];
    }
}

- (id (^)(CGFloat))font {
    return NUDABI(CGFloat size) {
        
        [self.attributes setObject:[UIFont systemFontOfSize:size] forKey:NSFontAttributeName];
        return self;
        
    };
}

- (id (^)(NUDFontStyle))fontStyle {
    
    return NUDABI(NUDFontStyle style) {
        
        UIFont *font = [self.attributes objectForKey:NSFontAttributeName];
        if (!font) {
            font = [UIFont systemFontOfSize:17];
        }
        
        NSString *fontName = [font.fontName componentsSeparatedByString:@"-"][0];
        
        NSString *styleStr;
        if (self.fontStyles.count > style) {
            styleStr = self.fontStyles[style];
        }
        if (styleStr) {
            
            fontName = [fontName stringByAppendingString:[NSString stringWithFormat:@"-%@",styleStr]];
            
            UIFont *newFont = [UIFont fontWithName:fontName size:font.pointSize];
            if (newFont) {
                [self.attributes setObject:newFont forKey:NSFontAttributeName];
            }
            
        }
        
        return self;
    };
    
}

- (id (^)(void))bold {
    return NUDABI(void) {
        
        self.fontStyle(NUDBold);
        return self;
        
    };
}

- (id (^)(NSString *, CGFloat))fontName {
    return NUDABI(NSString *name,CGFloat size) {
        
        [self.attributes setObject:[UIFont fontWithName:name size:size] forKey:NSFontAttributeName];
        return self;
        
    };
}

- (id (^)(UIFont *))fontRes {
    return NUDABI(UIFont *font) {
        [self.attributes setObject:font forKey:NSFontAttributeName];
        return self;
    };
}


- (id (^)(UIColor *))color {
    return NUDABI(UIColor *color) {
        
        [self.attributes setObject:color forKey:NSForegroundColorAttributeName];
        return self;
        
    };
}

- (id (^)(UIColor *))mark {
    return NUDABI(UIColor *color) {
        
        [self.attributes setObject:color forKey:NSBackgroundColorAttributeName];
        return self;
        
    };
}

- (id (^)(NUDUnderlineStyle, UIColor *))_ {
    return NUDABI(NUDUnderlineStyle style,UIColor *color) {
        
        if (!(style & NSUnderlineStyleSingle ||
            style & NSUnderlineStyleDouble ||
            style & NSUnderlineStyleThick)) {
            style = style | NSUnderlineStyleSingle;
        }
        [self.attributes setObject:@(style) forKey:NSUnderlineStyleAttributeName];
        if (color) {
            [self.attributes setObject:color forKey:NSUnderlineColorAttributeName];
        }
        return self;
        
    };
}

- (id (^)(UIColor *))deprecated {
    return NUDABI(UIColor *color) {
        
        [self.attributes setObject:@1 forKey:NSStrikethroughStyleAttributeName];
        if (color) {
            [self.attributes setObject:color forKey:NSStrikethroughColorAttributeName];
        }
        return self;
        
    };
}

- (id (^)(CGFloat))skew {
    return NUDABI(CGFloat value) {
        
        [self.attributes setObject:@(value) forKey:NSObliquenessAttributeName];
        return self;
        
    };
}

- (id (^)(CGFloat))kern {
    return NUDABI(CGFloat value) {
        
        [self.attributes setObject:@(value) forKey:NSKernAttributeName];
        return self;
        
    };
}

- (id (^)(NSUInteger, UIColor *))hollow {
    return NUDABI(NSUInteger width, UIColor *color) {
        
        [self.attributes setObject:@(width) forKey:NSStrokeWidthAttributeName];
        [self.attributes setObject:color forKey:NSStrokeColorAttributeName];
        return self;
        
    };
}

- (id (^)(NSUInteger, UIColor *))solid {
    return NUDABI(NSUInteger width, UIColor *color) {
        [self.attributes setObject:@(-(NSInteger)width) forKey:NSStrokeWidthAttributeName];
        [self.attributes setObject:color forKey:NSStrokeColorAttributeName];
        return self;
    };
}

- (id (^)(id, SEL))link {
    return NUDABI(id target,SEL selector) {
        
        NUDSelector *s = [NUDSelector new];
        s.target = target;
        s.action = selector;
        [self.father addSelector:s];
        NSString *urlString = [NSString stringWithFormat:@"selector://%@&%@&%lu",self.string,[s name],(unsigned long)[self.father indexOfSelector:s]];
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [self.attributes setObject:url forKey:NSLinkAttributeName];
        
        return self;
    };
}

- (id (^)(NSUInteger))ln {
    return NUDABI(NSUInteger num) {
        
        self.countOfLinefeed = num;
        
        return self;
    };
}


- (id (^)(BOOL))ligature {
    return NUDABI(BOOL value) {
        [self.attributes setObject:@(value) forKey:NSLigatureAttributeName];
        return self;
    };
}

- (id (^)(void))shadow {
    return NUDABI(void) {
        self.shadowTag.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.33];
        self.shadowTag.shadowOffset = CGSizeMake(1, 1);
        self.shadowTag.shadowBlur = 1.0;
        return self;
    };
}

- (id (^)(NUDShadowDirection,CGFloat))shadowDirection {
    return NUDABI(NUDShadowDirection direction,CGFloat value) {
        CGSize offset = CGSizeZero;
        offset.width  = direction & NUDLeft   ? -value :
                        direction & NUDRight  ?  value : 0;
        offset.height = direction & NUDTop    ? -value :
                        direction & NUDBottom ?  value : 0;
        self.shadowTag.shadowOffset = offset;
        return self;
    };
}

- (id (^)(CGFloat, CGFloat))shadowOffset {
    return NUDABI(CGFloat x,CGFloat y) {
        self.shadowTag.shadowOffset = CGSizeMake(x, y);
        return self;
    };
}

- (id (^)(CGFloat))shadowBlur {
    return NUDABI(CGFloat value) {
        if (value >= 0) {
            self.shadowTag.shadowBlur = value;
        }
        return self;
    };
}

- (id (^)(UIColor *))shadowColor {
    return NUDABI(UIColor *color) {
        self.shadowTag.shadowColor = color;
        return self;
    };
}

- (id (^)(NSShadow *))shadowRes {
    return NUDABI(NSShadow *shadow) {
        self.shadowTag.shadowColor = shadow.shadowColor;
        self.shadowTag.shadowOffset = shadow.shadowOffset;
        self.shadowTag.shadowBlur = shadow.shadowBlurRadius;
        return self;
    };
}

- (id (^)(void))letterpress {
    return NUDABI(void) {
        [self.attributes setObject:NSTextEffectLetterpressStyle forKey:NSTextEffectAttributeName];
        return self;
    };
}

- (id (^)(CGFloat))vertical {
    return NUDABI(CGFloat value) {
        [self.attributes setObject:@(value) forKey:NSBaselineOffsetAttributeName];
        return self;
    };
}

- (id (^)(CGFloat))stretch {
    return NUDABI(CGFloat value) {
        [self.attributes setObject:@(value) forKey:NSExpansionAttributeName];
        return self;
    };
}

- (id (^)(void))reverse {
    return NUDABI(void) {
        
        [self.attributes setObject:@[@(NSWritingDirectionRightToLeft | NSTextWritingDirectionOverride)] forKey:NSWritingDirectionAttributeName];
        return self;
    };
}

- (NSMutableParagraphStyle *)currentParagraphStyle {
    NSMutableParagraphStyle *style = [self.attributes objectForKey:NSParagraphStyleAttributeName];
    if (!style) {
        style = [NUDParagraphStyle new];
        [self.attributes setObject:style forKey:NSParagraphStyleAttributeName];
    }
    return style;
}

- (id (^)(CGFloat))lineSpacing {
    return NUDABI(CGFloat value) {
        if (value >= 0) {
             [self currentParagraphStyle].lineSpacing = value;
        }
        return self;
    };
}

- (id (^)(CGFloat, CGFloat, CGFloat))lineHeight {
    return NUDABI(CGFloat min,CGFloat max,CGFloat mul) {
        if (min >= 0 && max >= 0 && mul >= 0) {
            [self currentParagraphStyle].lineHeightMultiple = mul;
            [self currentParagraphStyle].maximumLineHeight = max;
            [self currentParagraphStyle].minimumLineHeight = min;
        }
        return self;
    };
}

- (id (^)(CGFloat, CGFloat))paraSpacing {
    return NUDABI(CGFloat before,CGFloat next) {
        if (before >=0 && next >= 0) {
            [self currentParagraphStyle].paragraphSpacing = next;
            [self currentParagraphStyle].paragraphSpacingBefore = before;
        }
        return self;
    };
}

- (id (^)(NUDAlignment))aligment {
    return NUDABI(NUDAlignment aligment) {
        [self currentParagraphStyle].alignment = (NSTextAlignment)aligment;
        return self;
    };
}

- (id (^)(CGFloat, CGFloat))indent {
    return NUDABI(CGFloat head,CGFloat tail) {
        [self currentParagraphStyle].headIndent = head > 0 ? head : 0;
        if ([self currentParagraphStyle].firstLineHeadIndent == 0) {
            [self currentParagraphStyle].firstLineHeadIndent = head > 0 ? head : 0;
        }
        [self currentParagraphStyle].tailIndent = tail > 0 ? -tail : 0;
        return self;
    };
}

- (id (^)(CGFloat))fl_headIndent {
    return NUDABI(CGFloat value) {
        [self currentParagraphStyle].firstLineHeadIndent = value > 0 ? value : 0;
        return self;
    };
}

- (id (^)(NUDLineBreakMode))linebreak {
    return NUDABI(NUDLineBreakMode mode) {
        [self currentParagraphStyle].lineBreakMode = mode == NUDWord_HyphenationOn ? (NSLineBreakMode)NUDWord:(NSLineBreakMode)mode;
        [self currentParagraphStyle].hyphenationFactor = mode == NUDWord_HyphenationOn ? 0:0; // 由于hyphenation会改变glyph的数量，会和目前的点击处理逻辑冲突，解决以后再开通使用
        return self;
    };
}

- (id (^)(NSString *))highlighted {
    return NUDABI(NSString *tplName) {
        self.highlightedTpl = tplName;
        return self;
    };
}

- (id (^)(id, SEL))tap {
    return NUDABI(id target,SEL selector) {
        self.selector = [NUDSelector new];
        self.selector.target = target;
        self.selector.action = selector;
        return self;
    };
}


- (void (^)(void))attach {
    return ^void (void) {
        if ([self.father containsComponent:self]) {
            self.apply();
        } else {
            self.attachWith(kNUDTextAllText,nil);
        }
    };
}

- (void (^)(NSString *, ...))attachWith {
    return ^void (NSString *identifier,...) {
        
        NUDTemplateMaker *sharedTemplateMaker = [NUDTextView valueForKey:@"templateMaker"];
        NSMutableArray *tpls = [NSMutableArray new];
        id<NUDTemplate> tpl;
        if ((tpl = [self.father templateWithId:identifier]) &&
            [tpl isKindOfClass:[NUDTextTemplate class]]) {
            [tpls addObject:tpl];
        }else if ((tpl = [sharedTemplateMaker textTemplateWithId:identifier]) &&
                  [tpl isKindOfClass:[NUDTextTemplate class]]) {
            [tpls addObject:tpl];
        }
        va_list idList ;
        va_start(idList,identifier);
        NSString *nextId;
        while ((nextId = va_arg(idList, NSString *))) {
            if ((tpl = [self.father templateWithId:nextId])) {
                [tpls addObject:tpl];
            }else if ((tpl = [sharedTemplateMaker textTemplateWithId:nextId])) {
                [tpls addObject:tpl];
            }
        }
        va_end(idList);
        
        NUDTextTemplate *template = tpls.count > 0 ? [self mergeTemplates:tpls] : nil;
        if (template) {
            
            NSMutableDictionary *tplAttrs = [template.tplAttributes mutableCopy];
            
            if (self.countOfLinefeed == NSUIntegerMax) {
                self.countOfLinefeed = template.parasiticalObj.countOfLinefeed;
            }
            if (!self.highlightedTpl) {
                self.highlightedTpl = template.parasiticalObj.highlightedTpl;
            }
            if (!self.selector) {
                self.selector = template.parasiticalObj.selector;
            }
            
            if ([tplAttrs objectForKey:NSParagraphStyleAttributeName] && [self.attributes objectForKey:NSParagraphStyleAttributeName]) {
                NSMutableParagraphStyle *style = [tplAttrs objectForKey:NSParagraphStyleAttributeName];
                [style nud_mergeParagraphStyle:[self.attributes objectForKey:NSParagraphStyleAttributeName]];
                [self.attributes setObject:style forKey:NSParagraphStyleAttributeName];
                [tplAttrs removeObjectForKey:NSParagraphStyleAttributeName];
            }
            
            [tplAttrs removeObjectsForKeys:[self.attributes allKeys]];
            
            if ([tplAttrs objectForKey:NSLinkAttributeName]) {
                self.link(template.tplLinkSelector.target,template.tplLinkSelector.action);
                [tplAttrs removeObjectForKey:NSLinkAttributeName];
            }
            
            [self.attributes addEntriesFromDictionary:tplAttrs];
            
            if (template.parasiticalObj.shadowTag) {
                [self.shadowTag mergeShadowTag:template.parasiticalObj.shadowTag];
            }
            
        }
        
        NSShadow *shadow = [self.shadowTag makeShadow];
        if (shadow) {
            [self.attributes setObject:shadow forKey:NSShadowAttributeName];
        }
        
        [self appendLineFeed];
        
        NSAttributedString *string = [self attributedString];
        NSRange strRange = [self.father appendString:string];
        
        Ivar ivar = class_getInstanceVariable(NSClassFromString(@"NUDBase"), "_range");
        object_setIvar(self, ivar, NUD_VALUE_OF_RANGE(strRange));
        
        
        [self.father storeTextComponent:self];
        
    };
}

- (void (^)(void))apply {
    return ^void (void) {
        if (self.update) {
            [self.update applyComp:self];
        }
    };
}

- (NSAttributedString *)attributedString {
    return [[NSAttributedString alloc] initWithString:self.string attributes:self.attributes];
}

- (void)clearLineFeed {
    while ([self.string hasSuffix:@"\n"]) {
        self.string = [self.string substringToIndex:self.string.length - 1];
    }
}

- (void)appendLineFeed {
    if (self.countOfLinefeed != NSUIntegerMax) {
        for (int i = 0; i < self.countOfLinefeed; i++) {
            self.string = [self.string stringByAppendingString:@"\n"];
        }
    }
}

- (NUDShadowTag *)shadowTag {
    if (!_shadowTag) {
        _shadowTag = [[NUDShadowTag alloc] init];
    }
    return _shadowTag;
}


@end


@implementation NUDTextTemplate

NUDAT_SYNTHESIZE(-,NSString *,identifier,Identifier,NUDAT_COPY_NONATOMIC)

- (instancetype)initWithFather:(NUDTextMaker *)maker identifier:(NSString *)identifier {
    if (self = [super init]) {
        _parasiticalObj = [[NUDText alloc] initWithFather:maker string:nil];
        self.identifier = identifier;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    NUDTextTemplate *tpl = [super copyWithZone:zone];
    tpl.identifier = self.identifier;
    tpl.parasiticalObj = [self.parasiticalObj copy];
    return tpl;
}

- (void)mergeComp:(NUDBase *)comp {
    if ([comp isKindOfClass:[NUDTextTemplate class]]) {
        NUDTextTemplate *tpl = (NUDTextTemplate *)comp;
        [super mergeComp:tpl];
        self.identifier = tpl.identifier;
        self.parasiticalObj = [tpl.parasiticalObj copy];
    }
}

- (id (^)(CGFloat))font {return NUDABI(CGFloat size) {NUDAT(font,size);};}
- (id (^)(NSString *, CGFloat))fontName {return NUDABI(NSString *string,CGFloat size) {NUDAT(fontName,string,size);};}
- (id (^)(UIFont *))fontRes {return NUDABI(UIFont *font){NUDAT(fontRes,font);};}
- (id (^)(NUDFontStyle))fontStyle {return NUDABI(NUDFontStyle style){NUDAT(fontStyle,style);};}
- (id (^)(void))bold {return NUDABI(void){NUDAT(bold);};}
- (id (^)(UIColor *))color {return NUDABI(UIColor *c) {NUDAT(color,c);};}
- (id (^)(UIColor *))mark {return NUDABI(UIColor *c) {NUDAT(mark,c);};}
- (id (^)(NSUInteger, UIColor *))hollow {return NUDABI(NSUInteger width,UIColor *c) {NUDAT(hollow,width,c);};}
- (id (^)(NSUInteger, UIColor *))solid {return NUDABI(NSUInteger width,UIColor *c) {NUDAT(solid,width,c);};}
- (id (^)(NUDUnderlineStyle, UIColor *))_ {return NUDABI(NUDUnderlineStyle style,UIColor *c) {NUDAT(_,style,c);};}
- (id (^)(UIColor *))deprecated {return NUDABI(UIColor *c) {NUDAT(deprecated,c);};}
- (id (^)(CGFloat))skew {return NUDABI(CGFloat value) {NUDAT(skew,value);};}
- (id (^)(CGFloat))kern {return NUDABI(CGFloat value) {NUDAT(kern,value);};}
- (id (^)(BOOL))ligature {return NUDABI(BOOL value) {NUDAT(ligature,value);};}

- (id (^)(void))shadow {return NUDABI(void) {NUDAT(shadow);};}
- (id (^)(NUDShadowDirection,CGFloat))shadowDirection {return NUDABI(NUDShadowDirection direction,CGFloat value) {NUDAT(shadowDirection,direction,value);};}
- (id (^)(CGFloat, CGFloat))shadowOffset {return NUDABI(CGFloat x,CGFloat y) {NUDAT(shadowOffset,x,y);};}
- (id (^)(CGFloat))shadowBlur {return NUDABI(CGFloat value) {NUDAT(shadowBlur,value);};}
- (id (^)(UIColor *))shadowColor {return NUDABI(UIColor *color) {NUDAT(shadowColor,color);};}
- (id (^)(NSShadow *))shadowRes {return NUDABI(NSShadow *shadow) {NUDAT(shadowRes,shadow);};}
- (id (^)(void))letterpress {return NUDABI(void) {NUDAT(letterpress);};}
- (id (^)(CGFloat))vertical {return NUDABI(CGFloat value) {NUDAT(vertical,value);};}
- (id (^)(CGFloat))stretch {return NUDABI(CGFloat value) {NUDAT(stretch,value);};}
- (id (^)(void))reverse {return NUDABI(void) {NUDAT(reverse);};}
- (id (^)(CGFloat))lineSpacing {return NUDABI(CGFloat value) {NUDAT(lineSpacing,value);};}
- (id (^)(CGFloat, CGFloat, CGFloat))lineHeight {return NUDABI(CGFloat max,CGFloat min,CGFloat mul) {NUDAT(lineHeight,max,min,mul);};}
- (id (^)(CGFloat, CGFloat))paraSpacing {return NUDABI(CGFloat before,CGFloat next){NUDAT(paraSpacing,before,next);};}
- (id (^)(NUDAlignment))aligment {return NUDABI(NUDAlignment ali){NUDAT(aligment,ali);};}
- (id (^)(CGFloat, CGFloat))indent {return NUDABI(CGFloat head,CGFloat tail){NUDAT(indent,head,tail);};}
- (id (^)(CGFloat))fl_headIndent {return NUDABI(CGFloat value){NUDAT(fl_headIndent,value);};}
- (id (^)(NUDLineBreakMode))linebreak {return NUDABI(NUDLineBreakMode mode){NUDAT(linebreak,mode);};}
- (id (^)(NSUInteger))ln {return NUDABI(NSUInteger num){NUDAT(ln,num);};}
- (id (^)(NSString *))highlighted {return NUDABI(NSString *tplName){NUDAT(highlighted,tplName);};}
- (id (^)(id, SEL))tap {return NUDABI(id t,SEL s){NUDAT(tap,t,s);};}

- (id (^)(id, SEL))link {
    return NUDABI(id target,SEL action) {
        
        self.parasiticalObj.string = kNUDTextAllText;
        self.parasiticalObj.link(target,action);
        self.tplLinkSelector = [[self.parasiticalObj.father linkSelectors] lastObject];
        [self.parasiticalObj.father removeLinkSelector:self.tplLinkSelector];
        
        NSString *url = [[self.parasiticalObj.attributes objectForKey:NSLinkAttributeName] absoluteString];
        url = [[url substringToIndex:url.length-1] stringByAppendingString:@"-1"];
        [self.parasiticalObj.attributes setObject:[NSURL URLWithString:url] forKey:NSLinkAttributeName];
        
        return self;
    };
}

- (void (^)(void))attach {
    return ^void (void) {
        [self.parasiticalObj.father addTemplate:self];
    };
}

- (NSDictionary *)tplAttributes {
    return self.parasiticalObj.attributes;
}

- (void)mergeTemplate:(id<NUDTemplate>)tpl {
    if ([tpl isKindOfClass:[NUDTextTemplate class]]) {
        NUDTextTemplate *template = tpl;
        if ([self.parasiticalObj.attributes objectForKey:NSParagraphStyleAttributeName] &&
            [template.parasiticalObj.attributes objectForKey:NSParagraphStyleAttributeName]) {
            NSMutableParagraphStyle *style = [self.parasiticalObj.attributes objectForKey:NSParagraphStyleAttributeName];
            [style nud_mergeParagraphStyle:[template.parasiticalObj.attributes objectForKey:NSParagraphStyleAttributeName]];
            [template.parasiticalObj.attributes removeObjectForKey:NSParagraphStyleAttributeName];
        }
        [self.parasiticalObj.attributes addEntriesFromDictionary:template.parasiticalObj.attributes];
        NUDShadowTag *newTag = [template.parasiticalObj.shadowTag copy];
        [newTag mergeShadowTag:self.parasiticalObj.shadowTag];
        self.parasiticalObj.shadowTag = newTag;
        self.parasiticalObj.selector = template.parasiticalObj.selector;
        if (template.tplLinkSelector) {
            self.tplLinkSelector = template.tplLinkSelector;
        }
        if (template.parasiticalObj.countOfLinefeed != NSUIntegerMax) {
            self.parasiticalObj.countOfLinefeed += template.parasiticalObj.countOfLinefeed;
        }
    }
}

@end

@implementation NUDShadowTag
- (instancetype)init {
    if (self = [super init]) {
        self.shadowBlur = CGFLOAT_MIN;
        self.shadowOffset = CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN);
        self.shadowColor = nil;
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone {
    NUDShadowTag *tag = [[[self class] alloc] init];
    tag.shadowOffset = self.shadowOffset;
    tag.shadowColor = self.shadowColor;
    tag.shadowBlur = self.shadowBlur;
    return tag;
}
- (void)mergeShadowTag:(NUDShadowTag *)shadowTag {
    if (self.shadowBlur == CGFLOAT_MIN) {
        self.shadowBlur = shadowTag.shadowBlur;
    }
    if (CGSizeEqualToSize(self.shadowOffset, CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN))) {
        self.shadowOffset = shadowTag.shadowOffset;
    }
    if (self.shadowColor == nil) {
        self.shadowColor = shadowTag.shadowColor;
    }
}
- (NSShadow *)makeShadow {
    if (self.shadowBlur != CGFLOAT_MIN ||
        !CGSizeEqualToSize(self.shadowOffset, CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN)) ||
        self.shadowColor != nil) {
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowBlurRadius = self.shadowBlur != CGFLOAT_MIN ? self.shadowBlur : 1.0;
        if (self.shadowColor) {
            shadow.shadowColor = self.shadowColor;
        }
        shadow.shadowOffset = !CGSizeEqualToSize(self.shadowOffset, CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN)) ?self.shadowOffset : CGSizeMake(1, 1);
        return shadow;
    }
    return nil;
}
@end


