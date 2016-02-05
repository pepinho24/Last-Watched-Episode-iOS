//
//  LocalData.m
//  LastWatchedEpisode
//
//  Created by VM on 2/5/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import "LocalData.h"

@interface LocalData()

@property NSMutableArray *_shows;

@end

@implementation LocalData

- (instancetype)init
{
    self = [super init];
    if (self) {
        self._shows = [NSMutableArray array];
    }
    return self;
}

-(NSArray*) shows {
    return [NSArray arrayWithArray:self._shows];
}

-(void)addShow:(PMShow *)show {
    [self._shows addObject: show];
}

-(void)deleteShow:(PMShow *)show {
    NSInteger index = [self._shows indexOfObject:show];
    [self._shows removeObjectAtIndex:index];
}
@end
