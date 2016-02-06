//
//  PMShow.h
//  LastWatchedEpisode
//
//  Created by VM on 2/5/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PMShow : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
//
//@property (strong, nonatomic) NSString *imageUrl;
//
//@property CGFloat price;
-(instancetype)initWithDict:(NSDictionary *)dict;

-(instancetype)initWithTitle: (NSString*) title
                        andDescription:(NSString*) description;
//                     imageUrl: (NSString*) imageUrl
//                     andPrice: (CGFloat) price;

+(PMShow*) showWithTitle: (NSString*) title
             andDescription:(NSString*) description;
//                   imageUrl: (NSString*) imageUrl
//                   andPrice: (CGFloat) price;
@end
