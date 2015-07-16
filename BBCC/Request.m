//
//  Request.m
//  BBCC
//
//  Created by Jian Zhang on 7/15/15.
//  Copyright © 2015 Steve (Zhang Jian). All rights reserved.
//

#import "Request.h"
#import <AFNetworking/AFNetworking.h>

@implementation Request

- (void)notifiWithUUID:(NSString *)uuid {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.101:3000/%@", uuid.lowercaseString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.alertTitle = responseObject[@"title"];
            localNotification.alertBody = responseObject[@"content"];
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        }
    }];
    [dataTask resume];
}

@end
