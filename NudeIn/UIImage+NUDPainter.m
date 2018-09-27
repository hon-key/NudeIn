//  UIImage+Painter.m
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

#import "UIImage+NUDPainter.h"

@implementation UIImage (NUDPainter)

+ (instancetype)nud_imageWithColor:(UIColor *)color
                          size:(CGSize)size
                        radius:(CGFloat)radius
                       quality:(NUDImageQuality)quality {
    
    size = CGSizeMake(size.width * quality, size.height * quality);
    UIGraphicsBeginImageContext(size);
    
    UIBezierPath *roundRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:radius * quality];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, roundRect.CGPath);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextSetLineWidth(ctx, 0.1);
    
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *image = [[UIImage alloc] initWithData:UIImagePNGRepresentation(theImage) scale:quality];
   
    UIGraphicsEndImageContext();
    return image;
}

@end
