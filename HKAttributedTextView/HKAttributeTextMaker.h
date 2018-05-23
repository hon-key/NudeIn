//
//  HKAttributeTextMaker.h
//  textExample
//
//  Created by 工作 on 2018/5/23.
//  Copyright © 2018年 com.CAI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HKAttributeText.h"
#import "HKAttributeTextTemplate.h"

@interface HKAttributeAttachment : NSObject
@end


@interface HKAttributeAttachmentTemplate : NSObject

@end

@interface HKSelector : NSObject

@property (nonatomic,weak) id target;
@property (nonatomic) SEL action;
@property (nonatomic,strong) id obj;

- (NSString *)name;
- (void)callWithIndex:(NSUInteger)index name:(NSString *)name;

@end

@interface HKAttributeTextMaker : NSObject

- (HKAttributeText * (^)(NSString *))text;

// TODO: 富文本可添加自定义图片
- (HKAttributeAttachment * (^)(NSString *))image;
- (HKAttributeAttachment * (^)(UIImage *))imageRes;

// TODO: 做一个全局设定功能，设定一次，接下来的make操作都会应用这些操作
- (HKAttributeTextTemplate * (^)(void))allText;
- (HKAttributeAttachmentTemplate * (^)(void))allImage;

// TODO: 做一个模板功能，可以在attach的时候指定相应模板，自动应用其模板
- (HKAttributeTextTemplate * (^)(NSString *))textTemplate;
- (HKAttributeAttachmentTemplate * (^)(NSString *))imageTemplate;

@property (nonatomic,strong) NSMutableAttributedString *string;
@property (nonatomic,strong) NSMutableArray<HKSelector *> *selectors;

- (void)appendString:(NSAttributedString *)string;

@end
