//
//  RemoteShowDetailsViewController.m
//  LastWatchedEpisode
//
//  Created by VM on 2/6/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import "AppDelegate.h"
#import "RemoteShowDetailsViewController.h"
#import "PMHttpData.h"
#import "AddMovieViewController.h"
#import "PMShowModel.h"
#import <Toast/UIView+Toast.h>

@interface RemoteShowDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textViewSummary;
@property (weak, nonatomic) IBOutlet UILabel *labelSchedule;
@property (weak, nonatomic) IBOutlet UILabel *labelPreviousEpisode;
@property (weak, nonatomic) IBOutlet UILabel *labelNextEpisode;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPoster;

- (IBAction)addToFavoritesBtnClick:(id)sender;

@property (strong, nonatomic) PMHttpData *data;

@end

@implementation RemoteShowDetailsViewController


- (IBAction)addToFavoritesBtnClick:(id)sender {
    AddMovieViewController *showDetailsVC = [self.storyboard
                                                      instantiateViewControllerWithIdentifier: @"addMovieScene"];
    
    showDetailsVC.showModel = self.showModel;
    
    [self.navigationController pushViewController:showDetailsVC
                                         animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgr1.jpg"]];
    self.titleLabel.text = self.showTitle;
    // Do any additional setup after loading the view.
     [self.view makeToastActivity:CSToastPositionCenter];
    self.data = [[PMHttpData alloc] init];
    self.showModel = [PMShowModel showWithTitle:@"N/A"
                                        summary:@"N/A"
                       lastWatchedEpisodeNumber:@"N/A"
                       lastWatchedEpisodeSeason:@"N/A"
                                scheduleAirTime:@"N/A"
                             andScheduleAirDays:@"N/A"];
    [self getShowFromUrl];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.textViewSummary addGestureRecognizer:tapGesture];
    //[tapGesture release];
    
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        UIAlertController * alert= [UIAlertController
                                      alertControllerWithTitle:self.titleLabel.text
                                      message:self.textViewSummary.text
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okayButton = [UIAlertAction
                                    actionWithTitle:@"Okay"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel your yes please button action here
                                        
                                        
                                    }];
        
        [alert addAction:okayButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getShowFromUrl{
    NSString *url = [NSString stringWithFormat:@"http://api.tvmaze.com/singlesearch/shows?q=%@", self.showTitle];
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    [self.data getFrom: url headers:nil withCompletionHandler: ^(NSDictionary * result, NSError * err) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.showModel.title =[result objectForKey:@"name"];
            self.showModel.summary =[result objectForKey:@"summary"];
            
            self.titleLabel.text = self.showModel.title;
            self.textViewSummary.text = self.showModel.summary;
            
            // NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]]
            self.imageViewPoster.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[result objectForKey:@"image"] objectForKey:@"medium"]]]];
             self.imageViewPoster.contentMode = UIViewContentModeCenter;
            
            NSString *time = [[result objectForKey:@"schedule"] objectForKey:@"time"];
            NSString *days = [[[result objectForKey:@"schedule"] objectForKey:@"days"] componentsJoinedByString:@", "];
            
            self.showModel.scheduleAirTime =time;
            self.showModel.scheduleAirDays =days;
            
            NSString *schedule = [NSString stringWithFormat:@"Every %@ at %@",days, time];
            self.labelSchedule.text =schedule;
            
            NSString *previousEpisodeURL =[[[result objectForKey:@"_links"] objectForKey:@"previousepisode"] objectForKey:@"href"];
            NSString *nextEpisodeURL = [[[result objectForKey:@"_links"] objectForKey:@"nextepisode"] objectForKey:@"href"];
            [self getEpisodeFromUrl:nextEpisodeURL :previousEpisodeURL];
             [self.view hideToastActivity];
            
        });
    }];
}

-(void)getEpisodeFromUrl:(NSString*) nextEpisodeUrl :(NSString*) previousEpisodeUrl{
    
    [self.data getFrom: nextEpisodeUrl headers:nil withCompletionHandler: ^(NSDictionary * result, NSError * err) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *episode = [NSString stringWithFormat:@"Next ep:S%@E%@ - %@",
                                 [result objectForKey:@"season"],
                                 [result objectForKey:@"number"],
                                 [result objectForKey:@"name"]];
            if ([episode  isEqual: @"(null)"]) {
                episode = @"N/A";
            }
            self.labelNextEpisode.text = episode;
        });
    }];
    
    [self.data getFrom: previousEpisodeUrl headers:nil withCompletionHandler: ^(NSDictionary * result, NSError * err) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *episode = [NSString stringWithFormat:@"Last ep:S%@E%@ - %@",
                                 [result objectForKey:@"season"],
                                 [result objectForKey:@"number"],
                                 [result objectForKey:@"name"]];
            if ([episode  isEqual: @"(null)"]) {
                episode = @"N/A";
            }
            self.labelPreviousEpisode.text = episode;
        });
    }];
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
