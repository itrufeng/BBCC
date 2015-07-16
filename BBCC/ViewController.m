//
//  ViewController.m
//  BBCC
//
//  Created by Jian Zhang on 7/15/15.
//  Copyright © 2015 Steve (Zhang Jian). All rights reserved.
//

#import "ViewController.h"
#import "BeaconManager.h"
#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) BeaconManager *bm;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"COME" object:nil queue:nil usingBlock:^(NSNotification * __nonnull note) {
        _titleLabel.text = note.userInfo[@"title"];
        _contentLabel.text = note.userInfo[@"content"];
        if (note.userInfo[@"imageUrl"] != nil)
            [_showImageView setImageWithURL:[NSURL URLWithString:note.userInfo[@"imageUrl"]]];
    }];
    
    _bm = [[BeaconManager alloc] init];
    _bm.findBeacon = ^(NSString *uuid) {
        NSLog(@"%@", uuid);
//        _statusLabel.text = @"ENTER";
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSString *host = [((AppDelegate *)[UIApplication sharedApplication].delegate) host];
        
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@", host, uuid.lowercaseString]];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
//                _statusLabel.text = @"APIERROR";
            } else {
                NSLog(@"%@ %@", response, responseObject);
                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                localNotification.alertBody = responseObject[@"title"];
                localNotification.userInfo = responseObject;
                localNotification.soundName = UILocalNotificationDefaultSoundName;
                [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
            }
        }];
        [dataTask resume];
    };
    
    _bm.lostBeacon = ^(NSString *uuid) {
        NSLog(@"exit");
//        _statusLabel.text = @"EXIT";
    };
    
    [_bm registerBeaconRegionWithUUID:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0" major:1 minor:1];
    [_bm registerBeaconRegionWithUUID:@"F2C56DB5-DFFB-48D2-B060-D0F5A71096D8" major:2 minor:4];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"COME" object:nil];
}

@end
