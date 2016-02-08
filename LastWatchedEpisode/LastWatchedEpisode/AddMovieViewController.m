//
//  AddMovieViewController.m
//  LastWatchedEpisode
//
//  Created by VM on 2/5/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import "AddMovieViewController.h"
#import "AppDelegate.h"
#import "PMShow.h"

#import <CoreData/CoreData.h>

#import <Toast/UIView+Toast.h>

@interface AddMovieViewController ()

@end

@implementation AddMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFieldTitle.text = self.showModel.title;
    self.textFieldSummary.text = self.showModel.summary;
    self.textFieldLastWatchedEpisodeNumber.text = self.showModel.lastWatchedEpisodeNumber;
    self.textFieldLastWatchedEpisodeSeason.text = self.showModel.lastWatchedEpisodeSeason;
    self.textFieldScheduleAirTime.text = self.showModel.scheduleAirTime;
    self.textFieldScheduleAirDays.text = self.showModel.scheduleAirDays;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)AddShowBtnClick:(id)sender{
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    NSString* title =self.textFieldTitle.text;
    NSString* summary =self.textFieldSummary.text;
    NSString* lastWatchedEpisodeNumber =self.textFieldLastWatchedEpisodeNumber.text;
    NSString* lastWatchedEpisodeSeason =self.textFieldLastWatchedEpisodeSeason.text;
    NSString* scheduleAirTime =self.textFieldScheduleAirTime.text;
    NSString* scheduleAirDays =self.textFieldScheduleAirDays.text;
    
    if ([title length] == 0) {
        [self.view makeToast:@"Title is required."];
        return;
    }
    
    PMShowModel *sh= [PMShowModel showWithTitle:title summary:summary lastWatchedEpisodeNumber:lastWatchedEpisodeNumber lastWatchedEpisodeSeason:lastWatchedEpisodeSeason scheduleAirTime:scheduleAirTime andScheduleAirDays:scheduleAirDays];
    [delegate.data addShow:sh];
    [self.view makeToast:@"Shpw added Successfully!"];
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
