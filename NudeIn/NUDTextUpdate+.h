//
//  NUDTextUpdate+.h
//  textExample
//
//  Created by Ruite Chen on 2018/10/11.
//  Copyright © 2018 com.CAI. All rights reserved.
//

#import "NudeIn-Prefix.h"

@class NUDText,NUDAttachment,NUDBase,NUDTextMaker;

@interface NUDTextUpdate ()

@property (nonatomic,strong) NSMutableArray *components;

@end

@interface NUDTextUpdate (UpdateHanlder)

- (instancetype)initWithComponents:(NSMutableArray *)components;

- (void)applyComp:(NUDBase *)comp;

- (NUDBase *)originalBaseWithComp:(NUDBase *)comp;

- (NSAttributedString *)generateString;

+ (NSMutableAttributedString *)generateStringWithComponents:(NSArray *)components;

@end

