//  HKAttributedText.m
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


#import "HKAttributedText.h"
#import "HKAttributedTextView.h"
#import <objc/runtime.h>

@interface HKAttributedText ()

@property (nonatomic,strong) NSMutableDictionary<NSAttributedStringKey, id> *attributes;
@property (nonatomic,weak) HKAttributedTextMaker *father;

@property (nonatomic,assign) BOOL shouldDisableLinefeed;

@end

@interface HKAttributedTextTemplate ()

@property (nonatomic,strong) HKAttributedText *parasiticalObj;

@property (nonatomic,strong) HKSelector *tplLinkSelector;
@property (nonatomic,assign) NSUInteger numOfLinefeed;

@end


@implementation HKAttributedText


- (instancetype)initWithFather:(HKAttributedTextMaker *)maker {
    if (self = [super init]) {
        _attributes = [NSMutableDictionary new];
        _father = maker;
        _shouldDisableLinefeed = NO;

    }
    return self;
}

- (id (^)(NSUInteger))font {
    return HKABI(NSUInteger size) {
        
        [self.attributes setObject:[UIFont systemFontOfSize:size] forKey:NSFontAttributeName];
        return self;
        
    };
}

- (id (^)(HKAttributeFontStyle))fontStyle {
    
    return HKABI(HKAttributeFontStyle style) {
        
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
    return HKABI(void) {
        
        self.fontStyle(HKBold);
        return self;
        
    };
}

- (id (^)(NSString *, NSUInteger))fontName {
    return HKABI(NSString *name,NSUInteger size) {
        
        [self.attributes setObject:[UIFont fontWithName:name size:size] forKey:NSFontAttributeName];
        return self;
        
    };
}

- (id (^)(UIFont *))fontRes {
    return HKABI(UIFont *font) {
        [self.attributes setObject:font forKey:NSFontAttributeName];
        return self;
    };
}


- (id (^)(UIColor *))color {
    return HKABI(UIColor *color) {
        
        [self.attributes setObject:color forKey:NSForegroundColorAttributeName];
        return self;
        
    };
}

- (id (^)(UIColor *))mark {
    return HKABI(UIColor *color) {
        
        [self.attributes setObject:color forKey:NSBackgroundColorAttributeName];
        return self;
        
    };
}

- (id (^)(UIColor *))_ {
    return HKABI(UIColor *color) {
        
        [self.attributes setObject:@1 forKey:NSUnderlineStyleAttributeName];
        if (color) {
            [self.attributes setObject:color forKey:NSUnderlineColorAttributeName];
        }
        return self;
        
    };
}

- (id (^)(UIColor *))deprecated {
    return HKABI(UIColor *color) {
        
        [self.attributes setObject:@1 forKey:NSStrikethroughStyleAttributeName];
        if (color) {
            [self.attributes setObject:color forKey:NSStrikethroughColorAttributeName];
        }
        return self;
        
    };
}

- (id (^)(CGFloat))skew {
    return HKABI(CGFloat value) {
        
        [self.attributes setObject:@(value) forKey:NSObliquenessAttributeName];
        return self;
        
    };
}

- (id (^)(CGFloat))kern {
    return HKABI(CGFloat value) {
        
        [self.attributes setObject:@(value) forKey:NSKernAttributeName];
        return self;
        
    };
}

- (id (^)(NSUInteger, UIColor *))hollow {
    return HKABI(NSUInteger width, UIColor *color) {
        
        [self.attributes setObject:@(width) forKey:NSStrokeWidthAttributeName];
        [self.attributes setObject:color forKey:NSStrokeColorAttributeName];
        return self;
        
    };
}

- (id (^)(id, SEL))link {
    return HKABI(id target,SEL selector) {
        
        HKSelector *s = [HKSelector new];
        s.target = target;
        s.action = selector;
        [self.father addSelector:s];
        NSString *urlString = [NSString stringWithFormat:@"selector://%@&%@&%lu",self.string,[s name],(unsigned long)[self.father indexOfSelector:s]];
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [self.attributes setObject:url forKey:NSLinkAttributeName];
        
        return self;
    };
}

- (id (^)(NSUInteger))linefeed {
    return HKABI(NSUInteger num) {
        
        self.shouldDisableLinefeed = num == 0 ? YES : NO;
        
        for (int i = 0; i < num; i++) {
            self.string = [self.string stringByAppendingString:@"\n"];
        }
        return self;
    };
}

- (void (^)(void))attach {
    return ^void (void) {
        self.attachWith(kHKAttributedTextAllTextKey,nil);
    };
}

- (void (^)(NSString *, ...))attachWith {
    return ^void (NSString *identifier,...) {
        
        NSMutableArray *tpls = HK_MAKE_TEMPLATE_ARRAY_FROM(identifier, self.father);
        HKAttributedTextTemplate *template = tpls.count > 0 ? [self mergeTemplates:tpls] : nil;
        if (tpl) {
            
            NSMutableDictionary *tplAttrs = [template.tplAttributes mutableCopy];
            [tplAttrs removeObjectsForKeys:[self.attributes allKeys]];
            
            if ([tplAttrs objectForKey:NSLinkAttributeName]) {
                self.link(template.tplLinkSelector.target,template.tplLinkSelector.action);
                [tplAttrs removeObjectForKey:NSLinkAttributeName];
            }
            if (template.numOfLinefeed > 0 && self.shouldDisableLinefeed == NO) {
                self.linefeed(template.numOfLinefeed);
            }
            
            [self.attributes addEntriesFromDictionary:tplAttrs];
        }
        
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:self.string attributes:self.attributes];
        [self.father appendString:string];
        
    };
}

