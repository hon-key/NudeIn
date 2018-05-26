//
//  HKAttributedAttachment.m
//  textExample
//
//  Created by 工作 on 2018/5/24.
//  Copyright © 2018年 com.CAI. All rights reserved.
//

#import "HKAttributedAttachment.h"
#import "HKAttributedTextMaker.h"
#import <objc/runtime.h>

#define HK_STORE_TAG_TO(tags) [tags addObject:NSStringFromSelector(_cmd)]
#define HK_FIND_TAG(tags,t) [tags containsObject:NSStringFromSelector(@selector(t))]

@interface HKAttributedAttachment ()

@property (nonatomic,strong) NSTextAttachment *attachment;
@property (nonatomic,weak) HKAttributedTextMaker *father;

@property (nonatomic,assign) NSUInteger numOfLinefeed;
@property (nonatomic,strong) NSMutableArray *actionTags;

@end

@interface HKAttributedAttachmentTemplate ()

@property (nonatomic,strong) HKAttributedAttachment *parasiticalObj;

@end

@implementation HKAttributedAttachment

- (instancetype)initWithFather:(HKAttributedTextMaker *)maker {
    if (self = [super init]) {
        _father = maker;
        _attachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
        _numOfLinefeed = 0;
        self.actionTags = [NSMutableArray new];
        
    }
    return self;
}

- (id (^)(CGFloat, CGFloat))origin {
    return HKABI(CGFloat x,CGFloat y) {
        CGRect bounds = self.attachment.bounds;
        bounds.origin.x = x;
        bounds.origin.y = y;
        self.attachment.bounds = bounds;
        HK_STORE_TAG_TO(self.actionTags);
        return self;
    };
}

- (id (^)(CGFloat, CGFloat))size {
    return HKABI(CGFloat width,CGFloat height) {
        CGRect bounds = self.attachment.bounds;
        bounds.size.width = width;
        bounds.size.height = height;
        self.attachment.bounds = bounds;
        HK_STORE_TAG_TO(self.actionTags);
        return self;
    };
}

- (id (^)(CGFloat))vertical {
    return HKABI(CGFloat offset) {
        self.origin(0,offset);
        HK_STORE_TAG_TO(self.actionTags);
        return self;
    };
}

- (id (^)(NSUInteger))linefeed {
    return HKABI(NSUInteger num) {
        if (num > 0) {
            self.numOfLinefeed += num;
        }else {
            self.numOfLinefeed = 0;
        }
        HK_STORE_TAG_TO(self.actionTags);
        return self;
    };
}

- (void (^)(void))attach {
    return ^void (void) {
        self.attachWith(kHKAttributedAttachmentAllImageKey,nil);
    };
}

- (void (^)(NSString *, ...))attachWith {
    return ^void (NSString *identifier,...) {

        NSMutableArray *tpls = HK_MAKE_TEMPLATE_ARRAY_FROM(identifier, self.father);
        HKAttributedAttachmentTemplate *template = tpls.count > 0 ? [self mergeTemplates:tpls] : nil;
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
            if (HK_FIND_TAG(actionTags, linefeed)) {
                self.linefeed(template.parasiticalObj.numOfLinefeed);
            }
        }
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:self.attachment];
        [self.father appendString:string];
        if (self.numOfLinefeed > 0) {
            self.father.text(@"").linefeed(self.numOfLinefeed).attachWith(@"",nil);
        }
    };
}

- (UIImage *)image {
    return self.attachment.image;
}

- (void)setImage:(UIImage *)image {
    self.attachment.image = image;
}

@end

@implementation HKAttributedAttachmentTemplate

HKAT_SYNTHESIZE(HKAT_COPY_NONATOMIC,NSString *,identifier)

- (instancetype)initWithFather:(HKAttributedTextMaker *)maker identifier:(NSString *)identifier {
    if (self = [super init]) {
        _parasiticalObj = [[HKAttributedAttachment alloc] initWithFather:maker];
        self.identifier = identifier;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    HKAttributedAttachmentTemplate *tpl = [[[self class] alloc] initWithFather:self.parasiticalObj.father identifier:self.identifier];
    tpl.parasiticalObj.actionTags = [self.parasiticalObj.actionTags mutableCopy];
    tpl.parasiticalObj.attachment.image = self.parasiticalObj.attachment.image;
    tpl.parasiticalObj.attachment.bounds = self.parasiticalObj.attachment.bounds;
    return tpl;
}

- (id (^)(CGFloat, CGFloat))origin {return HKABI(CGFloat x,CGFloat y) {HKAT(origin,x,y);};}
- (id (^)(CGFloat, CGFloat))size {return HKABI(CGFloat width,CGFloat height){HKAT(size,width,height);};}
- (id (^)(CGFloat))vertical {return HKABI(CGFloat offset){HKAT(vertical,offset);};}
- (id (^)(NSUInteger))linefeed {return HKABI(NSUInteger num){HKAT(linefeed,num);};}

- (void (^)(void))attach {
    return ^void (void) {
        [self.parasiticalObj.father addTemplate:self];
    };
}

- (void)mergeTemplate:(id<HKTemplate>)tpl {
    if ([tpl isKindOfClass:[HKAttributedAttachmentTemplate class]]) {
        HKAttributedAttachmentTemplate *template = tpl;
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
        if (HK_FIND_TAG(actionTags, vertical)) {
            self.parasiticalObj.numOfLinefeed += template.parasiticalObj.numOfLinefeed;
        }
    }
}

@end
