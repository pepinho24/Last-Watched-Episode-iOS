//
//  Episode.m
//  LastWatchedEpisode
//
//  Created by VM on 2/7/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import "Episode.h"

@implementation Episode
-(instancetype)initWithSeasonNumber:(NSString *)season andEpisodeNumber:(NSString *)episode{
    if(self = [super init]) {
        self.seasonNumber = season;
        self.episodeNumber = episode;
    }
    
    return self;
}

+(Episode *)episodeWithSeasonNumber:(NSString *)season andEpisodeNumber:(NSString *)episode{
    return [[Episode alloc] initWithSeasonNumber:season andEpisodeNumber:episode];
}

@end
