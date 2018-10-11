//
//  NUDInnerText+.h
//  textExample
//
//  Created by Ruite Chen on 2018/10/11.
//  Copyright © 2018 com.CAI. All rights reserved.
//

@interface NUDInnerText ()

@property (nonatomic,weak) NUDAttribute *searchingText;

@property (nonatomic,strong,readwrite) NSMutableArray <NSValue *> *mutableRanges;

- (instancetype)initWithSearchingText:(NUDAttribute *)searchingText;

- (void)match;

- (void)addAttributesTo:(NSMutableAttributedString *)mutableAttributedString;

@end

@interface NUDInnerStrictMatchingText ()

- (instancetype)initWithKeyString:(NSString *)keyString searchingText:(NUDAttribute *)searchingText;

@end


