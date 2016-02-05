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

@interface AddMovieViewController ()

@end

@implementation AddMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)AddShowBtnClick:(id)sender{
    PMShow *sh= [PMShow showWithTitle:self.textFieldTitle.text andDescription:self.textFieldDescription.text];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate.data addShow:sh];
    
    [self.navigationController popViewControllerAnimated:YES];}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
