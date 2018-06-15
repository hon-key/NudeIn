//
//  NUDTouchTracking.m
//  textExample
//
//  Created by Ruite Chen on 2018/6/14.
//  Copyright © 2018年 com.CAI. All rights reserved.
//

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
