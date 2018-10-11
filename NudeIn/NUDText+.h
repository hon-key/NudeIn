//
//  NUDText+.h
//  textExample
//
//  Created by Ruite Chen on 2018/10/11.
//  Copyright © 2018 com.CAI. All rights reserved.
//

#import "NUDAttribute.h"
#import "NUDText.h"
#import "NUDAction.h"

@class NUDShadowTag,NUDTextUpdate;

@interface NUDText ()

@property (nonatomic,weak) NUDTextUpdate *update;

@property (nonatomic,copy,readwrite) NSString *string;

@property (nonatomic,strong) NSMutableDictionary<NSAttributedStringKey, id> *attributes;

@property (nonatomic,weak) NUDTextMaker *father;

@property (nonatomic,strong) NSMutableArray<NUDInnerText *> *innerTexts;

@property (nonatomic,copy) NSString *highlightedTpl;

@property (nonatomic,strong) NUDSelector *selector;

@property (nonatomic,assign) NSUInteger countOfLinefeed;

@property (nonatomic,strong) NUDShadowTag *shadowTag;

- (NUDTextTemplate *)templateWithIdentifiers:(NSArray<NSString *> *)identifiers;

- (void)applyTemplate:(NUDTextTemplate *)tpl;

@end

#pragma mark -
@interface NUDTextTemplate ()

@property (nonatomic,strong) NUDText *parasiticalObj;

@property (nonatomic,strong) NUDSelector *tplLinkSelector;

@end

#pragma mark -
@interface NUDShadowTag : NSObject <NSCopying>

@property (nonatomic,assign) CGSize shadowOffset;

@property (nonatomic,assign) CGFloat shadowBlur;

@property (nonatomic,assign) UIColor *shadowColor;


- (void)mergeShadowTag:(NUDShadowTag *)shadowTag;

- (NSShadow *)makeShadow;

@end

#pragma mark -
@interface NUDTextExtension ()

@property (nonatomic,strong) NUDAttribute *text;

@end


