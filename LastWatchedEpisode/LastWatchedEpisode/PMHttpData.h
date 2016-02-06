//
//  PMHttpData.h
//  LastWatchedEpisode
//
//  Created by VM on 2/6/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMHttpDataModel.h"

@interface PMHttpData : NSObject

+(PMHttpData*) httpData;

-(void) getFrom: (NSString*) urlStr
        headers: (NSDictionary *) headersDict
withCompletionHandler: (void(^)(NSDictionary*, NSError*)) completionHandler;

-(void) postAt: (NSString*) urlStr
      withBody: (id<PMHttpDataModel>) bodyDict
       headers: (NSDictionary *) headersDict
andCompletionHandler: (void(^)(NSDictionary*, NSError*)) completionHandler;

@end
