//  NUDTextView.h
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

@class NUDText,NUDTextMaker,NUDTextUpdate;
//TODO:增加可自定义方法的功能
//TODO:增加update功能

@interface NUDTextView : UITextView

+ (NUDTextView *)make:(void (^)(NUDTextMaker *make))make;

// TODO: 提供一个可以给现有实例继续添加组件的功能
- (NUDTextView *)append:(void (^)(NUDTextMaker *make))make;

- (void)remake:(void (^)(NUDTextMaker *make))make;

// TODO: 能够更新 NUDTextView 对象
- (void)update:(void (^)(NUDTextUpdate *update))update;

- (void)p;


@end
