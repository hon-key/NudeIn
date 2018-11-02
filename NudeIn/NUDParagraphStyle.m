//
//  NUDParagraphStyle.m
//  textExample
//
//  Created by Ruite Chen on 2018/11/1.
//  Copyright © 2018 com.CAI. All rights reserved.
//

#import "NUDParagraphStyle.h"
#import <objc/runtime.h>

@interface NUDParagraphStyle ()
- (void)addTag:(NSString *)key;
- (NSArray<NSString *> *)keyTags;
@end

@implementation NUDParagraphStyle
- (void)setLineSpacing:(CGFloat)lineSpacing {
    [super setLineSpacing:lineSpacing];
    [self addTag:@"lineSpacing"];
}
- (void)setParagraphSpacing:(CGFloat)paragraphSpacing {
    [super setParagraphSpacing:paragraphSpacing];
    [self addTag:@"paragraphSpacing"];
}
- (void)setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore {
    [super setParagraphSpacingBefore:paragraphSpacingBefore];
    [self addTag:@"paragraphSpacingBefore"];
}
- (void)setAlignment:(NSTextAlignment)alignment {
    [super setAlignment:alignment];
    [self addTag:@"alignment"];
}
- (void)setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent {
    [super setFirstLineHeadIndent:firstLineHeadIndent];
    [self addTag:@"firstLineHeadIndent"];
}
- (void)setHeadIndent:(CGFloat)headIndent {
    [super setHeadIndent:headIndent];
    [self addTag:@"headIndent"];
}
- (void)setTailIndent:(CGFloat)tailIndent {
    [super setTailIndent:tailIndent];
    [self addTag:@"tailIndent"];
}
- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    [super setLineBreakMode:lineBreakMode];
    [self addTag:@"lineBreakMode"];
}
- (void)setMaximumLineHeight:(CGFloat)maximumLineHeight {
    [super setMaximumLineHeight:maximumLineHeight];
    [self addTag:@"maximumLineHeight"];
}
- (void)setMinimumLineHeight:(CGFloat)minimumLineHeight {
    [super setMinimumLineHeight:minimumLineHeight];
    [self addTag:@"minimumLineHeight"];
}
- (void)setBaseWritingDirection:(NSWritingDirection)baseWritingDirection {
    [super setBaseWritingDirection:baseWritingDirection];
    [self addTag:@"baseWritingDirection"];
}
- (void)setLineHeightMultiple:(CGFloat)lineHeightMultiple {
    [super setLineHeightMultiple:lineHeightMultiple];
    [self addTag:@"lineHeightMultiple"];
}
- (void)setHyphenationFactor:(float)hyphenationFactor {
    [super setHyphenationFactor:hyphenationFactor];
    [self addTag:@"hyphenationFactor"];
}

- (void)addTag:(NSString *)key {
    NSMutableArray<NSString *> *keys = objc_getAssociatedObject(self, "com.NudeIn.NUDParagraphStyle.keys");
    if (!keys) {
        keys = [NSMutableArray new];
        objc_setAssociatedObject(self, "com.NudeIn.NUDParagraphStyle.keys", keys, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [keys addObject:key];
}
- (NSArray<NSString *> *)keyTags {
    NSArray<NSString *> *keys = objc_getAssociatedObject(self, "com.NudeIn.NUDParagraphStyle.keys");
    return keys;
}
@end

@implementation NSMutableParagraphStyle (NUDParagraphStyle)

- (void)nud_mergeParagraphStyle:(NSMutableParagraphStyle *)paragraphStyle {
    if ([paragraphStyle isKindOfClass:[NUDParagraphStyle class]]) {
        for (NSString *key in ((NUDParagraphStyle *)paragraphStyle).keyTags) {
            [self setValue:[paragraphStyle valueForKey:key] forKey:key];
        }
    }else {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"NSMutableParagraphStyle is not a NUDParagraphStyle" userInfo:nil];
    }
}

@end
