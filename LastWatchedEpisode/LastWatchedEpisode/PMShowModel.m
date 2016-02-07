//
//  PMShowModel.m
//  LastWatchedEpisode
//
//  Created by VM on 2/7/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import "PMShowModel.h"

@implementation PMShowModel
-(instancetype)initWithTitle:(NSString *)title summary:(NSString *)summary lastWatchedEpisodeNumber:(NSString *)lastWatchedEpisodeNumber lastWatchedEpisodeSeason:(NSString *)lastWatchedEpisodeSeason scheduleAirTime:(NSString *)scheduleAirTime andScheduleAirDays:(NSArray *)scheduleAirDays{
    if(self = [super init]) {
        self.title = title;
        self.summary = summary;
        self.lastWatchedEpisodeNumber = lastWatchedEpisodeNumber;
        self.lastWatchedEpisodeSeason = lastWatchedEpisodeSeason;
        self.scheduleAirTime = scheduleAirTime;
        self.scheduleAirDays = scheduleAirDays;
    }
   
    return self;
}

+(PMShowModel *)showWithTitle:(NSString *)title summary:(NSString *)summary lastWatchedEpisodeNumber:(NSString *)lastWatchedEpisodeNumber lastWatchedEpisodeSeason:(NSString *)lastWatchedEpisodeSeason scheduleAirTime:(NSString *)scheduleAirTime andScheduleAirDays:(NSArray *)scheduleAirDays{
    return [[PMShowModel alloc] initWithTitle:title summary:summary lastWatchedEpisodeNumber:lastWatchedEpisodeNumber lastWatchedEpisodeSeason:lastWatchedEpisodeSeason scheduleAirTime:scheduleAirTime andScheduleAirDays:scheduleAirDays];
    
}
@end
