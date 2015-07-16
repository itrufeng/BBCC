//
//  BeaconManager.m
//  BBCC
//
//  Created by Jian Zhang on 7/15/15.
//  Copyright © 2015 Steve (Zhang Jian). All rights reserved.
//

#import "BeaconManager.h"

@interface BeaconManager() <CLLocationManagerDelegate>

@end

@implementation BeaconManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clManager = [[CLLocationManager alloc] init];
        self.clManager.delegate = self;
        [self.clManager requestAlwaysAuthorization];
    }
    return self;
}

- (void)registerBeaconRegionWithUUID:(NSString *)uuid major:(UInt16)major minor:(UInt16)minor {
    CLBeaconRegion *br = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:uuid] major:major minor:minor identifier:uuid];
    br.notifyEntryStateOnDisplay = NO;
    br.notifyOnEntry = YES;
    br.notifyOnExit = YES;
    [self.clManager startMonitoringForRegion:br];
    [self.clManager startRangingBeaconsInRegion:br];
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region {
    if (_findBeacon) {
        _findBeacon(region.identifier);
    }
}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region {
    if (_lostBeacon) {
        _lostBeacon(region.identifier);
    }
}

@end
