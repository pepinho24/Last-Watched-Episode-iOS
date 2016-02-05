//
//  FavoriteShowsViewController.m
//  LastWatchedEpisode
//
//  Created by VM on 2/3/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import "FavoriteShowsViewController.h"
#import "AddMovieViewController.h"

@interface FavoriteShowsViewController ()

@end

@implementation FavoriteShowsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"Superheroes Database!";
    //[self.tableView registerClass: UITableViewCell.self forCellReuseIdentifier:@"SuperheroCell"];
    
    UIBarButtonItem *btnShowAddAlertVC = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                       target:self
                                                                                       action: @selector(goToAddVC)];
    
    self.navigationItem.rightBarButtonItem = btnShowAddAlertVC;}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)goToAddVC{
    NSString *storyBoardId = @"addMovieScene";
    
    AddMovieViewController *addMovieVC =
    [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
    [self.navigationController pushViewController:addMovieVC animated:YES];}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
