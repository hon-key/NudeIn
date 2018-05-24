//  HKAttributeTextMaker.m
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


#import "HKAttributeTextMaker.h"
#import "HKAttributeText.h"

NSString * const kHKAttributeTextAllTextKey = @"HKAttributeTextMaker.alltext";

@implementation HKSelector
- (NSString *)name {
    return NSStringFromSelector(self.action);
}
- (void)callWithIndex:(NSUInteger)index name:(NSString *)name {
    if ([self.target respondsToSelector:self.action]) {
        IMP p = [self.target methodForSelector:self.action];
        void (*method)(id,SEL,id,NSUInteger) = (void *)p;
        method(self.target,self.action,name,index);
    }
}
@end

@interface HKAttributeTextMaker ()

@property (nonatomic,strong,readwrite) NSMutableAttributedString *string;
@property (nonatomic,strong) NSMutableArray<HKSelector *> *selectors;
@property (nonatomic,strong) NSMutableArray<HKAttributeTextTemplate *> *templates;

@end

@implementation HKAttributeTextMaker

- (instancetype)init {
    if (self = [super init]) {
        _string = [[NSMutableAttributedString alloc] init];
        _selectors = [NSMutableArray new];
        _templates = [NSMutableArray new];
    }
    return self;
}

- (HKAttributeText *(^)(NSString *))text {
    return ^HKAttributeText *(NSString *string) {
        
        HKAttributeText *text = [[HKAttributeText alloc] initWithFather:self];
        text.string = string;
        return text;
        
    };
}

- (HKAttributeTextTemplate *(^)(NSString *))textTemplate {
    return ^HKAttributeTextTemplate *(NSString *string) {
        HKAttributeTextTemplate *template = [[HKAttributeTextTemplate alloc] initWithFather:self identifier:string];
        return template;
    };
}

- (HKAttributeTextTemplate *(^)(void))allText {
    return ^HKAttributeTextTemplate *(void) {
        HKAttributeTextTemplate *template = [[HKAttributeTextTemplate alloc] initWithFather:self identifier:kHKAttributeTextAllTextKey];
        return template;
    };
}

@end

@implementation HKAttributeTextMaker (ToolsExtension)

- (void)appendString:(NSAttributedString *)string {
    [self.string appendAttributedString:string];
}

- (void)addSelector:(HKSelector *)selector {
    [self.selectors addObject:selector];
}

- (NSUInteger)indexOfSelector:(HKSelector *)selector {
    return [self.selectors indexOfObject:selector];
}

- (void)emurateSelector:(void (^)(HKSelector *, BOOL *))handler {
    if (!handler) {
        return;
    }
    for (HKSelector *selector in self.selectors) {
        BOOL stop = NO;
        handler(selector,&stop);
        if (stop) {
            break;
        }
    }
}

- (void)addTemplate:(HKAttributeTextTemplate *)tpl {
    if ([tpl.identifier isEqualToString:@""] && tpl.identifier != nil) {
        return;
    }
    HKAttributeTextTemplate *existTpl = [self templateWithId:tpl.identifier];
    if (existTpl) {
        [self.templates removeObject:existTpl];
    }
    [self.templates addObject:tpl];
}

- (HKAttributeTextTemplate *)templateWithId:(NSString *)identifier {
    for (HKAttributeTextTemplate *tpl in self.templates) {
        if ([tpl.identifier isEqualToString:identifier]) {
            return tpl;
        }
    }
    return nil;
}

- (NSArray *)linkSelectors {
    return [self.selectors copy];
}

- (void)removeLinkSelector:(HKSelector *)sel {
    [self.selectors removeObject:sel];
}

@end
