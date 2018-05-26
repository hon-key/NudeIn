//
//  HKAttributeAttachment.h
//  textExample
//
//  Created by 工作 on 2018/5/24.
//  Copyright © 2018年 com.CAI. All rights reserved.
//

#import "HKAttribute.h"

@class HKAttributedTextMaker;
@class HKAttributedAttachment;
@interface HKAttributedAttachment : HKAttachment<HKAttributedAttachment *>

@property (nonatomic,strong) UIImage *image;

- (instancetype)initWithFather:(HKAttributedTextMaker *)maker;

@end


@class HKAttributedAttachmentTemplate;
@interface HKAttributedAttachmentTemplate : HKAttachment<HKAttributedAttachmentTemplate *> <HKTemplate>

@end
