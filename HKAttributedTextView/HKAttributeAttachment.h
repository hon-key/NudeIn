//
//  HKAttributeAttachment.h
//  textExample
//
//  Created by 工作 on 2018/5/24.
//  Copyright © 2018年 com.CAI. All rights reserved.
//

#import "HKAttribute.h"

@class HKAttributeTextMaker;
@class HKAttributeAttachment;
@interface HKAttributeAttachment : HKAttachment<HKAttributeAttachment *>

@property (nonatomic,strong) UIImage *image;

- (instancetype)initWithFather:(HKAttributeTextMaker *)maker;

@end


@class HKAttributeAttachmentTemplate;
@interface HKAttributeAttachmentTemplate : HKAttachment<HKAttributeAttachmentTemplate *> <HKTemplate>

@end
