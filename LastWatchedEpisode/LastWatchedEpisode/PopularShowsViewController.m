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

#import <Toast/UIView+Toast.h>

@interface PopularShowsViewController ()
@property NSMutableArray *_shows;

@property (strong, nonatomic) NSString *url;

@property (strong, nonatomic) PMHttpData *data;

@end

@implementation PopularShowsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.labelTitle.text = @"Most Popular Shows";
    [self.view makeToastActivity:CSToastPositionCenter];
    NSString *url = @"http://www.omdbapi.com/?s=The+flash";
    self.data = [[PMHttpData alloc] init];
    
    self.mostPopularShowsTableView.delegate = self;
    self.mostPopularShowsTableView.dataSource = self;
    
    [self.data getFrom: url headers:nil withCompletionHandler: ^(NSDictionary * result, NSError * err) {
        NSArray *showsDicts = [result objectForKey:@"Search"];
        
        NSMutableArray *shows = [NSMutableArray array];
        [showsDicts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [shows addObject:[[PMShow alloc] initWithDict: obj]];
        }];
        self._shows = [NSMutableArray array];
        [self._shows addObjectsFromArray:shows];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [self.mostPopularShowsTableView reloadData];
        });
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self._shows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat: @"%@", [self._shows[indexPath.row] title]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath  {
    
    //    DMCourseDetailsViewController *courseDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier: @"CourseDetailsScene"];
    //
    //    courseDetailsVC.courseId = [self.courses[indexPath.row] courseId];
    //    courseDetailsVC.courseTitle = [self.courses[indexPath.row] title];
    //
    //    [self.navigationController pushViewController:courseDetailsVC
    //                                         animated:YES];
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
