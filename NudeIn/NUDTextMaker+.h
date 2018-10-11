//
//  NSObject+NUDTextMaker_.h
//  textExample
//
//  Created by Ruite Chen on 2018/10/11.
//  Copyright © 2018 com.CAI. All rights reserved.
//

#import "NudeIn-Prefix.h"

@interface NUDTextMaker ()

@property (nonatomic,strong,readwrite) NSMutableAttributedString *string;
@property (nonatomic,strong) NSMutableArray<NUDSelector *> *selectors;
@property (nonatomic,strong) NSMutableArray<id<NUDTemplate>> *templates;
@property (nonatomic,strong) NSMutableArray<NUDBase *> *components;

@end

@interface NUDTextMaker (ToolsExtension)



- (NSRange)appendString:(NSAttributedString *)string;
- (void)storeTextComponent:(NUDBase *)component;
- (BOOL)containsComponent:(NUDBase *)component;
- (NUDBase *)componentInCharacterLocation:(NSUInteger)location;
- (void)applyComponentUpdate:(NSArray<NUDBase *> *)components;
- (void)addSelector:(NUDSelector *)selector;
- (NSUInteger)indexOfSelector:(NUDSelector *)selector;
- (void)emurateSelector:(void(^)(NUDSelector *selector,BOOL *stop))handler;
- (void)addTemplate:(id<NUDTemplate>)tpl;
- (id<NUDTemplate>)templateWithId:(NSString *)identifier;
- (NSArray *)linkSelectors;
- (void)removeLinkSelector:(NUDSelector *)sel;
- (void)p;

@end

@interface NUDTemplateMaker ()
@property (nonatomic,strong) NUDTextMaker *textMaker;
@end

@interface NUDTemplateMaker (ToolsExtension)
- (NSArray <id<NUDTemplate>> *)sharedTemplates;
- (NSArray<NUDTextTemplate *> *)sharedTextTemplates;
- (NSArray<NUDAttachmentTemplate *> *)sharedImageTemplates;
- (NUDTextTemplate *)textTemplateWithId:(NSString *)identifier;
- (NUDAttachmentTemplate *)imageTemplateWithId:(NSString *)identifier;
@end
