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

#import "AppDelegate.h"
#import "LocalData.h"
#import "PMShow.h"

#import "FavoriteShowsTableViewCell.h"

#import <Toast/UIView+Toast.h>
@interface FavoriteShowsViewController ()

@end

@implementation FavoriteShowsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgr1.jpg"]];
    
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                        target:self
                                        action:@selector(showAdd)];
    
    self.navigationItem.rightBarButtonItem = addBarButton;
    
    
    UINib* nib = [UINib nibWithNibName:@"FavoriteShowsTableViewCell" bundle:nil];
    
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
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.data loadShows];
    
    self.tableViewFavoriteShows.delegate = self;
    self.tableViewFavoriteShows.dataSource = self;
    
    self.shows = [appDelegate.data shows];
    
    [self.tableViewFavoriteShows reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shows.count;
}

-(void)alertDeleteAtIndexPath: (NSIndexPath*) indexPath{
    NSString *showTitle=[self.shows[indexPath.row] title];
    NSString *alertMessage =[NSString stringWithFormat: @"Are you sure you want to delete '%@'",showTitle];
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Delete show"
                                          message:alertMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *deleteAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Delete Show", @"DELETE action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self deleteShowByTitleAndIndexPath:showTitle :indexPath];
                                       [self.view makeToast:@"Deleted Successfully!"];
                                   }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    
    UIGestureRecognizerState state = longPress.state;
    
    if (state == UIGestureRecognizerStateBegan){
        CGPoint location = [longPress locationInView:self.tableViewFavoriteShows];
        NSIndexPath *indexPath = [self.tableViewFavoriteShows indexPathForRowAtPoint:location];
        [self alertDeleteAtIndexPath:indexPath];
    }
}

-(void) deleteShowByTitleAndIndexPath : (NSString*) showTitle : (NSIndexPath *) indexPath{
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext =appDelegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName: @"ShowModel"];
    
    NSError *err;
    NSArray *results = [managedContext executeFetchRequest:fetchRequest error:&err];
    
    for(int i = 0; i < results.count; i ++) {
        NSManagedObject *showEntity = results[i];
        NSString *titleEntity =[showEntity valueForKey:@"title"];
        
        if ([titleEntity isEqualToString: showTitle]) {
            [managedContext deleteObject:results[i]];
            
            break;
        }
    }
    
    [managedContext save:&err];
    
    [appDelegate.data deleteShow:self.shows[indexPath.row]];
    self.shows = [appDelegate.data shows];
    // TODO: can be sorted or/and grouped by AirDay
    [self.tableViewFavoriteShows reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"FavoriteShowsTableViewCell";
    
    FavoriteShowsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[FavoriteShowsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:cellIdentifier];
        
    }
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    [cell addGestureRecognizer:lpgr];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    topLineView.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:topLineView];
    
    cell.titleLabel.text = [NSString stringWithFormat: @"%@", [self.shows[indexPath.row] title]];
    cell.airDaysAndTimeLabel.text =[NSString stringWithFormat:@"Airs %@ at %@",
                                 [self.shows[indexPath.row] scheduleAirDays],
                                 [self.shows[indexPath.row] scheduleAirTime]];
    
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
