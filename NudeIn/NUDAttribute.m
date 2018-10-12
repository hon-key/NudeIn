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

#define NUDMethodNotImplemented(...) \
                                    if (self.implementedEmpty) {return ^id (__VA_ARGS__) {return self;};} \
                                    else { NUDOverrideASubclass(); }

#define NUDMethodNotImplementedReturnVoid(...) \
                                   if (self.implementedEmpty) {return ^void (__VA_ARGS__) {return;};} \
                                   else { NUDOverrideASubclass(); }


@interface NUDBase () {
    NSValue *_range;
}
@end

@implementation NUDBase

- (instancetype)init {
    if (self = [super init]) {
        _implementedEmpty = NO; // default;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    NUDBase *newObject = [[[self class] alloc] init];
    Ivar ivar = class_getInstanceVariable(NSClassFromString(@"NUDBase"), "_range");
    object_setIvar(newObject, ivar, _range);
    newObject.implementedEmpty = self.implementedEmpty;
    
    return newObject;
}

- (void)mergeComp:(NUDBase *)comp {
    NSRange range = [comp range];
    _range = NUD_VALUE_OF_RANGE(range);
    _implementedEmpty = comp.implementedEmpty;
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

- (NSAttributedString *)attributedString {NUDOverrideASubclass();}

// 为了解决 NUDBase 的子类自己的方法在 Update 时用错了 asText 和 asImage 之后引起的 unrecognized selector 问题，拦截了 UNrecognized selector 方法
// to solve nrecognized selector problem which is arise from a call to Subclass method of NUDBase when you update a NUDBase and use asText in NUDAttachment or asImage in NUDText
- (id)forwardingTargetForSelector:(SEL)aSelector {
    Class unkownMethodHandler = NSClassFromString(@"NUDUnkownMethodHandler");
    if (!unkownMethodHandler) {
        unkownMethodHandler = objc_allocateClassPair([NSObject class], "NUDUnkownMethodHandler", 0);
        objc_registerClassPair(unkownMethodHandler);
    }
    if (![self existMethod:aSelector forClass:unkownMethodHandler]) {
        
        IMP imp = imp_implementationWithBlock((id(^)(void)) ^(void){
            NSLog(@"no method for NUDBase : %@", NSStringFromSelector(aSelector));
            return ^id(void) { return self; };
        });
        class_addMethod(unkownMethodHandler, aSelector, imp, [NSStringFromSelector(aSelector) UTF8String]);
    }
    Class NUDUnkownMethodHandler = [unkownMethodHandler class];
    return [[NUDUnkownMethodHandler alloc] init];
}

- (BOOL)existMethod:(SEL)targetSelector forClass:(Class)class {
    unsigned int count;
    Method *methods = class_copyMethodList(class, &count);
    for (int i = 0; i < count; i++) {
        SEL selector = method_getName(methods[i]);
        if ([NSStringFromSelector(selector) isEqualToString:NSStringFromSelector(targetSelector)]) {
            return YES;
        }
    }
    return NO;
}

@end

@implementation NUDAttribute

- (id (^)(UIColor *))color {NUDMethodNotImplemented(UIColor *c);}
- (id (^)(CGFloat))font {NUDMethodNotImplemented(CGFloat f);}
- (id (^)(NSString *, CGFloat))fontName {NUDMethodNotImplemented(NSString *s,CGFloat f);}
- (id (^)(UIColor *))mark {NUDMethodNotImplemented(UIColor *c);}
- (id (^)(NSUInteger, UIColor *))hollow {NUDMethodNotImplemented(NSUInteger i,UIColor *c);}
- (id (^)(NSUInteger, UIColor *))solid {NUDMethodNotImplemented(NSUInteger i,UIColor *c);}
- (id (^)(NUDUnderlineStyle, UIColor *))_ {NUDMethodNotImplemented(NUDUnderlineStyle s,UIColor *c);}
- (id (^)(CGFloat))kern {NUDMethodNotImplemented(CGFloat f);}
- (id (^)(void))bold {NUDMethodNotImplemented(void);}
- (id (^)(CGFloat))skew {NUDMethodNotImplemented(CGFloat f);}
- (id (^)(NUDFontStyle))fontStyle {NUDMethodNotImplemented(NUDFontStyle f);}
- (id (^)(id, SEL))link {NUDMethodNotImplemented(id d,SEL s);}
- (id (^)(UIColor *))deprecated {NUDMethodNotImplemented(UIColor *c);}
- (id (^)(UIFont *))fontRes {NUDMethodNotImplemented(UIFont *f);}
- (id (^)(NSUInteger))ln {NUDMethodNotImplemented(NSUInteger i);}
- (id (^)(BOOL))ligature {NUDMethodNotImplemented(BOOL b);}
// shadow
- (id (^)(void))shadow {NUDMethodNotImplemented(void);}
- (id (^)(NUDShadowDirection,CGFloat))shadowDirection {NUDMethodNotImplemented(NUDShadowDirection d,CGFloat f);}
- (id (^)(CGFloat, CGFloat))shadowOffset {NUDMethodNotImplemented(CGFloat f1,CGFloat f2);}
- (id (^)(CGFloat))shadowBlur {NUDMethodNotImplemented(CGFloat f);}
- (id (^)(UIColor *))shadowColor {NUDMethodNotImplemented(UIColor *c);}
- (id (^)(NSShadow *))shadowRes {NUDMethodNotImplemented(NSShadow *s);}
/// 内存占用很高
- (id (^)(void))letterpress {NUDMethodNotImplemented(void);}
- (id (^)(CGFloat))vertical {NUDMethodNotImplemented(CGFloat f);}
- (id (^)(CGFloat))stretch {NUDMethodNotImplemented(CGFloat f);}
- (id (^)(void))reverse {NUDMethodNotImplemented(void);}
- (id (^)(CGFloat))lineSpacing {NUDMethodNotImplemented(CGFloat f);}
- (id (^)(CGFloat, CGFloat,CGFloat))lineHeight {NUDMethodNotImplemented(CGFloat f1,CGFloat f2,CGFloat f3);}
- (id (^)(CGFloat, CGFloat))paraSpacing {NUDMethodNotImplemented(CGFloat f1,CGFloat f2);}
- (id (^)(NUDAlignment))aligment {NUDMethodNotImplemented(NUDAlignment a);}
- (id (^)(CGFloat, CGFloat))indent {NUDMethodNotImplemented(CGFloat f1,CGFloat f2);}
- (id (^)(CGFloat))fl_headIndent {NUDMethodNotImplemented(CGFloat f);}
- (id (^)(NUDLineBreakMode))linebreak {NUDMethodNotImplemented(NUDLineBreakMode m);}

- (id (^)(NSString *))highlighted {NUDMethodNotImplemented(NSString *s);}
- (id (^)(id, SEL))tap {NUDMethodNotImplemented(id t,SEL s);}

- (id (^)(NSString *, ...))attachWith {NUDMethodNotImplemented(NSString *s,...);}
- (id (^)(void))attach {NUDMethodNotImplemented(void);}
- (id (^)(void))apply {NUDMethodNotImplemented(void);}
- (id (^)(NSString *, ...))nud_attachWith {return nil;}

@synthesize fontStyles = _fontStyles;
- (NSArray *)fontStyles {
    if (!_fontStyles) {
        _fontStyles = @[@"Bold",@"Regular",@"Medium",@"Light",
                            @"Thin",@"SemiBold",@"UltraLight",@"Italic"];
    }
    return _fontStyles;
}

@end

@implementation NUDAttributedAtachment

- (id (^)(CGFloat, CGFloat))origin {NUDMethodNotImplemented(CGFloat f1,CGFloat f2);}
- (id (^)(CGFloat, CGFloat))size {NUDMethodNotImplemented(CGFloat f1,CGFloat f2);}
- (void (^)(void))attach {NUDMethodNotImplementedReturnVoid(void);}

- (id (^)(CGFloat))vertical {NUDMethodNotImplemented(CGFloat f);}
- (id (^)(NSUInteger))ln {NUDMethodNotImplemented(NSUInteger i);}
- (id (^)(NUDAlignment))aligment {NUDMethodNotImplemented(NUDAlignment a);}

- (void (^)(NSString *,...))attachWith {NUDMethodNotImplementedReturnVoid(NSString *s,...);}
- (void (^)(void))apply {NUDMethodNotImplementedReturnVoid(void);}

- (void (^)(NSString *, ...))nud_attachWith{return nil;}

@end


@implementation NUDAttributeExtension
@end
