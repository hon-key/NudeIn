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


@interface NUDTextView ()<UITextViewDelegate>

@property (nonatomic,strong) NUDTextMaker *maker;

@end

@implementation NUDTextView

+ (NUDTextView *)make:(void (^)(NUDTextMaker *))make {
    
    NUDTextView *label = [[NUDTextView alloc] init];
    label.scrollEnabled = NO;
    label.editable = NO;
    label.textContainer.lineFragmentPadding = 0;
    label.textContainerInset = UIEdgeInsetsMake(-1, 0, 0, 0);
    label.delegate = label;
    label.textDragInteraction.enabled = NO;
    
    label.maker = [[NUDTextMaker alloc] init];
    
    if (make) {
        make(label.maker);
    }
    
    label.attributedText = label.maker.string;
    label.linkTextAttributes = @{};
    
    return label;
    
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
    if (update) {
        update(up);
    }
    // override
    [self.maker applyComponentUpdate:up.textComponent];
//    self.attributedText = [up generateString];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    NSLog(@"begin");
    
    NSUInteger index = [self.layoutManager glyphIndexForPoint:[touches.anyObject locationInView:self] inTextContainer:self.textContainer fractionOfDistanceThroughGlyph:nil];
    NSLog(@"%ld",index);
    CGPoint targetLocation = [self.layoutManager locationForGlyphAtIndex:index];
    CGPoint currentLocation = [touches.anyObject locationInView:self];
    CGRect rect = [self.layoutManager boundingRectForGlyphRange:NSMakeRange(index, 1) inTextContainer:self.textContainer];
//    NSLog(@"%@",NSStringFromCGPoint(currentLocation));
//    NSLog(@"%@",NSStringFromCGPoint(targetLocation));
//    NSLog(@"%@",NSStringFromCGRect(rect));
    if (currentLocation.x > rect.origin.x &&
        currentLocation.x < rect.origin.x + rect.size.width) {
         NUDBase *base = [self.maker componentInCharacterLocation:index];
        if ([base isKindOfClass:[NUDText class]]) {
            NUDText *textComp = (NUDText *)base;
            NSLog(@"%@",[textComp.string substringWithRange:NSMakeRange(index - [textComp range].location, 1)]);
        }else if ([base isKindOfClass:[NUDAttachment class]]) {
            NSLog(@"image");
        }
    }
    
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    NSLog(@"moved");
    
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    NSLog(@"ended");
    
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    NSLog(@"cancelled");
    
    [super touchesCancelled:touches withEvent:event];
}


@end
