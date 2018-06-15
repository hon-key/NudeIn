//  NUDAttachment.m
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

#import "NUDAttachment.h"
#import "NUDTextMaker.h"
#import "NUDText.h"
#import "NUDTextUpdate.h"
#import <objc/runtime.h>


#define HK_STORE_TAG_TO(tags) if(![tags containsObject:NSStringFromSelector(_cmd)]) {[tags addObject:NSStringFromSelector(_cmd)];}
#define HK_FIND_TAG(tags,t) [tags containsObject:NSStringFromSelector(@selector(t))]

@interface NUDAttachment ()

@property (nonatomic,strong) NSTextAttachment *attachment;
@property (nonatomic,weak) NUDTextMaker *father;

@property (nonatomic,assign) NSUInteger numOfLinefeed;
@property (nonatomic,strong) NSMutableArray *actionTags;

@end

@interface NUDAttachmentTemplate ()

@property (nonatomic,strong) NUDAttachment *parasiticalObj;

@end

@implementation NUDAttachment

NUD_LAZY_LOAD_ARRAY(actionTags)

- (instancetype)initWithFather:(NUDTextMaker *)maker {
    if (self = [super init]) {
        _father = maker;
        _attachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
        _numOfLinefeed = NSUIntegerMax;
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    NUDAttachment *attachment = [super copyWithZone:zone];
    
    attachment.father = self.father;
    attachment.attachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attachment.attachment.bounds = self.attachment.bounds;
    attachment.numOfLinefeed = self.numOfLinefeed;
    attachment.actionTags = [self.actionTags mutableCopy];
    attachment.update = self.update;
    
    NSData *imgData = nil;
    if ((imgData = UIImagePNGRepresentation(self.attachment.image)) ||
        (imgData = UIImageJPEGRepresentation(self.attachment.image,1.0))) {
        attachment.attachment.image = [UIImage imageWithData:imgData scale:[UIScreen mainScreen].scale];
    } else {
        attachment.attachment.image = self.attachment.image;
    }
    
    return attachment;
}

- (void)mergeComp:(NUDBase *)comp {
    if ([comp isKindOfClass:[NUDAttachment class]]) {
        NUDAttachment *attachment = (NUDAttachment *)comp;
        self.father = attachment.father;
        self.attachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
        self.attachment.bounds = attachment.attachment.bounds;
        self.numOfLinefeed = attachment.numOfLinefeed;
        self.actionTags = [attachment.actionTags mutableCopy];
        self.update = attachment.update;
        
        NSData *imgData = nil;
        if ((imgData = UIImagePNGRepresentation(attachment.attachment.image)) ||
            (imgData = UIImageJPEGRepresentation(attachment.attachment.image,1.0))) {
            self.attachment.image = [UIImage imageWithData:imgData scale:[UIScreen mainScreen].scale];
        } else {
            self.attachment.image = self.attachment.image;
        }
    }
}

- (id (^)(CGFloat, CGFloat))origin {
    return NUDABI(CGFloat x,CGFloat y) {
        CGRect bounds = self.attachment.bounds;
        bounds.origin.x = x;
        bounds.origin.y = y;
        self.attachment.bounds = bounds;
        HK_STORE_TAG_TO(self.actionTags);
        return self;
    };
}

- (id (^)(CGFloat, CGFloat))size {
    return NUDABI(CGFloat width,CGFloat height) {
        CGRect bounds = self.attachment.bounds;
        bounds.size.width = width;
        bounds.size.height = height;
        self.attachment.bounds = bounds;
        HK_STORE_TAG_TO(self.actionTags);
        return self;
    };
}

- (id (^)(CGFloat))vertical {
    return NUDABI(CGFloat offset) {
        self.origin(0,offset);
        HK_STORE_TAG_TO(self.actionTags);
        return self;
    };
}

- (id (^)(NSUInteger))ln {
    return NUDABI(NSUInteger num) {
        self.numOfLinefeed = num;
        HK_STORE_TAG_TO(self.actionTags);
        return self;
    };
}

- (void (^)(void))attach {
    return ^void (void) {
        self.attachWith(kNUDAttachmentAllImageKey,nil);
    };
}

- (void (^)(NSString *, ...))attachWith {
    return ^void (NSString *identifier,...) {

        NSMutableArray *tpls = NUD_MAKE_TEMPLATE_ARRAY_FROM(identifier, self.father);
        NUDAttachmentTemplate *template = tpls.count > 0 ? [self mergeTemplates:tpls] : nil;
        if (template) {
            NSMutableArray *actionTags = [template.parasiticalObj.actionTags mutableCopy];
            [actionTags removeObjectsInArray:self.actionTags];
            
            NSTextAttachment *tplAttachment = template.parasiticalObj.attachment;
            if (HK_FIND_TAG(actionTags, origin)) {
                self.origin(tplAttachment.bounds.origin.x,tplAttachment.bounds.origin.x);
            }
            if (HK_FIND_TAG(actionTags, size)) {
                self.size(tplAttachment.bounds.size.width,tplAttachment.bounds.size.height);
            }
            if (HK_FIND_TAG(actionTags, vertical)) {
                self.vertical(tplAttachment.bounds.origin.y);
            }
            if (self.numOfLinefeed == NSUIntegerMax) {
                self.numOfLinefeed = template.parasiticalObj.numOfLinefeed;
            }
        }
        NSAttributedString *string = [self attributedString];
        NSRange strRange = [self.father appendString:string];
        
        Ivar ivar = class_getInstanceVariable(NSClassFromString(@"NUDBase"), "_range");
        object_setIvar(self, ivar, NUD_VALUE_OF_RANGE(strRange));
        
        [self.father storeTextComponent:self];

    };
}

- (void (^)(void))apply {
    return ^void (void) {
        if (self.update) {
            [self.update applyComp:self];
        }
    };
}

- (NSAttributedString *)attributedString {
    NSAttributedString *string =  [NSAttributedString attributedStringWithAttachment:self.attachment];
    NSMutableAttributedString *stringM = [string mutableCopy];
    NSMutableString *strLinefeed = [NSMutableString string];
    if (self.numOfLinefeed != 0 && self.numOfLinefeed != NSUIntegerMax) {
        for (int i = 0; i < self.numOfLinefeed; i++) {
            [strLinefeed appendString:@"\n"];
        }
    }
    NSAttributedString *lineFeed = [[NSAttributedString alloc] initWithString:strLinefeed attributes:nil];
    [stringM appendAttributedString:lineFeed];
    return stringM;
}

- (UIImage *)image {
    return self.attachment.image;
}

- (void)setImage:(UIImage *)image {
    self.attachment.image = image;
}

@end

@implementation NUDAttachmentTemplate

NUDAT_SYNTHESIZE(NUDAT_COPY_NONATOMIC,NSString *,identifier,Identifier)

- (instancetype)initWithFather:(NUDTextMaker *)maker identifier:(NSString *)identifier {
    if (self = [super init]) {
        _parasiticalObj = [[NUDAttachment alloc] initWithFather:maker];
        self.identifier = identifier;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    NUDAttachmentTemplate *tpl = [[[self class] alloc] initWithFather:self.parasiticalObj.father identifier:self.identifier];
    tpl.parasiticalObj.actionTags = [self.parasiticalObj.actionTags mutableCopy];
    tpl.parasiticalObj.attachment.image = self.parasiticalObj.attachment.image;
    tpl.parasiticalObj.attachment.bounds = self.parasiticalObj.attachment.bounds;
    tpl.parasiticalObj.numOfLinefeed = self.parasiticalObj.numOfLinefeed;
    return tpl;
}

- (void)mergeComp:(NUDBase *)comp {
    if ([comp isKindOfClass:[NUDAttachmentTemplate class]]) {
        NUDAttachmentTemplate *tpl = (NUDAttachmentTemplate *)comp;
        self.parasiticalObj.actionTags = [tpl.parasiticalObj.actionTags mutableCopy];
        self.parasiticalObj.attachment.image = tpl.parasiticalObj.attachment.image;
        self.parasiticalObj.attachment.bounds = tpl.parasiticalObj.attachment.bounds;
        self.parasiticalObj.numOfLinefeed = tpl.parasiticalObj.numOfLinefeed;
    }
}

- (id (^)(CGFloat, CGFloat))origin {return NUDABI(CGFloat x,CGFloat y) {NUDAT(origin,x,y);};}
- (id (^)(CGFloat, CGFloat))size {return NUDABI(CGFloat width,CGFloat height){NUDAT(size,width,height);};}
- (id (^)(CGFloat))vertical {return NUDABI(CGFloat offset){NUDAT(vertical,offset);};}
- (id (^)(NSUInteger))ln {return NUDABI(NSUInteger num){NUDAT(ln,num);};}

- (void (^)(void))attach {
    return ^void (void) {
        [self.parasiticalObj.father addTemplate:self];
    };
}

- (void)mergeTemplate:(id<NUDTemplate>)tpl {
    if ([tpl isKindOfClass:[NUDAttachmentTemplate class]]) {
        NUDAttachmentTemplate *template = tpl;
        NSTextAttachment *attachment = template.parasiticalObj.attachment;
        NSMutableArray *actionTags = template.parasiticalObj.actionTags;
        if (HK_FIND_TAG(actionTags, origin)) {
            self.origin(attachment.bounds.origin.x,attachment.bounds.origin.x);
        }
        if (HK_FIND_TAG(actionTags, size)) {
            self.size(attachment.bounds.size.width,attachment.bounds.size.height);
        }
        if (HK_FIND_TAG(actionTags, vertical)) {
            self.vertical(attachment.bounds.origin.y);
        }
        if (HK_FIND_TAG(actionTags, ln)) {
            self.parasiticalObj.numOfLinefeed += template.parasiticalObj.numOfLinefeed;
        }

    }
}

@end
