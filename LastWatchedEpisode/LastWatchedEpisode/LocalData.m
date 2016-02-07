//
//  LocalData.m
//  LastWatchedEpisode
//
//  Created by VM on 2/5/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import "LocalData.h"
#import "AppDelegate.h"

@interface LocalData()

@property NSMutableArray *_shows;
@property NSManagedObjectContext *managedContext;

@end

@implementation LocalData


- (instancetype)init
{
    self = [super init];
    if (self) {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        self.managedContext = delegate.managedObjectContext;
        self._shows = [self loadShows];
        //self._shows = [NSMutableArray array];
    }
    return self;
}

-(NSMutableArray *) loadShows {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ShowModel"];
    NSMutableArray *showsArray = [NSMutableArray array];
    
    NSError *error;
    
    NSArray *showsEntities = [self.managedContext executeFetchRequest:fetchRequest
                                                                error:&error];
    
    for(int i = 0; i < showsEntities.count; i ++) {
        NSManagedObject *showEntity = showsEntities[i];
        PMShowModel *show =[PMShowModel showWithTitle:[showEntity valueForKey:@"title"]
                                              summary:[showEntity valueForKey:@"summary"]
                             lastWatchedEpisodeNumber:[showEntity valueForKey:@"lastWatchedEpisodeNumber"]
                             lastWatchedEpisodeSeason:[showEntity valueForKey:@"lastWatchedEpisodeSeason"]
                                      scheduleAirTime:[showEntity valueForKey:@"scheduleAirTime"]
                                   andScheduleAirDays:[showEntity valueForKey:@"scheduleAirDays"]];
        
        [showsArray addObject: show];
    }
    
    return showsArray;
}
-(NSMutableArray*) shows {
    return [NSMutableArray arrayWithArray:self._shows];
}

-(void)addShow:(PMShowModel *)show {
    [self._shows addObject: show];
    
    NSString* title = show.title;
    NSString* summary = show.summary;
    NSString* lastWatchedEpisodeNumber = show.lastWatchedEpisodeNumber;
    NSString* lastWatchedEpisodeSeason = show.lastWatchedEpisodeSeason;
    NSString* scheduleAirTime = show.scheduleAirTime;
    NSString* scheduleAirDays = show.scheduleAirDays;
    
    NSEntityDescription *showEntity = [NSEntityDescription entityForName:@"ShowModel" inManagedObjectContext:self.managedContext];
    
    NSManagedObject *sh = [[NSManagedObject alloc] initWithEntity:showEntity insertIntoManagedObjectContext:self.managedContext];
    
    // K-V C key-value coding
    [sh setValue:title forKey:@"title"];
    [sh setValue:summary forKey:@"summary"];
    [sh setValue:lastWatchedEpisodeNumber forKey:@"lastWatchedEpisodeNumber"];
    [sh setValue:lastWatchedEpisodeSeason forKey:@"lastWatchedEpisodeSeason"];
    [sh setValue:scheduleAirTime forKey:@"scheduleAirTime"];
    [sh setValue:scheduleAirDays forKey:@"scheduleAirDays"];
    
    NSError *mocSaveError = nil;
    
    if (![self.managedContext save:&mocSaveError])
    {
        NSLog(@"Save did not complete successfully. Error: %@",
              [mocSaveError localizedDescription]);
    }
}

-(void)deleteShow:(PMShowModel *)show {
    NSInteger index = [self._shows indexOfObject:show];
    [self._shows removeObjectAtIndex:index];
}
@end
