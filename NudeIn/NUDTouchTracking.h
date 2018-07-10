//
//  NUDTouchTracking.h
//  textExample
//
//  Created by Ruite Chen on 2018/6/14.
//  Copyright © 2018年 com.CAI. All rights reserved.
//

#import "NudeIn-Prefix.h"

@class NUDBase,NUDTouch;

@protocol NUDTouchTrackingDelegate;

@interface NUDTouchTracking : NSObject

@property (nonatomic,weak) UITextView<NUDTouchTrackingDelegate> *delegate; // 必须是你需要跟踪的 UITextView, 否则结果 undefine
@property (nonatomic,assign) NSTimeInterval timeoutTime;

/**
 * 开始一个触摸跟踪任务，初始化各项数据，如果该touch正在被track，那么返回nil，如果要获取正在track中的touch，应该通过currentNUDTouch来获取
 */
- (NUDTouch *)track:(UITouch *)touch;

- (void)endTracking:(UITouch *)touch; // 执行结束的回调和清理操作，如果需要，cancel touchEvent

- (NUDTouch *)currentNUDTouch:(UITouch *)touch;

@end


@interface NUDTouch : NSObject

@property (nonatomic,assign,readonly) CGRect glyphRect;
@property (nonatomic,assign,readonly) NSUInteger glyphIndex;
@property (nonatomic,assign,readonly) CGPoint currentLocation;
@property (nonatomic,assign,readonly) CGPoint originalLocation;

@property (nonatomic,strong) NUDBase *comp;
@property (nonatomic,strong) NUDBase *originComp;

- (instancetype)initWithTracking:(NUDTouchTracking *)tracking;

@end

@protocol NUDTouchTrackingDelegate <NSObject>

@optional
- (void)touchTrackingTimeout;


@end
