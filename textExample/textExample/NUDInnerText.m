//
//  NUDInnerText.m
//  textExample
//
//  Created by Ruite Chen on 2018/10/10.
//  Copyright © 2018 com.CAI. All rights reserved.
//

#import "NUDInnerText.h"

@interface NUDInnerText ()

@property (nonatomic,strong,readwrite) NSMutableArray <NSValue *> *mutableRanges;

@end

@implementation NUDInnerText

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"init method shouldn't be used in NUDInnerText, please use -initWithKeyString:searchTarget: instead" userInfo:nil];
    return [self initWithKeyString:@"" searchTarget:@""];
}
- (instancetype)initWithKeyString:(NSString *)keyString searchTarget:(NSString *)searchString {
    NSParameterAssert(keyString);
    NSParameterAssert(searchString);
    if (self = [super init]) {
        _keyString = keyString;
        _searchString = searchString;
        _mutableRanges = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark -
- (void)strictMatchString {
    [self.mutableRanges removeAllObjects];
    [self strictMatchStringWithKeyString:self.keyString SearchString:self.searchString];
    
}
- (void)strictMatchStringWithKeyString:(NSString *)keyString SearchString:(NSString *)searchString {
    NSRange range = [searchString rangeOfString:keyString options:NSCaseInsensitiveSearch];
    if (!NSEqualRanges(range, NSMakeRange(NSNotFound, 0))) {
        searchString = [searchString stringByReplacingCharactersInRange:range withString:@""];
        for (NSValue *rangeValue in self.mutableRanges) {
            NSRange storedRange;
            [rangeValue getValue:&storedRange];
            range.location += storedRange.length;
        }
        [self.mutableRanges addObject:NUD_VALUE_OF_RANGE(range)];
        [self strictMatchStringWithKeyString:keyString SearchString:searchString];
    }
}

#pragma mark -

- (NSArray<NSValue *> *)ranges {
    return [self.mutableRanges copy];
}

@end
