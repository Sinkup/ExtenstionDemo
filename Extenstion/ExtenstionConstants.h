//
//  ExtenstionConstants.h
//  ExtenstionDemo
//
//  Created by ChenHao on 15/3/27.
//  Copyright (c) 2015年 Chenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ExtenstionType) {
    ExtenstionTypeShare,
    ExtenstionTypeAction,
    ExtenstionTypeToday,
    // ...
};

typedef NS_ENUM(NSUInteger, SharedItemsType) {
    SharedItemsTypeImage,
    SharedItemsTypeURL,
    SharedItemsTypeMovie,
};

FOUNDATION_EXTERN NSString * const ExtenstionSharedItemImageKey;
FOUNDATION_EXTERN NSString * const ExtenstionSharedItemURLKey;
FOUNDATION_EXTERN NSString * const ExtenstionSharedItemMovieKey;

@interface ExtenstionConstants : NSObject

@end
