//
//  HKAttributeText.h
//  textExample
//
//  Created by 工作 on 2018/5/23.
//  Copyright © 2018年 com.CAI. All rights reserved.
//

#import "HKAttribute.h"

@class HKAttributeTextMaker;
@class HKAttributeText;
@interface HKAttributeText : HKAttribute<HKAttributeText *>

@property (nonatomic,copy) NSString *string;
@property (nonatomic,strong) NSMutableDictionary<NSAttributedStringKey, id> *attributes;
@property (nonatomic,weak) HKAttributeTextMaker *father;

- (instancetype)initWithFather:(HKAttributeTextMaker *)maker;

@end
