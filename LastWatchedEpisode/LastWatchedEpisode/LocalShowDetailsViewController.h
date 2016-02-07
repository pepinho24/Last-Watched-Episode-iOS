//
//  LocalShowDetailsViewController.h
//  LastWatchedEpisode
//
//  Created by VM on 2/7/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMShowModel.h"

@interface LocalShowDetailsViewController : UIViewController

@property NSString *showTitle;

@property (strong, nonatomic) PMShowModel *showModel;

@end
