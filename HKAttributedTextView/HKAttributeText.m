//
//  HKAttributeText.m
//  textExample
//
//  Created by 工作 on 2018/5/23.
//  Copyright © 2018年 com.CAI. All rights reserved.
//

#import "HKAttributeText.h"
#import "HKAttributeTextView.h"

@implementation HKAttributeText


- (instancetype)initWithFather:(HKAttributeTextMaker *)maker {
    if (self = [super init]) {
        self.attributes = [NSMutableDictionary new];
        self.father = maker;
    }
    return self;
}

- (id (^)(NSUInteger))font {
    return ^HKAttributeText *(NSUInteger size) {
        
        [self.attributes setObject:[UIFont systemFontOfSize:size] forKey:NSFontAttributeName];
        return self;
        
    };
}

- (id (^)(HKAttributeFontStyle))fontStyle {
    
    return ^HKAttributeText *(HKAttributeFontStyle style) {
        
        UIFont *font = [self.attributes objectForKey:NSFontAttributeName];
        if (!font) {
            font = [UIFont systemFontOfSize:17];
        }
        
        NSString *fontName = [font.fontName componentsSeparatedByString:@"-"][0];
        
        NSString *styleStr;
        if ([self fontStyleArray].count > style) {
            styleStr = [self fontStyleArray][style];
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
    return ^HKAttributeText *(void) {
        
        self.fontStyle(HKBold);
        return self;
        
    };
}

- (id (^)(NSString *, NSUInteger))fontName {
    return ^HKAttributeText *(NSString *name,NSUInteger size) {
        
        [self.attributes setObject:[UIFont fontWithName:name size:size] forKey:NSFontAttributeName];
        return self;
        
    };
}

- (id (^)(UIFont *))fontRes {
    return ^HKAttributeText *(UIFont *font) {
        [self.attributes setObject:font forKey:NSFontAttributeName];
        return self;
    };
}


- (id (^)(UIColor *))color {
    return ^HKAttributeText *(UIColor *color) {
        
        [self.attributes setObject:color forKey:NSForegroundColorAttributeName];
        return self;
        
    };
}

- (id (^)(UIColor *))mark {
    return ^HKAttributeText *(UIColor *color) {
        
        [self.attributes setObject:color forKey:NSBackgroundColorAttributeName];
        return self;
        
    };
}

- (id (^)(UIColor *))_ {
    return ^HKAttributeText *(UIColor *color) {
        
        [self.attributes setObject:@1 forKey:NSUnderlineStyleAttributeName];
        if (color) {
            [self.attributes setObject:color forKey:NSUnderlineColorAttributeName];
        }
        return self;
        
    };
}

- (id (^)(UIColor *))deprecated {
    return ^HKAttributeText *(UIColor *color) {
        
        [self.attributes setObject:@1 forKey:NSStrikethroughStyleAttributeName];
        if (color) {
            [self.attributes setObject:color forKey:NSStrikethroughColorAttributeName];
        }
        return self;
        
    };
}

- (id (^)(CGFloat))skew {
    return ^HKAttributeText *(CGFloat value) {
        
        [self.attributes setObject:@(value) forKey:NSObliquenessAttributeName];
        return self;
        
    };
}

- (id (^)(CGFloat))kern {
    return ^HKAttributeText *(CGFloat value) {
        
        [self.attributes setObject:@(value) forKey:NSKernAttributeName];
        return self;
        
    };
}

- (id (^)(NSUInteger, UIColor *))hollow {
    return ^HKAttributeText *(NSUInteger width, UIColor *color) {
        
        [self.attributes setObject:@(width) forKey:NSStrokeWidthAttributeName];
        [self.attributes setObject:color forKey:NSStrokeColorAttributeName];
        return self;
        
    };
}

- (id (^)(id, SEL))link {
    return ^HKAttributeText *(id target,SEL selector) {
        
        HKSelector *s = [HKSelector new];
        s.target = target;
        s.action = selector;
        [self.father.selectors addObject:s];
        NSString *urlString = [NSString stringWithFormat:@"selector://%@&%@&%lu",self.string,[s name],(unsigned long)[self.father.selectors indexOfObject:s]];
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [self.attributes setObject:url forKey:NSLinkAttributeName];
        
        return self;
    };
}

- (id (^)(void))attach {
    return ^HKAttributeText *(void) {
        
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:self.string attributes:self.attributes];
        [self.father appendString:string];
        return self;
        
    };
}

- (NSArray *)fontStyleArray {
    static NSArray *fontStyle;
    if (!fontStyle) {
        fontStyle = @[@"Bold",@"Regular",@"Medium",@"Light",@"Thin",@"SemiBold",@"UltraLight",@"Italic"];
    }
    return fontStyle;
}


@end
