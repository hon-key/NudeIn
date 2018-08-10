//  NUDTextView.m
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

#import "NUDTextView.h"
#import "NUDText.h"
#import "NUDTextMaker.h"
#import "NUDAction.h"
#import "NUDAttachment.h"
#import "NUDTextUpdate.h"
#import "NUDTouchTracking.h"
#import "NUDAction.h"
#import <objc/runtime.h>


@interface NUDTextView ()
<
UITextViewDelegate,
NSLayoutManagerDelegate,
NUDTouchTrackingDelegate
>

@property (nonatomic,strong) NUDTextMaker *maker;
@property (nonatomic,strong) NUDTouchTracking *touchTracking;

@end

@implementation NUDTextView

+ (NUDTextView *)make:(void (^)(NUDTextMaker *))make {
    
    NUDTextView *label = [[NUDTextView alloc] init];
    label.scrollEnabled = NO;
    label.editable = NO;
    label.textContainer.lineFragmentPadding = 0;
    label.textContainerInset = UIEdgeInsetsMake(-1, 0, 0, 0);
    label.delegate = label;
    label.layoutManager.delegate = label;
    label.selectable = NO;
    if (@available(iOS 11.0, *)) {
        label.textDragInteraction.enabled = NO;
    }
    
    label.maker = [[NUDTextMaker alloc] init];
    make(label.maker);
    
    label.attributedText = label.maker.string;
    label.linkTextAttributes = @{};
    
    label.touchTracking = [[NUDTouchTracking alloc] init];
    label.touchTracking.delegate = label;
    label.touchTracking.timeoutTime = 3;
    
    return label;
    
}

- (void)remake:(void (^)(NUDTextMaker *))make {
    self.maker = [[NUDTextMaker alloc] init];
    make(self.maker);
    self.attributedText = self.maker.string;
}

- (void)p {
    [self.maker p];
}


// TODO: append
- (NUDTextView *)append:(void (^)(NUDTextMaker *))make {
    return nil;
}

- (void)update:(void (^)(NUDTextUpdate *))update {
    NUDTextUpdate *up = [[NUDTextUpdate alloc] initWithComponents:[self.maker.textComponents mutableCopy]];
    update(up);
    [self.maker applyComponentUpdate:up.textComponent];
    self.attributedText = [up generateString];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    NSArray *urlComp = [URL.absoluteString componentsSeparatedByString:@"://"];
    NSArray *keys;
    if (urlComp.count >= 2) {
        keys = [urlComp[1] componentsSeparatedByString:@"&"];
    }
    
    if (keys.count >= 3) {
        [self.maker emurateSelector:^(NUDSelector *selector,BOOL *stop) {
            if ([[selector name] isEqualToString:keys[1]]) {
                NUDLinkAction *action = [NUDLinkAction new];
                action.string = [keys[0] stringByRemovingPercentEncoding];
                action.index = ((NSString *)keys[2]).integerValue;
                [selector performAction:action];
                *stop = YES;
            }
        }];
    }
    
    
    return NO;
    
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    return NO;
}


//NSLog(@"%@",textComp.string);
//NSLog(@"%@",[textComp.string substringWithRange:NSMakeRange(index - [textComp range].location, 1)]);
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NUDTouch *nTouch = [self.touchTracking track:touches.anyObject];

    if (nTouch) {
//        NSLog(@"<begin> %@",nTouch);
//        NSLog(@"%@",NSStringFromCGRect(nTouch.glyphRect));
        if (CGRectContainsPoint(nTouch.glyphRect, nTouch.currentLocation)) {
            nTouch.comp = [self.maker componentInCharacterLocation:nTouch.glyphIndex];
            if ([nTouch.comp isKindOfClass:[NUDText class]]) {
                
                NUDText *textComp = (NUDText *)nTouch.comp;
                nTouch.originComp = [nTouch.comp copy];
                NSString *highlightedTpl = [textComp valueForKey:@"highlightedTpl"];
                NUDTextTemplate *template = [self.maker templateWithId:highlightedTpl];
                NUDText *tplText = [template valueForKey:@"parasiticalObj"];
                [textComp mergeComp:tplText];
                [textComp setValue:((NUDText *)nTouch.originComp).string forKey:@"string"];

                self.attributedText = [NUDTextUpdate nud_generateStringWith:textComp maker:self.maker];
                
            }else if ([nTouch.comp isKindOfClass:[NUDAttachment class]]) {
//                NSLog(@"image");
            }
        }
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NUDTouch *nTouch = [self.touchTracking currentNUDTouch:touches.anyObject];
    if (!nTouch) {
        return;
    }
    
//    NSLog(@"<moved> %@",nTouch);
//    NSLog(@"%@",NSStringFromCGRect(nTouch.glyphRect));
    if (CGRectContainsPoint(nTouch.glyphRect, nTouch.currentLocation) &&
        [self.maker componentInCharacterLocation:nTouch.glyphIndex] == nTouch.comp) {
        
//        NSLog(@"in!!");
        if ([nTouch.comp isKindOfClass:[NUDText class]]) {
            
            NUDText *textComp = (NUDText *)nTouch.comp;
            NSString *highlightedTpl = [textComp valueForKey:@"highlightedTpl"];
            NUDTextTemplate *template = [self.maker templateWithId:highlightedTpl];
            NUDText *tplText = [template valueForKey:@"parasiticalObj"];
            [textComp mergeComp:tplText];
            [textComp setValue:((NUDText *)nTouch.originComp).string forKey:@"string"];
            
            self.attributedText = [NUDTextUpdate nud_generateStringWith:nTouch.comp maker:self.maker];
        }else {}
        
    }else {
        
//        NSLog(@"out!!");
        if ([nTouch.comp isKindOfClass:[NUDText class]]) {
            [((NUDText *)nTouch.comp) mergeComp:nTouch.originComp];
            self.attributedText = [NUDTextUpdate nud_generateStringWith:nTouch.comp maker:self.maker];
        }else {}
        
    }
    
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if ([touches allObjects].count > 1) {
        for (UITouch *touch in [touches allObjects]) {
            [self touchesEnded:[[NSSet alloc] initWithObjects:touch, nil] withEvent:event];
        }
        return;
    }
    
    NUDTouch *nTouch = [self.touchTracking currentNUDTouch:touches.anyObject];
    if (nTouch) {
//        NSLog(@"<end> %@",nTouch);
//        NSLog(@"%ld",[touches allObjects].count);
        if ([nTouch.comp isKindOfClass:[NUDText class]]) {
            [((NUDText *)nTouch.comp) mergeComp:nTouch.originComp];
            self.attributedText = [NUDTextUpdate nud_generateStringWith:nTouch.comp maker:self.maker];
        }else {}
    }
//    NSLog(@"ended");
    [self.touchTracking endTracking:touches.anyObject];
    
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    NSLog(@"cancelled");
    NSArray *touchesArray = [touches allObjects];
    for (UITouch *touch in touchesArray) {
        NSSet *set = [[NSSet alloc] initWithObjects:touch, nil];
        [self touchesEnded:set withEvent:event];
    }
    
    [super touchesCancelled:touches withEvent:event];
}

@end
