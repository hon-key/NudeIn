//  NUDTextMaker.m
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


#import "NUDTextMaker.h"
#import "NUDText.h"
#import "NUDAttachment.h"
#import "NUDAction.h"

NSString * const kNUDTextAllText = @"NUDTextMaker.alltext";
NSString * const kNUDAttachmentAllImageKey = @"NUDTextMaker.allImage";


@interface NUDTextMaker ()

@property (nonatomic,strong,readwrite) NSMutableAttributedString *string;
@property (nonatomic,strong) NSMutableArray<NUDSelector *> *selectors;
@property (nonatomic,strong) NSMutableArray<NUDTextTemplate *> *templates;
@property (nonatomic,strong) NSMutableArray<NUDAttachmentTemplate *> *attachmentTemplates;

@end

@implementation NUDTextMaker

- (instancetype)init {
    if (self = [super init]) {
        _string = [[NSMutableAttributedString alloc] init];
        _selectors = [NSMutableArray new];
        _templates = [NSMutableArray new];
    }
    return self;
}

- (NUDText *(^)(NSString *))text {
    return ^NUDText *(NSString *string) {
        
        NUDText *text = [[NUDText alloc] initWithFather:self];
        text.string = string;
        return text;
        
    };
}

- (NUDTextTemplate *(^)(NSString *))textTemplate {
    return ^NUDTextTemplate *(NSString *string) {
        NUDTextTemplate *template = [[NUDTextTemplate alloc] initWithFather:self identifier:string];
        return template;
    };
}

- (NUDTextTemplate *(^)(void))allText {
    return ^NUDTextTemplate *(void) {
        NUDTextTemplate *template = [[NUDTextTemplate alloc] initWithFather:self identifier:kNUDTextAllText];
        return template;
    };
}

- (NUDAttachment *(^)(NSString *))image {
    return ^NUDAttachment *(NSString *imageName) {
        NUDAttachment *attachment = [[NUDAttachment alloc] initWithFather:self];
        attachment.image = [UIImage imageNamed:imageName];
        return attachment;
    };
}

- (NUDAttachmentTemplate *(^)(NSString *))imageTemplate {
    return ^NUDAttachmentTemplate *(NSString *string) {
        NUDAttachmentTemplate *template = [[NUDAttachmentTemplate alloc] initWithFather:self identifier:string];
        return template;
    };
}

- (NUDAttachmentTemplate *(^)(void))allImage {
    return ^NUDAttachmentTemplate *(void) {
        NUDAttachmentTemplate *template = [[NUDAttachmentTemplate alloc] initWithFather:self identifier:kNUDAttachmentAllImageKey];
        return template;
    };
}

@end

@implementation NUDTextMaker (ToolsExtension)

- (void)appendString:(NSAttributedString *)string {
    [self.string appendAttributedString:string];
}

- (void)addSelector:(NUDSelector *)selector {
    [self.selectors addObject:selector];
}

- (NSUInteger)indexOfSelector:(NUDSelector *)selector {
    return [self.selectors indexOfObject:selector];
}

- (void)emurateSelector:(void (^)(NUDSelector *, BOOL *))handler {
    if (!handler) {
        return;
    }
    for (NUDSelector *selector in self.selectors) {
        BOOL stop = NO;
        handler(selector,&stop);
        if (stop) {
            break;
        }
    }
}

- (void)addTemplate:(id<NUDTemplate>)tpl {
    if ([tpl.identifier isEqualToString:@""] && tpl.identifier != nil) {
        return;
    }
    id<NUDTemplate> existTpl = [self templateWithId:tpl.identifier];
    if (existTpl) {
        [self.templates removeObject:existTpl];
    }
    [self.templates addObject:tpl];
}

- (id<NUDTemplate>)templateWithId:(NSString *)identifier {
    for (id<NUDTemplate> tpl in self.templates) {
        if ([tpl.identifier isEqualToString:identifier]) {
            return tpl;
        }
    }
    return nil;
}

- (NSArray *)linkSelectors {
    return [self.selectors copy];
}

- (void)removeLinkSelector:(NUDSelector *)sel {
    [self.selectors removeObject:sel];
}

@end
