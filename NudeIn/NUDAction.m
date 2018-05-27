//
//  NUDAction.m
//  textExample
//
//  Created by 工作 on 2018/5/27.
//  Copyright © 2018年 com.CAI. All rights reserved.
//

#import "NUDAction.h"

@implementation NUDAction

@end

@implementation NUDLinkAction

@end

@implementation NUDAttachmentAction

@end

@implementation NUDSelector
- (NSString *)name {
    return NSStringFromSelector(self.action);
}

- (void)performAction:(NUDAction *)action {
    if ([self.target respondsToSelector:self.action]) {
        IMP p = [self.target methodForSelector:self.action];
        void (*method)(id,SEL,NUDAction *) = (void *)p;
        method(self.target,self.action,action);
    }
}

@end
