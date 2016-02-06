//
//  ViewController.m
//  LastWatchedEpisode
//
//  Created by VM on 2/1/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import "HomePageViewController.h"
#import <Toast/UIView+Toast.h>
@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view makeToast:@"This is a piece of toast."];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
