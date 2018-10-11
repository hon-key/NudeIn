//
//  NUDAttributeSet.h
//  textExample
//
//  Created by 工作 on 2018/9/29.
//  Copyright © 2018 com.CAI. All rights reserved.
//

#import "NudeIn-Prefix.h"
#import "NUDAttribute.h"


#define NUDAnounceTextAttributeSet(attrName) \
@interface NUDAttribute <className> (attrName) \
- (NUDAB(void))attrName; \
@end

#define NUDMakeTextAttributeSet(attrName,action) \
@implementation NUDAttribute (attrName) \
- (id (^)(void))attrName { \
return NUDABI(void) { \
return self.asText.action; \
}; \
} \
@end

#define NUDAnounceTextAttributeSetWithArg(attrName,type)\
@interface NUDAttribute <className> (attrName) \
- (NUDAB(type))attrName; \
@end

#define NUDMakeTextAttributeSetWithArg(attrName,type,arg,action) \
@implementation NUDAttribute (attrName) \
- (id (^)(type))attrName { \
    return NUDABI(type arg) { \
        return self.asText.action; \
    }; \
} \
@end
