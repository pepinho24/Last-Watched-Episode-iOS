//
//  PMShowModel.h
//  LastWatchedEpisode
//
//  Created by VM on 2/7/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import "PMShowModel.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PMShowModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSString *lastWatchedEpisodeNumber;
@property (strong, nonatomic) NSString *lastWatchedEpisodeSeason;
@property (strong, nonatomic) NSString *scheduleAirTime;
@property (strong, nonatomic) NSArray *scheduleAirDays;

-(instancetype)initWithTitle: (NSString*) title
                     summary:(NSString*) summary
    lastWatchedEpisodeNumber:(NSString*) lastWatchedEpisodeNumber
    lastWatchedEpisodeSeason:(NSString*) lastWatchedEpisodeSeason
             scheduleAirTime:(NSString*) scheduleAirTime
          andScheduleAirDays:(NSArray*) scheduleAirDays;

+(PMShowModel*) showWithTitle: (NSString*) title
                      summary:(NSString*) summary
     lastWatchedEpisodeNumber:(NSString*) lastWatchedEpisodeNumber
     lastWatchedEpisodeSeason:(NSString*) lastWatchedEpisodeSeason
              scheduleAirTime:(NSString*) scheduleAirTime
           andScheduleAirDays:(NSArray*) scheduleAirDays;

@end
