//  NUDTouchTracking.m
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

#import "NUDTouchTracking.h"
#import "NUDAttribute.h"

@interface NUDTouchTracking ()

@property (nonatomic,strong) NSMutableArray<NUDTouch *> *touches;

@end

@interface NUDTouch ()

@property (nonatomic,weak) NUDTouchTracking *tracking;

@property (nonatomic,strong) UITouch *relativeTouch;

@property (nonatomic,assign,readwrite) CGPoint originalLocation;

@end

@implementation NUDTouchTracking

- (instancetype)init {
    if (self = [super init]) {
        
        _touches = [NSMutableArray new];
        _timeoutTime = 2.5;
        
    }
    return self;
}

- (NUDTouch *)track:(UITouch *)touch {
    
    if (!self.delegate || !touch) return nil;
    
    NUDTouch *nTouch = [[NUDTouch alloc] initWithTracking:self];
    nTouch.relativeTouch = touch;
    
    // init
    nTouch.originalLocation = nTouch.currentLocation;
    
    if (![self.touches containsObject:nTouch]) {
        [self.touches addObject:nTouch];
        return nTouch;
    }
    
    return nil;
}

- (void)endTracking:(UITouch *)touch {
    
    static NUDTouch *nTouch;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nTouch = [[NUDTouch alloc] initWithTracking:self];
    });
    nTouch.relativeTouch = touch;
    
    // dealloc
    
    [self.touches removeObject:nTouch];
    
}

- (NUDTouch *)currentNUDTouch:(UITouch *)touch {
    for (NUDTouch *nTouch in self.touches) {
        if (nTouch.relativeTouch == touch) {
            return nTouch;
        }
    }
    return nil;
}

@end


@implementation NUDTouch

- (instancetype)initWithTracking:(NUDTouchTracking *)tracking {
    if (self = [super init]) {
        _tracking = tracking;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"nTouch:<%@: %p>,index: %ld,location: %@",
            [self class],self,
            (unsigned long)self.glyphIndex,
            NSStringFromCGPoint(self.currentLocation)];
}

- (NSUInteger)hash {
    return [self.relativeTouch hash];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[NUDTouch class]]) {
        return (self.relativeTouch == ((NUDTouch *)object).relativeTouch);
    }
    return NO;
}

- (NSUInteger)glyphIndex {
    if (self.tracking.delegate && self.relativeTouch) {
        return [self.tracking.delegate.layoutManager glyphIndexForPoint:self.currentLocation inTextContainer:self.tracking.delegate.textContainer fractionOfDistanceThroughGlyph:nil];
    }
    return NSUIntegerMax;
}

- (CGRect)glyphRect {
    if (self.tracking.delegate && self.relativeTouch) {
        return [self.tracking.delegate.layoutManager boundingRectForGlyphRange:NSMakeRange(self.glyphIndex, 1) inTextContainer:self.tracking.delegate.textContainer];
    }
    return CGRectZero;
}

- (CGPoint)currentLocation {
    
    if (self.tracking.delegate && self.relativeTouch) {
        return [self.relativeTouch locationInView:self.tracking.delegate];
    }
    return CGPointZero;
}

@end
