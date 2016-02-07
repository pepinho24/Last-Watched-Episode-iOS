//
//  CheckInternet.m
//  LastWatchedEpisode
//
//  Created by VM on 2/6/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import "CheckInternet.h"


@implementation CheckInternet
+ (BOOL) isInternetConnectionAvailable {
    Reachability *internet = [Reachability reachabilityWithHostName: @"www.google.com"];
    NetworkStatus netStatus = [internet currentReachabilityStatus];
    bool netConnection = false;
    switch (netStatus)
    {
        case NotReachable:
        {
            NSLog(@"Access Not Available");
            netConnection = false;
            break;
        }
        case ReachableViaWWAN:
        {
            netConnection = true;
            break;
        }
        case ReachableViaWiFi:
        {
            netConnection = true;
            break;
        }
    }
    
    return netConnection;
}

@end
