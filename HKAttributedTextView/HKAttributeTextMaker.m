//
//  HKAttributeTextMaker.m
//  textExample
//
//  Created by 工作 on 2018/5/23.
//  Copyright © 2018年 com.CAI. All rights reserved.
//

#import "HKAttributeTextMaker.h"
#import "HKAttributeText.h"

@implementation HKSelector
- (NSString *)name {
    return NSStringFromSelector(self.action);
}
- (void)callWithIndex:(NSUInteger)index name:(NSString *)name {
    if ([self.target respondsToSelector:self.action]) {
        IMP p = [self.target methodForSelector:self.action];
        void (*method)(id,SEL,id,NSUInteger) = (void *)p;
        method(self.target,self.action,name,index);
    }
}
@end

@implementation HKAttributeTextMaker

- (instancetype)init {
    if (self = [super init]) {
        self.string = [[NSMutableAttributedString alloc] init];
        self.selectors = [NSMutableArray new];
    }
    return self;
}

- (HKAttributeText *(^)(NSString *))text {
    return ^HKAttributeText *(NSString *string) {
        
        HKAttributeText *text = [[HKAttributeText alloc] initWithFather:self];
        text.string = string;
        return text;
        
    };
}

- (HKAttributeTextTemplate *(^)(NSString *))textTemplate {
    return ^HKAttributeTextTemplate *(NSString *string) {
        HKAttributeTextTemplate *template = [HKAttributeTextTemplate new];
        return template;
    };
}


- (void)appendString:(NSAttributedString *)string {
    [self.string appendAttributedString:string];
}

@end
