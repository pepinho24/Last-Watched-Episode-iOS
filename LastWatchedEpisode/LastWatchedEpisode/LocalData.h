//
//  LocalData.h
//  LastWatchedEpisode
//
//  Created by VM on 2/5/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMShowModel.h"

@interface LocalData : NSObject

-(NSMutableArray*) shows;

-(void) addShow: (PMShowModel *) show;

-(void) deleteShow: (PMShowModel *) show;

-(NSMutableArray *) loadShows;
@end
