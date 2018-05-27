//
//  NUDAction.h
//  textExample
//
//  Created by 工作 on 2018/5/27.
//  Copyright © 2018年 com.CAI. All rights reserved.
//

#import "NudeIn-Prefix.h"

@interface NUDAction : NSObject

@property (nonatomic,assign) NSUInteger index;

@end

@interface NUDLinkAction : NUDAction

@property (nonatomic,copy) NSString *string;
@property (nonatomic,copy) NSString *url;

@end

@interface NUDAttachmentAction : NUDAction

@property (nonatomic,strong) UIImage *image;

@end


@interface NUDSelector : NSObject

@property (nonatomic,weak) id target;
@property (nonatomic) SEL action;
@property (nonatomic,strong) id obj;

- (NSString *)name;
- (void)performAction:(NUDAction *)action;

@end
