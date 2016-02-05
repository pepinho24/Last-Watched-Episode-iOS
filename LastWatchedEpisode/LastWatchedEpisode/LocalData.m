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
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Show"];
    NSMutableArray *showsArray = [NSMutableArray array];
    
    NSError *error;
    
    NSArray *showsEntities = [self.managedContext executeFetchRequest:fetchRequest
                                                                  error:&error];
    
    for(int i = 0; i < showsEntities.count; i ++) {
        NSManagedObject *courseEntity = showsEntities[i];
        PMShow *show =[PMShow showWithTitle:[courseEntity valueForKey:@"title"]
                            andDescription:[courseEntity valueForKey:@"plot"]];
        [showsArray addObject: show];
    }
    
    return showsArray;
}
-(NSMutableArray*) shows {
    return [NSMutableArray arrayWithArray:self._shows];
}

-(void)addShow:(PMShow *)show {
    [self._shows addObject: show];
    
    
    NSString* title =show.title;
    NSString* descr =show.description;
    // check if fields text is null or empty
    
    NSEntityDescription *showEntity = [NSEntityDescription entityForName:@"Show" inManagedObjectContext:self.managedContext];
    
    NSManagedObject *sh = [[NSManagedObject alloc] initWithEntity:showEntity insertIntoManagedObjectContext:self.managedContext];
    
    // K-V C key-value coding
    [sh setValue:title forKey:@"title"];
    [sh setValue:descr forKey:@"plot"];
    
    NSError *mocSaveError = nil;
    
    if (![self.managedContext save:&mocSaveError])
    {
        NSLog(@"Save did not complete successfully. Error: %@",
              [mocSaveError localizedDescription]);
    }
}

-(void)deleteShow:(PMShow *)show {
    NSInteger index = [self._shows indexOfObject:show];
    [self._shows removeObjectAtIndex:index];
}
@end
