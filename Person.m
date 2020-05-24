//
//  Person.m
//  设计模式Demo
//
//  Created by 刘李斌 on 2020/5/23.
//  Copyright © 2020 Brilliance. All rights reserved.
//


/**
 如果在.h文件中声明了一个方法,但是没有实现,在运行时调用该方法就会造成崩溃,由于iOS底层有保护机制,在找不到该方法后不会立刻崩溃,而是会有3次拯救的机会, 如下
 */

#import "Person.h"
#import <objc/runtime.h>
#import "Animal.h"

@implementation Person

//1. 动态方法解析
//调用的类方法没有找到
+ (BOOL)resolveClassMethod:(SEL)sel {
    
    return [super resolveClassMethod:sel];
}

//调用的对象方法没有找到
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    /*
    //1.判断是否实现方法,没有就动态添加方法
    if (sel == @selector(run:)) {
        //动态添加方法
        //IMP是一个函数指针,指向某个代码块
        //v@:  无参数   v@:@有参数传入
        class_addMethod(self.class, sel, (IMP)newRun, "v@:@");
    }
     */
    return [super resolveInstanceMethod:sel];
}

//2. 消息转发重定向
- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    return [super forwardingTargetForSelector:aSelector];
//    return [[Animal alloc] init];
}

//3. 生成方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    //1. 转化字符串
    NSString *sel = NSStringFromSelector(aSelector);
    //2. 进行判断
    if ([sel isEqualToString:@"run:"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}
//拿到方法签名配发消息
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"------ %@ -------", anInvocation);
    //1. 拿到消息
    SEL selector = [anInvocation selector];
    //2. 转发消息
    Animal *anim = [[Animal alloc] init];
    if ([anim respondsToSelector:selector]) {
        // 调用animal对象,进行转发
        [anInvocation invokeWithTarget:anim];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

//4. 抛出异常 (如果不重写这个方法,如果没有找到可以转发的消息对象(即[anim respondsToSelector:selector] 返回NO),就不崩溃,也不会有任何反应,很难查找到问题)
- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSString *selStr = NSStringFromSelector(aSelector);
    NSLog(@"------  方法%@不存在 -------", selStr);
}

//C语言函数
void newRun(id self, SEL sel, NSString *name) {
    NSLog(@"new run  %@", name);
}

@end