@end


@implementation HKAttributedTextTemplate

HKAT_SYNTHESIZE(HKAT_COPY_NONATOMIC,NSString *,identifier)

- (instancetype)initWithFather:(HKAttributedTextMaker *)maker identifier:(NSString *)identifier {
    if (self = [super init]) {
        _parasiticalObj = [[HKAttributedText alloc] initWithFather:maker];
        self.identifier = identifier;
        _numOfLinefeed = 0;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    HKAttributedTextTemplate *tpl = [[[self class] alloc] initWithFather:self.parasiticalObj.father identifier:self.identifier];
    tpl.numOfLinefeed = self.numOfLinefeed;
    return tpl;
}

- (id (^)(NSUInteger))font {return HKABI(NSUInteger size) {HKAT(font,size);};}
- (id (^)(NSString *, NSUInteger))fontName {return HKABI(NSString *string,NSUInteger size) {HKAT(fontName,string,size);};}
- (id (^)(UIFont *))fontRes {return HKABI(UIFont *font){HKAT(fontRes,font);};}
- (id (^)(HKAttributeFontStyle))fontStyle {return HKABI(HKAttributeFontStyle style){HKAT(fontStyle,style);};}
- (id (^)(void))bold {return HKABI(void){HKAT(bold);};}
- (id (^)(UIColor *))color {return HKABI(UIColor *c) {HKAT(color,c);};}
- (id (^)(UIColor *))mark {return HKABI(UIColor *c) {HKAT(mark,c);};}
- (id (^)(NSUInteger, UIColor *))hollow {return HKABI(NSUInteger width,UIColor *c) {HKAT(hollow,width,c);};}
- (id (^)(UIColor *))_ {return HKABI(UIColor *c) {HKAT(_,c);};}
- (id (^)(UIColor *))deprecated {return HKABI(UIColor *c) {HKAT(deprecated,c);};}
- (id (^)(CGFloat))skew {return HKABI(CGFloat value) {HKAT(skew,value);};}
- (id (^)(CGFloat))kern {return HKABI(CGFloat value) {HKAT(kern,value);};}

- (id (^)(id, SEL))link {
    return HKABI(id target,SEL action) {
        
        self.parasiticalObj.string = kHKAttributedTextAllTextKey;
        self.parasiticalObj.link(target,action);
        self.tplLinkSelector = [[self.parasiticalObj.father linkSelectors] lastObject];
        [self.parasiticalObj.father removeLinkSelector:self.tplLinkSelector];
        
        NSString *url = [[self.parasiticalObj.attributes objectForKey:NSLinkAttributeName] absoluteString];
        url = [[url substringToIndex:url.length-1] stringByAppendingString:@"-1"];
        [self.parasiticalObj.attributes setObject:[NSURL URLWithString:url] forKey:NSLinkAttributeName];
        
        return self;
    };
}

- (id (^)(NSUInteger))linefeed {
    return HKABI(NSUInteger num) {
        self.numOfLinefeed += num;
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

- (void)mergeTemplate:(id<HKTemplate>)tpl {
    if ([tpl isKindOfClass:[HKAttributedTextTemplate class]]) {
        HKAttributedTextTemplate *template = tpl;
        [self.parasiticalObj.attributes addEntriesFromDictionary:template.parasiticalObj.attributes];
        if (template.tplLinkSelector) {
            self.tplLinkSelector = template.tplLinkSelector;
        }
        self.numOfLinefeed += template.numOfLinefeed;
    }
}


@end
