//
//  CheckInternet.h
//  LastWatchedEpisode
//
//  Created by VM on 2/6/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface CheckInternet : NSObject
+ (BOOL) isInternetConnectionAvailable;
@end
