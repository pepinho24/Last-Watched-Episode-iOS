//
//  AddMovieViewController.h
//  LastWatchedEpisode
//
//  Created by VM on 2/5/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMShowModel.h"

@interface AddMovieViewController : UIViewController
- (IBAction)AddShowBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *textFieldTitle;

@property (weak, nonatomic) IBOutlet UITextField *textFieldSummary;

@property (weak, nonatomic) IBOutlet UITextField *textFieldScheduleAirTime;

@property (weak, nonatomic) IBOutlet UITextField *textFieldScheduleAirDays;

@property (weak, nonatomic) IBOutlet UITextField *textFieldLastWatchedEpisodeNumber;

@property (weak, nonatomic) IBOutlet UITextField *textFieldLastWatchedEpisodeSeason;

@property (weak, nonatomic) PMShowModel *showModel;

@end
