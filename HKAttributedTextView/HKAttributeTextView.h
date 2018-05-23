//  HKAttributeTextLabel.h
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
