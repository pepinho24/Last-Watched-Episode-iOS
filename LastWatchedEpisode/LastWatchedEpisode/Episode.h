//
//  Episode.h
//  LastWatchedEpisode
//
//  Created by VM on 2/7/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Episode : NSObject

@property (strong, nonatomic) NSString *seasonNumber;
@property (strong, nonatomic) NSString *episodeNumber;

-(instancetype)initWithSeasonNumber: (NSString*) season
                   andEpisodeNumber: (NSString*) episode;

+(Episode*) episodeWithSeasonNumber: (NSString*) season
                andEpisodeNumber: (NSString*) episode;


@end
