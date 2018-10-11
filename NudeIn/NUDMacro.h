//
//  NUDMacro.h
//  textExample
//
//  Created by Ruite Chen on 2018/10/11.
//  Copyright © 2018 com.CAI. All rights reserved.
//


#define NUDOverrideASubclass() \
@throw [NSException exceptionWithName:NSInternalInconsistencyException \
reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
userInfo:nil]

#define NUD_STRING_VA_LIST_TO_ARRAY(firstArg,array) \
va_list idList; \
va_start(idList,firstArg); \
NSString *nextId; \
NSMutableArray *array = [@[firstArg] mutableCopy]; \
while ((nextId = va_arg(idList, NSString *))) { \
[array addObject:nextId]; \
} \
va_end(idList);

#define NUDAB(...) className (^)(__VA_ARGS__)

#define NUDABI(...) ^id (__VA_ARGS__)

#define NUDAT(method,...) \
self.parasiticalObj.method(__VA_ARGS__); \
return self; \

#define NUD_LAZY_LOAD_ARRAY(array)\
- (NSMutableArray *)array { \
if (!_##array) { _##array = [NSMutableArray new]; } \
return _##array; \
}

#define NUD_VALUE_OF_RANGE(range) [NSValue valueWithBytes:&range objCType:@encode(NSRange)]


#define NUDAT_ASSIGN OBJC_ASSOCIATION_ASSIGN
#define NUDAT_RETAIN OBJC_ASSOCIATION_RETAIN
#define NUDAT_RETAIN_NONATOMIC OBJC_ASSOCIATION_RETAIN_NONATOMIC
#define NUDAT_COPY OBJC_ASSOCIATION_COPY
#define NUDAT_COPY_NONATOMIC OBJC_ASSOCIATION_COPY_NONATOMIC

#define NUDAT_SYNTHESIZE(methodType,type,prop,upperCaseProp,tag) \
methodType (type)prop {return objc_getAssociatedObject(self, _cmd);} \
methodType (void)set##upperCaseProp:(type)_prop \
{ objc_setAssociatedObject(self, @selector(prop), _prop, tag);}
