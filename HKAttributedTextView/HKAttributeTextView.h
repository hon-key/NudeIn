//
//  HKAttributeTextLabel.h
//  mynetvue
//
//  Created by 工作 on 2018/5/11.
//  Copyright © 2018年 Netviewtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HKAttributeFontStyle) {
    HKBold, HKRegular, HKMedium, HKLight, HKThin, HKSemiBold, HKUltraLight, HKItalic, 
};

@interface HKAttributeText : NSObject

// font
- (HKAttributeText * (^)(NSUInteger))font;
- (HKAttributeText * (^)(NSString *,NSUInteger))fontName;
- (HKAttributeText * (^)(UIFont *))fontRes;
- (HKAttributeText * (^)(HKAttributeFontStyle))fontStyle;

- (HKAttributeText * (^)(UIColor *))color;
- (HKAttributeText * (^)(UIColor *))mark;
- (HKAttributeText * (^)(NSUInteger,UIColor *))hollow;
- (HKAttributeText * (^)(id target,SEL action))link;
- (HKAttributeText * (^)(UIColor *))_;
- (HKAttributeText * (^)(UIColor *))deprecated;
- (HKAttributeText * (^)(CGFloat))skew;
- (HKAttributeText * (^)(CGFloat))kern;
- (HKAttributeText * (^)(void))attach;

@end

@interface HKAttributeAttachment : NSObject

@end

@interface HKAttributeTextMaker : NSObject

- (HKAttributeText * (^)(NSString *))text;
- (HKAttributeAttachment * (^)(NSString *))image;
- (HKAttributeAttachment * (^)(UIImage *))imageRes;

@end

@interface HKAttributeTextView : UITextView

+ (HKAttributeTextView *)make:(void (^)(HKAttributeTextMaker *make))make;

@end
