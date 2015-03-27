//
//  ShareViewController.m
//  ShareExtenstion
//
//  Created by Chenhao on 15/3/26.
//  Copyright (c) 2015年 Chenhao. All rights reserved.
//

#import "ShareViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

#import "Extenstion.h"

@interface ShareViewController ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *urlString;

@end

@implementation ShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.2];
    //    self.preferredContentSize = CGSizeMake(200, 100);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [self.view addGestureRecognizer:tap];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(40, 100, CGRectGetWidth(self.view.bounds) - 80, 300)];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.clipsToBounds = YES;
    _contentView.layer.cornerRadius = 3.0;
    _contentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _contentView.layer.shadowOpacity = 0.9;
    _contentView.layer.shadowOffset = CGSizeMake(0, 0);
    [self.view addSubview:_contentView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_contentView.bounds), 36)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = @"分享";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_contentView addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 36, CGRectGetWidth(_contentView.bounds), CGRectGetHeight(_contentView.bounds) - 76)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [_contentView addSubview:imageView];
    
//    UILabel *
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, CGRectGetHeight(_contentView.bounds) - 40, CGRectGetWidth(_contentView.bounds), 40);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:button];
    
    
    _images = [NSMutableArray array];
    
    NSExtensionItem *extensionItem = [self.extensionContext.inputItems firstObject];
    NSLog(@"attributedTitle: %@", extensionItem.attributedTitle);
    NSLog(@"attributedContentText: %@", extensionItem.attributedContentText);
    NSLog(@"attachments: %@", extensionItem.attachments);
    NSLog(@"userInfo: %@", extensionItem.userInfo);
    
    self.title = extensionItem.attributedContentText.string;
    
    for (NSItemProvider *provider in extensionItem.attachments) {
        if([provider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage]){
            [provider loadItemForTypeIdentifier:(NSString *)kUTTypeImage
                                        options:nil
                              completionHandler:^(UIImage *image, NSError *error) {
                                  NSLog(@"loadItemForTypeIdentifier");
                                  if(image){
                                      [_images addObject:image];
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          imageView.image = image;
                                      });
                                  }
                              }];
            
            [provider loadPreviewImageWithOptions:@{ NSItemProviderPreferredImageSizeKey: [NSValue valueWithCGSize:CGSizeMake(100, 100)]}
                                completionHandler:^(id<NSSecureCoding> item, NSError *error) {
                                    NSLog(@"loadPreviewImageWithOptions");
                                }];
        } else if ([provider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
            [provider loadItemForTypeIdentifier:(NSString *)kUTTypeURL
                                        options:nil
                              completionHandler:^(NSURL *url, NSError *error) {
                                  NSLog(@"loadItemForTypeIdentifier");
                                  if(url){
//                                      [_images addObject:image];
//                                      dispatch_async(dispatch_get_main_queue(), ^{
//                                          imageView.image = image;
//                                      });
                                      self.urlString = [url absoluteString];
                                  }
                              }];
            
            [provider loadPreviewImageWithOptions:@{ NSItemProviderPreferredImageSizeKey: [NSValue valueWithCGSize:CGSizeMake(100, 100)]}
                                completionHandler:^(id<NSSecureCoding> item, NSError *error) {
                                    NSLog(@"loadPreviewImageWithOptions");
                                }];
        }
    }
}

- (void)buttonClicked:(UIButton *)sender
{
    //LoochaCore://share
    //    [self.extensionContext openURL:[NSURL URLWithString:@"LoochaCore://"] completionHandler:^(BOOL success) {
    //
    //    }];
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.LoochaExtenstion.SharedDefaults"];
    
    if (self.images.count) {
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:self.images.count];
        for (UIImage *image in self.images) {
            NSData *data = [NSData data];
            if (UIImagePNGRepresentation(image) == nil) {
                data = UIImageJPEGRepresentation(image, 1);
            } else {
                data = UIImagePNGRepresentation(image);
            }
            
            [datas addObject:data];
        }
        
        [userDefaults setValue:datas forKey:@"sharedImages"];
    }
    
    if (self.title.length) {
        [userDefaults setObject:self.title forKey:@"sharedTitle"];
    }
    
    if (self.urlString.length) {
        [userDefaults setObject:self.urlString forKey:@"sharedURL"];
    }
    
    [userDefaults synchronize];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ExtenstionDemo://share"]]];
    [webView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2.0];
    
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (void)dismiss:(UITapGestureRecognizer *)sender
{
    [UIView animateWithDuration:0.4 animations:^{
        self.view.alpha = 0.;
    } completion:^(BOOL finished) {
        [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
    }];
}

@end
