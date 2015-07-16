//
//  BeaconManager.h
//  BBCC
//
//  Created by Jian Zhang on 7/15/15.
//  Copyright © 2015 Steve (Zhang Jian). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^FindBeacon)(NSString *uuid);
typedef void(^LostBeacon)(NSString *uuid);

@interface BeaconManager : NSObject

@property (strong, nonatomic) CLLocationManager *clManager;
@property (assign, nonatomic) FindBeacon findBeacon;
@property (assign, nonatomic) LostBeacon lostBeacon;

- (void)registerBeaconRegionWithUUID:(NSString *)uuid major:(UInt16)major minor:(UInt16)minor;

@end