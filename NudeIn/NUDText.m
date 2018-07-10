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
#import <objc/runtime.h>

@interface NUDText ()

@property (nonatomic,strong) NSMutableDictionary<NSAttributedStringKey, id> *attributes;

@property (nonatomic,copy,readwrite) NSString *string;

@property (nonatomic,weak) NUDTextMaker *father;

// TODO: inText
@property (nonatomic,strong) NSMutableArray<NUDText *> *innerTexts;
@property (nonatomic,copy) NSString *highlightedTpl;

@property (nonatomic,assign) NSUInteger countOfLinefeed;

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
    }
}

- (id (^)(NSUInteger))font {
    return NUDABI(NSUInteger size) {
        
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

- (id (^)(NSString *, NSUInteger))fontName {
    return NUDABI(NSString *name,NSUInteger size) {
        
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
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeMake(1, 1);
        shadow.shadowBlurRadius = 1.0;
        [self.attributes setObject:shadow forKey:NSShadowAttributeName];
        return self;
    };
}

- (NSShadow *)currentShadow {
    NSShadow *shadow = [self.attributes objectForKey:NSShadowAttributeName];
    if (!shadow) {
        self.shadow();
        shadow = [self.attributes objectForKey:NSShadowAttributeName];
    }
    return shadow;
}

- (id (^)(NUDShadowDirection))shadowDirection {
    return NUDABI(NUDShadowDirection direction) {
        CGSize offset = CGSizeZero;
        offset.width  = direction & NUDLeft   ? -1 : 0;
        offset.width  = direction & NUDRight  ?  1 : 0;
        offset.height = direction & NUDTop    ? -1 : 0;
        offset.height = direction & NUDBottom ?  1 : 0;
        [self currentShadow].shadowOffset = offset;
        return self;
    };
}

- (id (^)(CGFloat, CGFloat))shadowOffset {
    return NUDABI(CGFloat x,CGFloat y) {
        [self currentShadow].shadowOffset = CGSizeMake(x, y);
        return self;
    };
}

- (id (^)(CGFloat))shadowBlur {
    return NUDABI(CGFloat value) {
        if (value >= 0) {
            [self currentShadow].shadowBlurRadius = value;
        }
        return self;
    };
}

- (id (^)(UIColor *))shadowColor {
    return NUDABI(UIColor *color) {
        [self currentShadow].shadowColor = color;
        return self;
    };
}

- (id (^)(NSShadow *))shadowRes {
    return NUDABI(NSShadow *shadow) {
        [self.attributes setObject:shadow forKey:NSShadowAttributeName];
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
        style = [NSMutableParagraphStyle new];
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

- (id (^)(NSString *))Highlighted {
    return NUDABI(NSString *tplName) {
        self.highlightedTpl = tplName;
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
        
        NSMutableArray *tpls = NUD_MAKE_TEMPLATE_ARRAY_FROM(identifier, self.father);
        NUDTextTemplate *template = tpls.count > 0 ? [self mergeTemplates:tpls] : nil;
        if (template) {
            
            NSMutableDictionary *tplAttrs = [template.tplAttributes mutableCopy];
            [tplAttrs removeObjectsForKeys:[self.attributes allKeys]];
            
            if ([tplAttrs objectForKey:NSLinkAttributeName]) {
                self.link(template.tplLinkSelector.target,template.tplLinkSelector.action);
                [tplAttrs removeObjectForKey:NSLinkAttributeName];
            }
            if (self.countOfLinefeed == NSUIntegerMax) {
                self.countOfLinefeed = template.parasiticalObj.countOfLinefeed;
            }
            if (!self.highlightedTpl) {
                self.highlightedTpl = template.parasiticalObj.highlightedTpl;
            }
            
            [self.attributes addEntriesFromDictionary:tplAttrs];
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


@end


@implementation NUDTextTemplate

NUDAT_SYNTHESIZE(NUDAT_COPY_NONATOMIC,NSString *,identifier,Identifier)

- (instancetype)initWithFather:(NUDTextMaker *)maker identifier:(NSString *)identifier {
    if (self = [super init]) {
        _parasiticalObj = [[NUDText alloc] initWithFather:maker string:nil];
        self.identifier = identifier;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    NUDTextTemplate *tpl = [super copyWithZone:zone];
    tpl.parasiticalObj = [[NUDText alloc] initWithFather:self.parasiticalObj.father string:nil];
    tpl.identifier = self.identifier;
    tpl.parasiticalObj = [self.parasiticalObj copy];
    return tpl;
}

- (void)mergeComp:(NUDBase *)comp {
    if ([comp isKindOfClass:[NUDTextTemplate class]]) {
        NUDTextTemplate *tpl = (NUDTextTemplate *)comp;
        [super mergeComp:tpl];
        self.parasiticalObj = [[NUDText alloc] initWithFather:tpl.parasiticalObj.father string:nil];
        self.identifier = tpl.identifier;
        self.parasiticalObj = [tpl.parasiticalObj copy];
    }
}

- (id (^)(NSUInteger))font {return NUDABI(NSUInteger size) {NUDAT(font,size);};}
- (id (^)(NSString *, NSUInteger))fontName {return NUDABI(NSString *string,NSUInteger size) {NUDAT(fontName,string,size);};}
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
- (id (^)(NUDShadowDirection))shadowDirection {return NUDABI(NUDShadowDirection direction) {NUDAT(shadowDirection,direction);};}
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
- (id (^)(NSString *))Highlighted {return NUDABI(NSString *tplName){NUDAT(Highlighted,tplName);};}

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
        [self.parasiticalObj.attributes addEntriesFromDictionary:template.parasiticalObj.attributes];
        if (template.tplLinkSelector) {
            self.tplLinkSelector = template.tplLinkSelector;
        }
        self.parasiticalObj.countOfLinefeed += template.parasiticalObj.countOfLinefeed;
    }
}


@end
