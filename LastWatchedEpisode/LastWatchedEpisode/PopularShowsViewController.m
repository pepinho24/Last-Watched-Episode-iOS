//
//  PopularShowsViewController.m
//  LastWatchedEpisode
//
//  Created by VM on 2/6/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import "PopularShowsViewController.h"

#import "AppDelegate.h"

#import "PMHttpData.h"

#import "PMShow.h"

@interface PopularShowsViewController ()



@property (strong, nonatomic) NSString *url;

@property (strong, nonatomic) PMHttpData *data;

@end

@implementation PopularShowsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelTitle.text = @"Most Popular Shows";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
