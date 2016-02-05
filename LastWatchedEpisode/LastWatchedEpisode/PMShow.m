//
//  PMShow.m
//  LastWatchedEpisode
//
//  Created by VM on 2/5/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import "PMShow.h"

@implementation PMShow
@synthesize description = _description;

typedef enum daysOfWeek {
    Sunday,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday
} DayOfWeek;



-(instancetype)initWithTitle:(NSString *)title andDescription:(NSString *)description{
    if(self = [super init]) {
        self.title = title;
        self.description = description;
    }
//    
//    DayOfWeek dd = Sunday;
    
    return self;
}

+(PMShow*) showWithTitle: (NSString*) title
             andDescription:(NSString*) description{
    return [[PMShow alloc] initWithTitle:title andDescription:description];
}

@end
