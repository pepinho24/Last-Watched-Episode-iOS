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
    
    //    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    static NSString *cellIdentifier = @"FavoritesShowTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat: @"%@", [self.shows[indexPath.row] title]];
    
    return cell;
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
