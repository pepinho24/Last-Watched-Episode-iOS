//
//  PopularShowsTableViewCell.h
//  LastWatchedEpisode
//
//  Created by VM on 2/7/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteShowsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *airDaysAndTimeLabel;
@end
