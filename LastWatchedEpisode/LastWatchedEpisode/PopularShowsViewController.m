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
#import "RemoteShowDetailsViewController.h"
#import "PMShow.h"
#import "CheckInternet.h"
#import <Toast/UIView+Toast.h>

@interface PopularShowsViewController ()

@property NSMutableArray *popularShows;
@property (strong, nonatomic) NSString *url;

@property (strong, nonatomic) PMHttpData *data;

@end

@implementation PopularShowsViewController

- (void)rightToLeftSwipeDidFire {

    int controllerIndex = 1;
    
    UITabBarController *tabBarController = self.tabBarController;
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = [[tabBarController.viewControllers objectAtIndex:controllerIndex] view];
    
    // Transition using a page curl.
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:(controllerIndex > tabBarController.selectedIndex ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown)
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = controllerIndex;
                        }
                    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgr1.jpg"]];
    
    UISwipeGestureRecognizer *rightToLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightToLeftSwipeDidFire)];
    rightToLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:rightToLeftGesture];
    
    
    
    if ([CheckInternet isInternetConnectionAvailable])
    {
        [self.view makeToast:@"Has internet."];
    }
    else
    {
        // no internet
        [self.view makeToast:@"Check your internet connection and try again."];
    }
    
    // https://api-v2launch.trakt.tv/shows/popular
    // trakt-api-key: 16d47c0248ab45d23f38d864f0a4d999a557b80058a76fe78e5b16e0a1f0e23e
    // apiaryApiName: lastwatchedepisode
    
    //self.labelTitle.text = @"Most Popular Shows";
    [self.view makeToastActivity:CSToastPositionCenter];
   
    NSString *urlPopular = @"https://api-v2launch.trakt.tv/shows/popular";
    self.data = [[PMHttpData alloc] init];
    
    self.mostPopularShowsTableView.delegate = self;
    self.mostPopularShowsTableView.dataSource = self;
    
    [self getTopShows:urlPopular];
}

-(void)getTopShows: (NSString *)urlPopular{
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    [headers setObject:@"16d47c0248ab45d23f38d864f0a4d999a557b80058a76fe78e5b16e0a1f0e23e"
                forKey:@"trakt-api-key"];
    [headers setObject:@"2"
                forKey:@"trakt-api-version"];
    
    [self.data getFrom: urlPopular headers:headers withCompletionHandler: ^(NSDictionary * result, NSError * err) {
        NSMutableArray *shows = [NSMutableArray array];
        
        for(id key in result){
            [shows addObject:key];
        }
        
        self.popularShows = [NSMutableArray array];
        [self.popularShows addObjectsFromArray:shows];
        
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
    return self.popularShows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat: @"%@", [self.popularShows[indexPath.row] objectForKey:@"title"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath  {
    
    [self.view makeToastActivity:CSToastPositionCenter];
    RemoteShowDetailsViewController *showDetailsVC = [self.storyboard
                                                      instantiateViewControllerWithIdentifier: @"RemoteShowDetailsScene"];
    
    showDetailsVC.showTitle = [self.popularShows[indexPath.row] objectForKey:@"title"];
    
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
