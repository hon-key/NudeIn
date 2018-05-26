//  HKAttributedTextMaker.m
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


#import "HKAttributedTextMaker.h"
#import "HKAttributedText.h"

NSString * const kHKAttributedTextAllTextKey = @"HKAttributedTextMaker.alltext";
NSString * const kHKAttributedAttachmentAllImageKey = @"HKAttributedTextMaker.allImage";

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

@interface HKAttributedTextMaker ()

@property (nonatomic,strong,readwrite) NSMutableAttributedString *string;
@property (nonatomic,strong) NSMutableArray<HKSelector *> *selectors;
@property (nonatomic,strong) NSMutableArray<HKAttributedTextTemplate *> *templates;
@property (nonatomic,strong) NSMutableArray<HKAttributedAttachmentTemplate *> *attachmentTemplates;

@end

@implementation HKAttributedTextMaker

- (instancetype)init {
    if (self = [super init]) {
        _string = [[NSMutableAttributedString alloc] init];
        _selectors = [NSMutableArray new];
        _templates = [NSMutableArray new];
    }
    return self;
}

- (HKAttributedText *(^)(NSString *))text {
    return ^HKAttributedText *(NSString *string) {
        
        HKAttributedText *text = [[HKAttributedText alloc] initWithFather:self];
        text.string = string;
        return text;
        
    };
}

- (HKAttributedTextTemplate *(^)(NSString *))textTemplate {
    return ^HKAttributedTextTemplate *(NSString *string) {
        HKAttributedTextTemplate *template = [[HKAttributedTextTemplate alloc] initWithFather:self identifier:string];
        return template;
    };
}

- (HKAttributedTextTemplate *(^)(void))allText {
    return ^HKAttributedTextTemplate *(void) {
        HKAttributedTextTemplate *template = [[HKAttributedTextTemplate alloc] initWithFather:self identifier:kHKAttributedTextAllTextKey];
        return template;
    };
}

- (HKAttributedAttachment *(^)(NSString *))image {
    return ^HKAttributedAttachment *(NSString *imageName) {
        HKAttributedAttachment *attachment = [[HKAttributedAttachment alloc] initWithFather:self];
        attachment.image = [UIImage imageNamed:imageName];
        return attachment;
    };
}

- (HKAttributedAttachmentTemplate *(^)(NSString *))imageTemplate {
    return ^HKAttributedAttachmentTemplate *(NSString *string) {
        HKAttributedAttachmentTemplate *template = [[HKAttributedAttachmentTemplate alloc] initWithFather:self identifier:string];
        return template;
    };
}

- (HKAttributedAttachmentTemplate *(^)(void))allImage {
    return ^HKAttributedAttachmentTemplate *(void) {
        HKAttributedAttachmentTemplate *template = [[HKAttributedAttachmentTemplate alloc] initWithFather:self identifier:kHKAttributedAttachmentAllImageKey];
        return template;
    };
}

@end

@implementation HKAttributedTextMaker (ToolsExtension)

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

- (void)addTemplate:(id<HKTemplate>)tpl {
    if ([tpl.identifier isEqualToString:@""] && tpl.identifier != nil) {
        return;
    }
    id<HKTemplate> existTpl = [self templateWithId:tpl.identifier];
    if (existTpl) {
        [self.templates removeObject:existTpl];
    }
    [self.templates addObject:tpl];
}

- (id<HKTemplate>)templateWithId:(NSString *)identifier {
    for (id<HKTemplate> tpl in self.templates) {
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
