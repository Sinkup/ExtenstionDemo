//
//  ExtenstionReader.m
//  ExtenstionDemo
//
//  Created by ChenHao on 15/3/27.
//  Copyright (c) 2015年 Chenhao. All rights reserved.
//

#import "ExtenstionReader.h"


static ExtenstionReader *extenstionReader;


@interface ExtenstionReader ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation ExtenstionReader

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults
{
    self = [super init];
    if (self) {
        _userDefaults = userDefaults;
    }
    
    return self;
}

+ (instancetype)defaultReader
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.LoochaExtenstion.SharedDefaults"];
        
        extenstionReader = [[ExtenstionReader alloc] initWithUserDefaults:userDefaults];
    });
    
    return extenstionReader;
}

@end
