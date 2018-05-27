//  NUDTextMaker.h
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



#import "NudeIn-Prefix.h"
@class NUDText,NUDAttachment,NUDTextTemplate,NUDAttachmentTemplate;
@protocol NUDTemplate;

extern NSString * const kNUDTextAllText;
extern NSString * const kNUDAttachmentAllImageKey;

@interface NUDSelector : NSObject

@property (nonatomic,weak) id target;
@property (nonatomic) SEL action;
@property (nonatomic,strong) id obj;

- (NSString *)name;
- (void)callWithIndex:(NSUInteger)index name:(NSString *)name;

@end

@interface NUDTextMaker : NSObject

@property (nonatomic,strong,readonly) NSMutableAttributedString *string;

- (NUDText * (^)(NSString *))text;

// TODO: 富文本可添加自定义图片
- (NUDAttachment * (^)(NSString *))image;
- (NUDAttachment * (^)(UIImage *))imageRes;

- (NUDTextTemplate * (^)(void))allText;
- (NUDAttachmentTemplate * (^)(void))allImage;

- (NUDTextTemplate * (^)(NSString *))textTemplate;
- (NUDAttachmentTemplate * (^)(NSString *))imageTemplate;


@end

@interface NUDTextMaker (ToolsExtension)

- (void)appendString:(NSAttributedString *)string;
- (void)addSelector:(NUDSelector *)selector;
- (NSUInteger)indexOfSelector:(NUDSelector *)selector;
- (void)emurateSelector:(void(^)(NUDSelector *selector,BOOL *stop))handler;
- (void)addTemplate:(id<NUDTemplate>)tpl;
- (id<NUDTemplate>)templateWithId:(NSString *)identifier;
- (NSArray *)linkSelectors;
- (void)removeLinkSelector:(NUDSelector *)sel;

@end
