//
//  FavoriteShowsViewController.m
//  LastWatchedEpisode
//
//  Created by VM on 2/3/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import "FavoriteShowsViewController.h"
#import "AddMovieViewController.h"
#import "LocalShowDetailsViewController.h"

//#import "PhoneDetailsViewController.h"

#import "AppDelegate.h"
#import "LocalData.h"
#import "PMShow.h"
#import "FavoriteShowsTableViewCell.h"

#import <Toast/UIView+Toast.h>
//#import "PhoneCell.h"

@interface FavoriteShowsViewController ()

@end

@implementation FavoriteShowsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgr1.jpg"]];
    UIBarButtonItem *addBarButton =    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                     target:self
                                                                                     action:@selector(showAdd)];
    
    self.navigationItem.rightBarButtonItem = addBarButton;
    
    
    UINib* nib = [UINib nibWithNibName:@"FavoriteShowsTableViewCell"
                                bundle:nil];
    
    [self.tableViewFavoriteShows registerNib:nib
         forCellReuseIdentifier:@"FavoriteShowsTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAdd{
    NSString *storyBoardId = @"addMovieScene";
    
    AddMovieViewController *addMovieVC =
    [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
    [self.navigationController pushViewController:addMovieVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    PMShow *sh = [PMShow showWithTitle: @"Gotham"
//                        andDescription: @"Batman's city"];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    //self.shows = [NSArray arrayWithObjects: sh, nil];
    NSManagedObjectContext *managedContext =appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ShowModel"];
    
    NSArray *showEntities = [managedContext executeFetchRequest:request error:nil];
    
    for(int i = 0; i < showEntities.count; i ++) {
        NSManagedObject *showEntity = showEntities[i];
        
        PMShowModel *show = [PMShowModel showWithTitle:[showEntity valueForKey:@"title"]
                                                summary:[showEntity valueForKey:@"summary"]
                               lastWatchedEpisodeNumber:[showEntity valueForKey:@"lastWatchedEpisodeNumber"]
                               lastWatchedEpisodeSeason:[showEntity valueForKey:@"lastWatchedEpisodeSeason"]
                                        scheduleAirTime:[showEntity valueForKey:@"scheduleAirTime"]
                                     andScheduleAirDays:[showEntity valueForKey:@"scheduleAirDays"] ];
                             
        
        [[appDelegate.data shows] addObject: show];
    }
    
    self.tableViewFavoriteShows.delegate = self;
    self.tableViewFavoriteShows.dataSource = self;
    
    self.shows = [appDelegate.data shows];
    
    [self.tableViewFavoriteShows reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shows.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *cellIdentifier = @"FavoriteShowsTableViewCell";
    
    FavoriteShowsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if(cell == nil) {
        cell = [[FavoriteShowsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        
    }
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    topLineView.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:topLineView];
    
    cell.titleLabel.text = [NSString stringWithFormat: @"%@", [self.shows[indexPath.row] title]];
    cell.lastWatchedLabel.text =[NSString stringWithFormat:@"You last watched s%@e%@",
                                 [self.shows[indexPath.row] lastWatchedEpisodeSeason],
                                 [self.shows[indexPath.row] lastWatchedEpisodeNumber]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view makeToastActivity:CSToastPositionCenter];
    LocalShowDetailsViewController *showDetailsVC = [self.storyboard
                                                     instantiateViewControllerWithIdentifier: @"LocalShowDetailsScene"];
    
    showDetailsVC.showTitle = [self.shows[indexPath.row] title];
    
    [self.navigationController pushViewController:showDetailsVC
                                         animated:YES];
    [self.view hideToastActivity];

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
