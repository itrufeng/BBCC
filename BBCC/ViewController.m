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

- (void)awakeFromNib {
    _bm = [[BeaconManager alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self listenBeaconNotification];
    [self listenBeaconEnter];
    [self registerBeacons];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"COME" object:nil];
}

- (void)listenBeaconNotification {
    [[NSNotificationCenter defaultCenter] addObserverForName:@"COME" object:nil queue:nil usingBlock:^(NSNotification * __nonnull note) {
        [self updateBeaconInfoUIWithBeaconData:note.userInfo];
    }];
}

- (void)listenBeaconEnter {
    __weak ViewController *Self = self;
    _bm.findBeacon = ^(NSString *uuid) {
        [Self updateLog:@"ENTER"];
        [Self requestBeaconDataWithUUID:uuid];
    };
}

- (void)listenBeaconExit {
    __weak ViewController *Self = self;
    _bm.lostBeacon = ^(NSString *uuid) {
        [Self updateLog:@"EXIT"];
    };
}

- (void)registerBeacons {
    [_bm registerBeaconRegionWithUUID:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0" major:1 minor:1];
    [_bm registerBeaconRegionWithUUID:@"F2C56DB5-DFFB-48D2-B060-D0F5A71096D8" major:2 minor:4];
}

- (void)updateBeaconInfoUIWithBeaconData:(NSDictionary *)beaconData {
    _titleLabel.text = beaconData[@"title"];
    _contentLabel.text = beaconData[@"content"];
    if (beaconData[@"imageUrl"] != nil)
        [_showImageView setImageWithURL:[NSURL URLWithString:beaconData[@"imageUrl"]]];
}

- (void)requestBeaconDataWithUUID:(NSString *)uuid {
    __weak ViewController *Self = self;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *host = [((AppDelegate *)[UIApplication sharedApplication].delegate) host];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@", host, uuid.lowercaseString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            [Self updateLog:@"APIERROR"];
        } else {
            [Self sendLocalNotificationWithBeaconData:responseObject];
        }
    }];
    [dataTask resume];
}

- (void)updateLog:(NSString *)log {
    _statusLabel.text = log;
}

- (void)sendLocalNotificationWithBeaconData:(NSDictionary *)beaconData {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = beaconData[@"title"];
    localNotification.userInfo = beaconData;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

@end
