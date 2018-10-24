//
//  NUDInnerText.m
//  textExample
//
//  Created by Ruite Chen on 2018/10/10.
//  Copyright © 2018 com.CAI. All rights reserved.
//

#import "NUDInnerText.h"
#import "NUDText+.h"
#import "NUDInnerText+.h"
#import "NUDTextMaker.h"
#import "NUDTextMaker+.h"

@implementation NUDInnerText

- (instancetype)initWithFather:(NUDTextMaker *)maker string:(NSString *)str {
    self = [super initWithFather:maker string:str];
    return self;
}

- (instancetype)initWithSearchingText:(NUDAttribute *)searchingText {
    if (self = [self initWithFather:nil string:nil]) {
        self.searchingText = searchingText;
    }
    return self;
}

- (id (^)(void))attach {
    return ^NUDTextExtension * (void) {
        return self.nud_attachWith(@"");
    };
}

- (id (^)(NSString *, ...))attachWith {
    return ^NUDTextExtension * (NSString *identifier,...) {
        if ([self.searchingText isKindOfClass:[NUDTextTemplate class]]) {
            
            
            
            
            
        }else if ([self.searchingText isKindOfClass:[NUDText class]]) {
            NUDText *searchingText = (NUDText *)self.searchingText;
            
            
            NUD_STRING_VA_LIST_TO_ARRAY(identifier, identifiers);
            NUDTextTemplate *template = [searchingText templateWithIdentifiers:identifiers];
            [self applyTemplate:template];
            
            NSShadow *shadow = [self.shadowTag makeShadow];
            if (shadow) {
                [self.attributes setObject:shadow forKey:NSShadowAttributeName];
            }
            
            [self match];
            
            [searchingText.innerTexts addObject:self];
            [self addAttributesTo:searchingText.father.string];
            
        }
        
        NUDTextExtension *extension = [[NUDTextExtension alloc] init];
        extension.text = self.searchingText;
        return extension;
    };
}

- (void)addAttributesTo:(NSMutableAttributedString *)mutableAttributedString {
    if ([self.searchingText isKindOfClass:[NUDText class]]) {
        NUDText *searchingText = (NUDText *)self.searchingText;
        NSRange searchingTextRange = searchingText.range;
        for (NSValue *rangeValue in self.mutableRanges) {
            NSRange range;
            [rangeValue getValue:&range];
            range.location += searchingTextRange.location;
            [mutableAttributedString addAttributes:self.attributes range:range];
        }
    }
}

- (void)match {
    NUDOverrideASubclass();
}

- (NSMutableArray<NSValue *> *)mutableRanges {
    if (!_mutableRanges) {
        _mutableRanges = [[NSMutableArray alloc] init];
    }
    return _mutableRanges;
}

@end

#pragma mark -
@implementation NUDInnerStrictMatchingText

- (instancetype)initWithKeyString:(NSString *)keyString searchingText:(NUDAttribute *)searchingText {
    if (self = [super initWithSearchingText:searchingText]) {
        self.string = keyString;
    }
    return self;
}

- (void)match {
    [self.mutableRanges removeAllObjects];
    NSString *searchingString;
    if ([self.searchingText isKindOfClass:[NUDText class]]) {
        searchingString = ((NUDText *)self.searchingText).string;
    }else if ([self.searchingText isKindOfClass:[NUDTextTemplate class]]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"NUDTextTemplate shouldn't makeRanges" userInfo:nil];
    }else {
       @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"unkown implementation" userInfo:nil];
    }
    [self strictMatchStringWithKeyString:self.string searchingString:searchingString];
    
}
- (void)strictMatchStringWithKeyString:(NSString *)keyString searchingString:(NSString *)searchString {
    NSRange range = [searchString rangeOfString:keyString options:NSCaseInsensitiveSearch];
    if (!NSEqualRanges(range, NSMakeRange(NSNotFound, 0))) {
        searchString = [searchString stringByReplacingCharactersInRange:range withString:@""];
        for (NSValue *rangeValue in self.mutableRanges) {
            NSRange storedRange;
            [rangeValue getValue:&storedRange];
            range.location += storedRange.length;
        }
        [self.mutableRanges addObject:NUD_VALUE_OF_RANGE(range)];
        [self strictMatchStringWithKeyString:keyString searchingString:searchString];
    }
}


@end
