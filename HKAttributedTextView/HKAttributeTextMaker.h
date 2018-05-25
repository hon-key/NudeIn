//  HKAttributeTextMaker.h
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
#import "HKAttributeText.h"
#import "HKAttributeAttachment.h"

extern NSString * const kHKAttributeTextAllTextKey;
extern NSString * const kHKAttributeAttachmentAllImageKey;

@interface HKSelector : NSObject

@property (nonatomic,weak) id target;
@property (nonatomic) SEL action;
@property (nonatomic,strong) id obj;

- (NSString *)name;
- (void)callWithIndex:(NSUInteger)index name:(NSString *)name;

@end

@interface HKAttributeTextMaker : NSObject

@property (nonatomic,strong,readonly) NSMutableAttributedString *string;

- (HKAttributeText * (^)(NSString *))text;

// TODO: 富文本可添加自定义图片
- (HKAttributeAttachment * (^)(NSString *))image;
- (HKAttributeAttachment * (^)(UIImage *))imageRes;

- (HKAttributeTextTemplate * (^)(void))allText;
- (HKAttributeAttachmentTemplate * (^)(void))allImage;

- (HKAttributeTextTemplate * (^)(NSString *))textTemplate;
- (HKAttributeAttachmentTemplate * (^)(NSString *))imageTemplate;


@end

@interface HKAttributeTextMaker (ToolsExtension)

- (void)appendString:(NSAttributedString *)string;
- (void)addSelector:(HKSelector *)selector;
- (NSUInteger)indexOfSelector:(HKSelector *)selector;
- (void)emurateSelector:(void(^)(HKSelector *selector,BOOL *stop))handler;
- (void)addTemplate:(id<HKTemplate>)tpl;
- (id<HKTemplate>)templateWithId:(NSString *)identifier;
- (NSArray *)linkSelectors;
- (void)removeLinkSelector:(HKSelector *)sel;

@end
