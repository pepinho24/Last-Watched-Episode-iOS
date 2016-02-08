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
    if ([self.showModel.title isEqualToString:@"N/A"]) {
        self.showModel.title = self.showTitle;        
    }
    
    showDetailsVC.showModel = self.showModel;
    
    [self.navigationController pushViewController:showDetailsVC
                                         animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgr1.jpg"]];
    self.titleLabel.text = self.showTitle;
    // Do any additional setup after loading the view.
     //[self.view makeToastActivity:CSToastPositionCenter];
    self.data = [[PMHttpData alloc] init];
    self.showModel = [PMShowModel showWithTitle:@"N/A"
                                        summary:@"N/A"
                       lastWatchedEpisodeNumber:@"0"
                       lastWatchedEpisodeSeason:@"0"
                                scheduleAirTime:@"N/A"
                             andScheduleAirDays:@"N/A"];
    [self getShowFromUrl];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.textViewSummary addGestureRecognizer:tapGesture];
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
    [self.view makeToastActivity:CSToastPositionCenter];
    [self.data getFrom: url headers:nil withCompletionHandler: ^(NSDictionary * result, NSError * err) {
        if (err) {
            [self.navigationController.view makeToast:err.description];
            [self.view hideToastActivity];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) {
            self.showModel.title =[result objectForKey:@"name"];
            self.showModel.summary =[result objectForKey:@"summary"];
            
            self.titleLabel.text = self.showModel.title;
            self.textViewSummary.text = self.showModel.summary;
            
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
            }
            else{
                // TODO: Display blank page
                [self.view makeToast:@"No details for the show :(" duration:3 position:CSToastPositionCenter];
            }
             [self.view hideToastActivity];
            
        });
    }];
}

-(void)getEpisodeFromUrl:(NSString*) nextEpisodeUrl :(NSString*) previousEpisodeUrl{
    
    [self.data getFrom: nextEpisodeUrl headers:nil withCompletionHandler: ^(NSDictionary * result, NSError * err) {
        if (err) {
            [self.navigationController.view makeToast:err.description];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *episode = [NSString stringWithFormat:@"Next ep:S%@E%@ - %@",
                                 [result objectForKey:@"season"],
                                 [result objectForKey:@"number"],
                                 [result objectForKey:@"name"]];
            if (!result) {
                episode = @"Next ep: N/A";
            }
            self.labelNextEpisode.text = episode;
        });
    }];
    
    [self.data getFrom: previousEpisodeUrl headers:nil withCompletionHandler: ^(NSDictionary * result, NSError * err) {
        if (err) {
            [self.navigationController.view makeToast:err.description];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *episode = [NSString stringWithFormat:@"Last ep:S%@E%@ - %@",
                                 [result objectForKey:@"season"],
                                 [result objectForKey:@"number"],
                                 [result objectForKey:@"name"]];
            if (!result)  {
                episode = @"Last ep: N/A";
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
