//
//  NUDInnerText.h
//  textExample
//
//  Created by Ruite Chen on 2018/10/10.
//  Copyright © 2018 com.CAI. All rights reserved.
//

#import "NUDAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@interface NUDInnerText : NSObject

@property (nonnull,nonatomic,strong,readonly) NSArray <NSValue *> *ranges;

@property (nonnull,nonatomic,copy,readonly) NSString *keyString;

@property (nonnull,nonatomic,copy,readonly) NSString *searchString;

@property (nullable,nonatomic,copy) NSMutableDictionary *attributes;

- (instancetype)initWithKeyString:(nonnull NSString *)keyString searchTarget:(nonnull NSString *)searchString NS_DESIGNATED_INITIALIZER;

- (void)strictMatchString;

@end

NS_ASSUME_NONNULL_END
