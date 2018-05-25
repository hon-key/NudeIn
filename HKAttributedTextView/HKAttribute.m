//  HKAttribute.m
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


#import "HKAttribute.h"

#define HKMethodNotImplemented() \
                @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                               reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
                                             userInfo:nil]

@implementation HKAttribute

- (id (^)(UIColor *))color {HKMethodNotImplemented();}
- (id (^)(NSUInteger))font {HKMethodNotImplemented();}
- (id (^)(NSString *, NSUInteger))fontName {HKMethodNotImplemented();}
- (id (^)(UIColor *))mark {HKMethodNotImplemented();}
- (id (^)(NSUInteger, UIColor *))hollow {HKMethodNotImplemented();}
- (id (^)(UIColor *))_ {HKMethodNotImplemented();}
- (id (^)(CGFloat))kern {HKMethodNotImplemented();}
- (id (^)(void))bold {HKMethodNotImplemented();}
- (id (^)(CGFloat))skew {HKMethodNotImplemented();}
- (id (^)(HKAttributeFontStyle))fontStyle {HKMethodNotImplemented();}
- (void (^)(NSString *))attachWith {HKMethodNotImplemented();}
- (void (^)(void))attach {HKMethodNotImplemented();}
- (id (^)(id, SEL))link {HKMethodNotImplemented();}
- (id (^)(UIColor *))deprecated {HKMethodNotImplemented();}
- (id (^)(UIFont *))fontRes {HKMethodNotImplemented();}
- (id (^)(NSUInteger))linefeed {HKMethodNotImplemented();}


@synthesize fontStyles = _fontStyles;
- (NSArray *)fontStyles {
    if (_fontStyles) {
        _fontStyles = @[@"Bold",@"Regular",@"Medium",@"Light",
                            @"Thin",@"SemiBold",@"UltraLight",@"Italic"];
    }
    return _fontStyles;
}

@end

@implementation HKAttachment

- (id (^)(CGFloat, CGFloat))origin {HKMethodNotImplemented();}
- (id (^)(CGFloat, CGFloat))size {HKMethodNotImplemented();}
- (void (^)(void))attach {HKMethodNotImplemented();}
- (void (^)(NSString *))attachWith {HKMethodNotImplemented();}
- (id (^)(CGFloat))vertical {HKMethodNotImplemented();}
- (id (^)(NSUInteger))linefeed {HKMethodNotImplemented();}

@end

