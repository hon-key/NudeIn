//
//  HKAttribute.m
//  textExample
//
//  Created by 工作 on 2018/5/23.
//  Copyright © 2018年 com.CAI. All rights reserved.
//

#import "HKAttribute.h"

#define HKMethodNotImplemented() \
                @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                               reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
                                             userInfo:nil]

@implementation HKAttribute

- (id (^)(UIColor *))color {HKMethodNotImplemented();}
- (id (^)(void))attach {HKMethodNotImplemented();}
- (id (^)(NSUInteger))font {HKMethodNotImplemented();}
- (id (^)(NSString *, NSUInteger))fontName {HKMethodNotImplemented();}
- (id (^)(UIColor *))mark {HKMethodNotImplemented();}
- (id (^)(NSUInteger, UIColor *))hollow {HKMethodNotImplemented();}
- (id (^)(UIColor *))_ {HKMethodNotImplemented();}
- (id (^)(CGFloat))kern {HKMethodNotImplemented();}
- (id (^)(void))bold {HKMethodNotImplemented();}
- (id (^)(CGFloat))skew {HKMethodNotImplemented();}
- (id (^)(HKAttributeFontStyle))fontStyle {HKMethodNotImplemented();}
- (id (^)(NSString *))attachWith {HKMethodNotImplemented();}
- (id (^)(id, SEL))link {HKMethodNotImplemented();}
- (id (^)(UIColor *))deprecated {HKMethodNotImplemented();}
- (id (^)(UIFont *))fontRes {HKMethodNotImplemented();}

@end
