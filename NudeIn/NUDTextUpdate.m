//  NUDTextUpdate.m
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

#import "NUDTextUpdate.h"
#import "NUDAttribute.h"
#import "NUDText.h"
#import "NUDAttachment.h"
#import "NUDTextMaker.h"
#import <objc/runtime.h>
#import "NUDAction.h"

@interface NUDTextUpdate ()

@property (nonatomic,strong) NSMutableArray *components;

@end

@implementation NUDTextUpdate

- (NUDBase *(^)(NSUInteger))comp {
    return ^NUDBase * (NSUInteger index) {
        if (index < self.components.count) {
            NUDBase *newObject = [self.components[index] copy];
            objc_setAssociatedObject(newObject, @"storedCompIndex", @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            return newObject;
        }else {
            return [NUDBase new];
        }
    };
}

- (void)setComponents:(NSMutableArray *)components {
    _components = components;
    for (NUDBase *comp in _components) {
        if ([comp isKindOfClass:[NUDText class]]) {
            ((NUDText *)comp).update = self;
        }else if ([comp isKindOfClass:[NUDAttributedAtachment class]]) {
            ((NUDAttachment *)comp).update = self;
        }else {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"components has unkown object" userInfo:nil];
        }
    }
}

@end


@implementation NUDTextUpdate (UpdateHanlder)

- (instancetype)initWithComponents:(NSMutableArray *)components {
    if (self = [super init]) {
        self.components = components;
    }
    return self;
}

- (void)applyComp:(NUDBase *)comp {
    if (comp) {
        NSNumber *index = objc_getAssociatedObject(comp, @"storedCompIndex");
        if (index && index.unsignedIntegerValue < self.components.count) {
            NUDBase *originalBase = [self.components objectAtIndex:index.unsignedIntegerValue];
            [originalBase mergeComp:comp];
        }
    }
}

- (NSAttributedString *)generateString {
    if (!self.components) {
        return nil;
    }
    return [[self class] generateWithComponents:self.components];
}

+ (NSAttributedString *)nud_generateStringWith:(NUDBase *)comp maker:(NUDTextMaker *)maker {
    
    return [self generateWithComponents:maker.textComponents];
}

+ (NSMutableAttributedString *)generateWithComponents:(NSArray *)components {
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    
    for (NUDBase *comp in components) {
        if ([comp isKindOfClass:[NUDText class]]) {
            
            [NUDSelector perFormSelectorWithString:@"clearLineFeed" target:comp];
            [NUDSelector perFormSelectorWithString:@"appendLineFeed" target:comp];
            
        }else if ([comp isKindOfClass:[NUDAttachment class]]) {}
        
        NSAttributedString *compString = [comp attributedString];
        NSUInteger start = string.length;
        [string appendAttributedString:compString];
        NSRange range = NSMakeRange(start, compString.length);
        Ivar ivar = class_getInstanceVariable(NSClassFromString(@"NUDBase"), "_range");
        object_setIvar(comp, ivar, NUD_VALUE_OF_RANGE(range));
    }
    
    return string;
    
}

- (NSMutableArray *)textComponent {
    return [self.components copy];
}

@end
