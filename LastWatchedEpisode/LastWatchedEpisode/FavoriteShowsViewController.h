//
//  FavoriteShowsViewController.h
//  LastWatchedEpisode
//
//  Created by VM on 2/3/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteShowsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableViewFavoriteShows;

@property (strong, nonatomic) NSArray *shows;

@end
