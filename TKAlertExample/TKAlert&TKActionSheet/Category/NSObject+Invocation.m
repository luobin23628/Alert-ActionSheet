//
//  
//
//
//  Created by binluo on 15/6/14.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import "NSObject+Invocation.h"


@implementation NSObject (NSInvocation)

- (NSInvocation *)invocationWithSelector:(SEL)selector {
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    [invocation retainArguments];
    return invocation;
}

// @see http://www.cocoawithlove.com/2009/05/variable-argument-lists-in-cocoa.html
- (NSInvocation *)invocationWithSelector:(SEL)selector argList:(va_list)argList start:(void *)start {
    NSInvocation *invocation = [self invocationWithSelector:selector];
    NSUInteger index = 2, numberOfArguments = invocation.methodSignature.numberOfArguments;
    id nilLocation = nil;
    for (void *argumentLocation = start; index < numberOfArguments/* argumentLocation != nil */; argumentLocation = va_arg(argList, void *)) {
        [invocation setArgument:argumentLocation ?: &nilLocation atIndex:index++];
    }
    return invocation;
}

- (NSInvocation *)invocationWithSelector:(SEL)selector argument:(void *)argument {
    return [self invocationWithSelector:selector arguments:argument];
}

- (NSInvocation *)invocationWithSelector:(SEL)selector arguments:(void *)start, ... {
    va_list argList;
    va_start(argList, start);
    NSInvocation *invocation = [self invocationWithSelector:selector argList:argList start:start];
    va_end(argList);
    return invocation;
}

- (void)invokeWithSelector:(SEL)selector {
    [[self invocationWithSelector:selector] invoke];
}

- (void)invokeWithSelector:(SEL)selector argument:(void *)argument {
    [self invokeWithSelector:selector arguments:argument];
}

- (void)invokeWithSelector:(SEL)selector arguments:(void *)start, ... {
    va_list argList;
    va_start(argList, start);
    [[self invocationWithSelector:selector argList:argList start:start] invoke];
    va_end(argList);
}

- (void)invokeWithSelector:(SEL)selector returnValue:(void *)returnValue {
    NSInvocation *invocation = [self invocationWithSelector:selector];
    [invocation invoke];
    if (strcmp(invocation.methodSignature.methodReturnType, @encode(void)) != 0) {
        [invocation getReturnValue:returnValue];
    }
}

- (void)invokeWithSelector:(SEL)selector returnValue:(void *)returnValue argument:(void *)argument {
    [self invokeWithSelector:selector returnValue:returnValue arguments:argument];
}

- (void)invokeWithSelector:(SEL)selector returnValue:(void *)returnValue arguments:(void *)start, ... {
    va_list argList;
    va_start(argList, start);
    NSInvocation *invocation = [self invocationWithSelector:selector argList:argList start:start];
    va_end(argList);
    [invocation invoke];
    if (strcmp(invocation.methodSignature.methodReturnType, @encode(void)) != 0) {
        [invocation getReturnValue:returnValue];
    }
}

@end

