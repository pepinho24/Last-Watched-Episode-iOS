//
//  LocalData.h
//  LastWatchedEpisode
//
//  Created by VM on 2/5/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMShow.h"

@interface LocalData : NSObject

-(NSMutableArray*) shows;

-(void) addShow: (PMShow *) show;

-(void) deleteShow: (PMShow *) show;

-(NSMutableArray *) loadShows;
@end
