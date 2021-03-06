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
    [self initTextFields];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgr1.jpg"]];
}

-(void) initTextFields{
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
   
    if ([title length] == 0 || [summary length] == 0) {
        [self.view makeToast:@"Title and summary are required."];
        return;
    }
    
    if ([scheduleAirTime length] == 0) {
        scheduleAirTime = @"N/A";
    }
    
    if ([scheduleAirDays length] == 0) {
        scheduleAirDays = @"N/A";
    }
    // check if string contains only digits
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSetSeason = [NSCharacterSet characterSetWithCharactersInString:lastWatchedEpisodeSeason];
    NSCharacterSet *inStringSetEpisode = [NSCharacterSet characterSetWithCharactersInString:lastWatchedEpisodeNumber];
    
    valid = [lastWatchedEpisodeSeason length] > 0
    && [lastWatchedEpisodeNumber length] > 0
    &&[alphaNums isSupersetOfSet:inStringSetSeason]
    && [alphaNums isSupersetOfSet:inStringSetEpisode];
    
    if (!valid) {
        [self.view makeToast:@"Season and episode must contain only digits."];
        return;
    }
    
    PMShowModel *sh= [PMShowModel showWithTitle:title summary:summary lastWatchedEpisodeNumber:lastWatchedEpisodeNumber lastWatchedEpisodeSeason:lastWatchedEpisodeSeason scheduleAirTime:scheduleAirTime andScheduleAirDays:scheduleAirDays];
    
    [delegate.data addShow:sh];
    
    [self.navigationController.view makeToast:@"Show added Successfully!"];
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
