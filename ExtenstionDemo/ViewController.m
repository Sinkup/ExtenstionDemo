//
//  ViewController.m
//  ExtenstionDemo
//
//  Created by Chenhao on 15/3/26.
//  Copyright (c) 2015年 Chenhao. All rights reserved.
//

#import "ViewController.h"

#import "AppDelegate.h"
#import "Extenstion.h"

@interface ViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 80, CGRectGetWidth(self.view.bounds) - 40, CGRectGetHeight(self.view.bounds) - 120)];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [self.view addSubview:self.scrollView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationShareExtenstion)
                                                 name:UIApplicationShareExtenstionNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applicationShareExtenstion
{
    NSArray *subviews = self.scrollView.subviews;
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.LoochaExtenstion.SharedDefaults"];
    NSString *url = [userDefaults stringForKey:@"sharedURL"];
    
    if (url.length) {
        NSString *title = [userDefaults stringForKey:@"sharedTitle"];
        
        NSLog(@"url: %@", url);
        NSLog(@"title: %@", title);
        
        [userDefaults removeObjectForKey:@"sharedURL"];
        [userDefaults removeObjectForKey:@"sharedTitle"];
        
        return;
    }
    
    NSArray *datas = [userDefaults arrayForKey:@"sharedImages"];
    
    
//    NSMutableArray *images = [NSMutableArray arrayWithCapacity:datas.count];
    CGFloat x = 0.;
    for (NSData *data in datas) {
        UIImage *image = [UIImage imageWithData:data];
//        [images addObject:image];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds))];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        imageView.image = image;
        [self.view addSubview:imageView];
        
        [self.scrollView addSubview:imageView];
        
        x += CGRectGetWidth(self.scrollView.bounds);
    }
    
    self.scrollView.contentSize = CGSizeMake(x, CGRectGetHeight(self.scrollView.bounds));
    
    [userDefaults removeObjectForKey:@"sharedImages"];
}

@end
