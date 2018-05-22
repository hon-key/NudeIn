//
//  HKAttributeTextLabel.m
//  mynetvue
//
//  Created by 工作 on 2018/5/11.
//  Copyright © 2018年 Netviewtech. All rights reserved.
//

#import "HKAttributeTextView.h"

@interface HKSelector : NSObject

@property (nonatomic,weak) id target;
@property (nonatomic) SEL action;
@property (nonatomic,strong) id obj;

- (NSString *)name;
- (void)callWithIndex:(NSUInteger)index name:(NSString *)name;

@end

@implementation HKSelector
- (NSString *)name {
    return NSStringFromSelector(self.action);
}
- (void)callWithIndex:(NSUInteger)index name:(NSString *)name {
    if ([self.target respondsToSelector:self.action]) {
        IMP p = [self.target methodForSelector:self.action];
        void (*method)(id,SEL,id,NSUInteger) = (void *)p;
        method(self.target,self.action,name,index);
    }
}
@end

@interface HKAttributeText ()

@property (nonatomic,copy) NSString *string;
@property (nonatomic,strong) NSMutableDictionary<NSAttributedStringKey, id> *attributes;
@property (nonatomic,weak) HKAttributeTextMaker *father;

@end

@interface HKAttributeTextMaker()

@property (nonatomic,strong) NSMutableAttributedString *string;
@property (nonatomic,strong) NSMutableArray<HKSelector *> *selectors;

- (void)appendString:(NSAttributedString *)string;

@end

@implementation HKAttributeText

- (instancetype)initWithFather:(HKAttributeTextMaker *)maker {
    if (self = [super init]) {
        self.attributes = [NSMutableDictionary new];
        self.father = maker;
    }
    return self;
}

- (HKAttributeText *(^)(NSString *))text {
    
    HKAttributeText *(^block)(NSString *) = ^HKAttributeText *(NSString *string) {
        
        self.string = string;
        return self;
        
    };
    
    return block;
}

- (HKAttributeText *(^)(NSUInteger))font {
    
    HKAttributeText *(^block)(NSUInteger) = ^HKAttributeText *(NSUInteger size) {
        
        [self.attributes setObject:[UIFont systemFontOfSize:size] forKey:NSFontAttributeName];
        return self;
        
    };
    
    return block;
}

- (HKAttributeText *(^)(UIColor *))color {
    
    HKAttributeText *(^block)(UIColor *) = ^HKAttributeText *(UIColor *color) {
        
        [self.attributes setObject:color forKey:NSForegroundColorAttributeName];
        return self;
        
    };
    
    return block;
}

- (HKAttributeText *(^)(id, SEL))link {
    
    HKAttributeText *(^block)(id,SEL) = ^HKAttributeText *(id target,SEL selector) {
        
        HKSelector *s = [HKSelector new];
        s.target = target;
        s.action = selector;
        [self.father.selectors addObject:s];
        NSString *urlString = [NSString stringWithFormat:@"selector://%@&%@&%lu",self.string,[s name],(unsigned long)[self.father.selectors indexOfObject:s]];
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [self.attributes setObject:url forKey:NSLinkAttributeName];
        
        return self;
    };
    
    return block;
}

- (HKAttributeText *(^)(void))attach {
    
    HKAttributeText *(^block)(void) = ^HKAttributeText *(void) {
        
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:self.string attributes:self.attributes];
        [self.father appendString:string];
        return self;
        
    };
    
    return block;
}

@end

@implementation HKAttributeTextMaker

- (instancetype)init {
    if (self = [super init]) {
        self.string = [[NSMutableAttributedString alloc] init];
        self.selectors = [NSMutableArray new];
    }
    return self;
}

- (HKAttributeText *(^)(NSString *))text {
    
    HKAttributeText *(^block)(NSString *) = ^HKAttributeText *(NSString *string) {
        
        HKAttributeText *text = [[HKAttributeText alloc] initWithFather:self];
        text.string = string;
        return text;
        
    };
    
    return block;
}

- (HKAttributeText *(^)(NSUInteger))font {
    
    HKAttributeText *(^block)(NSUInteger) = ^HKAttributeText *(NSUInteger size) {
        
        HKAttributeText *text = [[HKAttributeText alloc] initWithFather:self];
        [text.attributes setObject:[UIFont systemFontOfSize:size] forKey:NSFontAttributeName];
        return text;
        
    };
    
    return block;
    
}

- (HKAttributeText *(^)(UIColor *))color {
    
    
    HKAttributeText *(^block)(UIColor *) = ^HKAttributeText *(UIColor *color) {
        
        HKAttributeText *text = [[HKAttributeText alloc] initWithFather:self];
        [text.attributes setObject:color forKey:NSForegroundColorAttributeName];
        return text;
        
    };
    
    return block;
    
}

- (HKAttributeText *(^)(id, SEL))link {
    
    HKAttributeText *(^block)(id,SEL) = ^HKAttributeText *(id target,SEL selector) {
        
        HKAttributeText *text = [[HKAttributeText alloc] initWithFather:self];
        HKSelector *s = [HKSelector new];
        s.target = target;
        s.action = selector;
        [self.selectors addObject:s];
        NSString *urlString = [NSString stringWithFormat:@"selector://%@&%@&%lu",text.string,[s name],(unsigned long)[text.father.selectors indexOfObject:s]];
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [text.attributes setObject:url forKey:NSLinkAttributeName];
        
        return text;
    };
    
    return block;
}

- (void)appendString:(NSAttributedString *)string {
    [self.string appendAttributedString:string];
}

@end

@interface HKAttributeTextView ()<UITextViewDelegate>

@property (nonatomic,strong) HKAttributeTextMaker *maker;

@end

@implementation HKAttributeTextView

+ (HKAttributeTextView *)make:(void (^)(HKAttributeTextMaker *))make {
    
    HKAttributeTextView *label = [[HKAttributeTextView alloc] init];
    label.scrollEnabled = NO;
    label.editable = NO;
    label.textContainer.lineFragmentPadding = 0;
    label.textContainerInset = UIEdgeInsetsMake(-1, 0, 0, 0);
    label.delegate = label;
    
    label.maker = [[HKAttributeTextMaker alloc] init];
    
    if (make) {
        make(label.maker);
    }
    
    label.attributedText = label.maker.string;
    
    return label;
    
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    
    NSArray *urlComp = [URL.absoluteString componentsSeparatedByString:@"://"];
    NSArray *keys;
    if (urlComp.count >= 2) {
        keys = [urlComp[1] componentsSeparatedByString:@"&"];
    }
    for (HKSelector *s in self.maker.selectors) {
        if ([[s name] isEqualToString:keys[1]]) {
            [s callWithIndex:((NSString *)keys[2]).integerValue name:[keys[0] stringByRemovingPercentEncoding]];
            break;
        }
    }
    
    return NO;
    
}

@end

@implementation UITextView (DisableCopy)
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    [self resignFirstResponder];
    
    if ([UIMenuController sharedMenuController]) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    
    return NO;
}
@end
