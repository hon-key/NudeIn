//
//  HKAttributeTextLabel.h
//  mynetvue
//
//  Created by 工作 on 2018/5/11.
//  Copyright © 2018年 Netviewtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKAttributeText : NSObject

- (HKAttributeText * (^)(NSString *))text;
- (HKAttributeText * (^)(UIColor *))color;
- (HKAttributeText * (^)(id target,SEL action))link;
- (HKAttributeText * (^)(NSUInteger))font;
- (HKAttributeText *(^)(void))attach;

@end

@interface HKAttributeTextMaker : NSObject

- (HKAttributeText * (^)(NSString *))text;
- (HKAttributeText * (^)(UIColor *))color;
- (HKAttributeText * (^)(id target,SEL action))link;
- (HKAttributeText * (^)(NSUInteger))font;

@end

@interface HKAttributeTextView : UITextView

+ (HKAttributeTextView *)make:(void (^)(HKAttributeTextMaker *make))make;

@end
