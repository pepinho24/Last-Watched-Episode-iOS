//
//  PMHttpData.m
//  LastWatchedEpisode
//
//  Created by VM on 2/6/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import "PMHttpData.h"

@implementation PMHttpData

+(PMHttpData *)httpData {
    return [[PMHttpData alloc] init];
}

-(void)sendAt:(NSString *)urlStr
   withMethod: (NSString*) method
         body:(id<PMHttpDataModel>)body
      headers:(NSDictionary *)headersDict
andCompletionHandler:(void (^)(NSDictionary *, NSError *))completionHandler {
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    [request setHTTPMethod: method];
    
    if(body) {
        NSDictionary *bodyDict = [body dict];
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDict
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        [request setHTTPBody: bodyData];
    }
    
    if(headersDict){
        for(id key in headersDict){
            [request addValue:[headersDict objectForKey:key]
           forHTTPHeaderField:key];
        }
    }
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            completionHandler(nil, error);
            return;
        }
        
        NSError *err;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        if(err) {
            completionHandler(nil, err);
            return;
        }
        completionHandler(dict, nil);
    }]
     resume];
}

-(void)getFrom:(NSString *)urlStr headers:(NSDictionary *)headersDict withCompletionHandler:(void (^)(NSDictionary *, NSError *))completionHandler {
    [self sendAt:urlStr withMethod:@"GET"
            body:nil headers:headersDict andCompletionHandler:completionHandler];
}

-(void)postAt:(NSString *)urlStr withBody:(id<PMHttpDataModel>)body headers:(NSDictionary *)headersDict andCompletionHandler:(void (^)(NSDictionary *, NSError *))completionHandler {
    [self sendAt:urlStr withMethod:@"POST"
            body:body headers:headersDict andCompletionHandler:completionHandler];
}
@end
