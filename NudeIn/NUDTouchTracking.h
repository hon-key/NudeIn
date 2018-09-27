//  NUDTouchTracking.h
//  Copyright (c) 2018 HJ-Cai
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
