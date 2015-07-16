//
//  Check.m
//  BBCC
//
//  Created by Jian Zhang on 7/15/15.
//  Copyright © 2015 Steve (Zhang Jian). All rights reserved.
//

#import "Check.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

@interface Check () <CBCentralManagerDelegate>

@property (strong, nonatomic) CBCentralManager *ccbm;

@end

@implementation Check

- (void)check {
    [self checkBluetooth];
    [self checkLocation];
//    [self checkNotification];
}

- (void)checkLocation {
    if ([CLLocationManager locationServicesEnabled] == NO) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"请开启位置服务，才可以使用哦" delegate:nil cancelButtonTitle:@"好吧我只好答应你！" otherButtonTitles:nil] show];
    }
}

- (void)checkNotification {
    if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications] == NO) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"请开启推送，才可以使用哦" delegate:nil cancelButtonTitle:@"好吧我只好答应你！" otherButtonTitles:nil] show];
    }
}

- (void)checkBluetooth {
    _ccbm = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBCentralManagerStatePoweredOn) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"请开启蓝牙，才可以使用哦" delegate:nil cancelButtonTitle:@"好吧我只好答应你！" otherButtonTitles:nil] show];
    }
}

@end
