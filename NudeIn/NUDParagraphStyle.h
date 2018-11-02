//
//  NUDParagraphStyle.h
//  textExample
//
//  Created by Ruite Chen on 2018/11/1.
//  Copyright © 2018 com.CAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NUDParagraphStyle : NSMutableParagraphStyle

@end

@interface NSMutableParagraphStyle (NUDParagraphStyle)

- (void)nud_mergeParagraphStyle:(NSMutableParagraphStyle *)paragraphStyle;

@end

