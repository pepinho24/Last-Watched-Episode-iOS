//
//  PMHttpDataModel.h
//  LastWatchedEpisode
//
//  Created by VM on 2/6/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol PMHttpDataModel <NSObject>

-(NSDictionary *) dict;

-(instancetype) initWithDict: (NSDictionary*) dict;

@end
