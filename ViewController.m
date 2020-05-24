//
//  ViewController.m
//  MessageForwardingDemo
//
//  Created by 刘李斌 on 2020/5/24.
//  Copyright © 2020 Brilliance. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *p = [Person new];
    [p run:@"张三"];
}


@end
