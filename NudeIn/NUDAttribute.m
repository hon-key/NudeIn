//  NUDAttribute.m
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


#import "NUDAttribute.h"
#import "NUDText.h"
#import "NUDAttachment.h"
#import <objc/runtime.h>

#define NUDMethodNotImplemented() \
                @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                               reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
                                             userInfo:nil]

@interface NUDBase () {
    NSValue *_range;
}
@end

@implementation NUDBase

- (id)copyWithZone:(NSZone *)zone {
    NUDBase *newObject = [[[self class] alloc] init];
    Ivar ivar = class_getInstanceVariable(NSClassFromString(@"NUDBase"), "_range");
    object_setIvar(newObject, ivar, _range);
    
    return newObject;
}

- (id<NUDTemplate>)mergeTemplates:(NSArray<id<NUDTemplate>> *)templates {
    id<NUDTemplate> result = nil;
    if (templates.count > 0) {
        result = [[templates firstObject] copyWithZone:nil];
        for (int i = 1; i <templates.count; i++) {
            [result mergeTemplate:templates[i]];
        }
    }
    return result;
}

- (NSRange)range {
    NSRange range;
    [_range getValue:&range];
    return range;
}

- (NUDText *)asText {
    if ([self isKindOfClass:[NUDText class]]) {
        return (NUDText *)self;
    }else {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"component is not a textComponent" userInfo:nil];
    }
}

- (NUDAttachment *)asImage {
    if ([self isKindOfClass:[NUDAttachment class]]) {
        return (NUDAttachment *)self;
    }else {
        return nil;
    }
}

- (NSAttributedString *)attributedString {NUDMethodNotImplemented();}

@end

@implementation NUDAttribute

- (id (^)(UIColor *))color {NUDMethodNotImplemented();}
- (id (^)(NSUInteger))font {NUDMethodNotImplemented();}
- (id (^)(NSString *, NSUInteger))fontName {NUDMethodNotImplemented();}
- (id (^)(UIColor *))mark {NUDMethodNotImplemented();}
- (id (^)(NSUInteger, UIColor *))hollow {NUDMethodNotImplemented();}
- (id (^)(NSUInteger, UIColor *))solid {NUDMethodNotImplemented();}
- (id (^)(NUDUnderlineStyle, UIColor *))_ {NUDMethodNotImplemented();}
- (id (^)(CGFloat))kern {NUDMethodNotImplemented();}
- (id (^)(void))bold {NUDMethodNotImplemented();}
- (id (^)(CGFloat))skew {NUDMethodNotImplemented();}
- (id (^)(NUDFontStyle))fontStyle {NUDMethodNotImplemented();}
- (id (^)(id, SEL))link {NUDMethodNotImplemented();}
- (id (^)(UIColor *))deprecated {NUDMethodNotImplemented();}
- (id (^)(UIFont *))fontRes {NUDMethodNotImplemented();}
- (id (^)(NSUInteger))ln {NUDMethodNotImplemented();}
- (id (^)(BOOL))ligature {NUDMethodNotImplemented();}
// shadow
- (id (^)(void))shadow {NUDMethodNotImplemented();}
- (id (^)(NUDShadowDirection))shadowDirection {NUDMethodNotImplemented();}
- (id (^)(CGFloat, CGFloat))shadowOffset {NUDMethodNotImplemented();}
- (id (^)(CGFloat))shadowBlur {NUDMethodNotImplemented();}
- (id (^)(UIColor *))shadowColor {NUDMethodNotImplemented();}
- (id (^)(NSShadow *))shadowRes {NUDMethodNotImplemented();}
/// 内存占用很高
- (id (^)(void))letterpress {NUDMethodNotImplemented();}
- (id (^)(CGFloat))vertical {NUDMethodNotImplemented();}
- (id (^)(CGFloat))stretch {NUDMethodNotImplemented();}
- (id (^)(void))reverse {NUDMethodNotImplemented();}
- (id (^)(CGFloat))lineSpacing {NUDMethodNotImplemented();}
- (id (^)(CGFloat, CGFloat,CGFloat))lineHeight {NUDMethodNotImplemented();}
- (id (^)(CGFloat, CGFloat))paraSpacing {NUDMethodNotImplemented();}
- (id (^)(NUDAlignment))aligment {NUDMethodNotImplemented();}
- (id (^)(CGFloat, CGFloat))indent {NUDMethodNotImplemented();}
- (id (^)(CGFloat))fl_headIndent {NUDMethodNotImplemented();}
- (id (^)(NUDLineBreakMode))linebreak {NUDMethodNotImplemented();}

- (id (^)(NSString *))Highlighted {NUDMethodNotImplemented();}


- (void (^)(NSString *,...))attachWith {NUDMethodNotImplemented();}
- (void (^)(void))attach {NUDMethodNotImplemented();}
- (void (^)(void))apply {NUDMethodNotImplemented();}
- (void (^)(NSString *, ...))nud_attachWith{return nil;}

@synthesize fontStyles = _fontStyles;
- (NSArray *)fontStyles {
    if (_fontStyles) {
        _fontStyles = @[@"Bold",@"Regular",@"Medium",@"Light",
                            @"Thin",@"SemiBold",@"UltraLight",@"Italic"];
    }
    return _fontStyles;
}

@end

@implementation NUDAttributedAtachment

- (id (^)(CGFloat, CGFloat))origin {NUDMethodNotImplemented();}
- (id (^)(CGFloat, CGFloat))size {NUDMethodNotImplemented();}
- (void (^)(void))attach {NUDMethodNotImplemented();}

- (id (^)(CGFloat))vertical {NUDMethodNotImplemented();}
- (id (^)(NSUInteger))ln {NUDMethodNotImplemented();}

- (void (^)(NSString *,...))attachWith {NUDMethodNotImplemented();}
- (void (^)(void))apply {NUDMethodNotImplemented();}

- (void (^)(NSString *, ...))nud_attachWith{return nil;}

@end

