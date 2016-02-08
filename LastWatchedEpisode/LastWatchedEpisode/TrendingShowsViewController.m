//
//  TrendingShowsViewController.m
//  LastWatchedEpisode
//
//  Created by VM on 2/7/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import "TrendingShowsViewController.h"
#import "AppDelegate.h"

#import "PMHttpData.h"
#import "RemoteShowDetailsViewController.h"
#import "PMShow.h"
#import "CheckInternet.h"
#import "TopShowsTableViewCell.h"

#import <Toast/UIView+Toast.h>

@interface TrendingShowsViewController ()

@property int pageCount;

@property NSMutableArray *trendingShows;

@property (strong, nonatomic) NSString *cellIdentifier;

@property (strong, nonatomic) NSString *url;

@property (strong, nonatomic) PMHttpData *data;

@property (strong, nonatomic) NSString *urlTrending;

- (IBAction)onShowMoreBtnClick:(id)sender;

@end

@implementation TrendingShowsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgr1.jpg"]];
    
    self.pageCount=1;
    self.cellIdentifier =@"TopShowsTableViewCell";
    UINib* nib = [UINib nibWithNibName: self.cellIdentifier bundle:nil];
    
    [self.trendingShowsTableView registerNib:nib
                      forCellReuseIdentifier:self.cellIdentifier];
    
    
    
    UISwipeGestureRecognizer *leftToRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftToRightSwipeDidFire)];
    leftToRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:leftToRightGesture];
    
    if ([CheckInternet isInternetConnectionAvailable])
    {
        [self.view makeToast:@"Has internet."];
    }
    else
    {
        // no internet
        [self.view makeToast:@"Check your internet connection and try again."];
    }
    
    
    
    self.urlTrending = [NSString stringWithFormat:@"https://api-v2launch.trakt.tv/shows/trending?page=%i",self.pageCount];
    self.trendingShows = [NSMutableArray array];
    self.data = [[PMHttpData alloc] init];
    
    self.trendingShowsTableView.delegate = self;
    self.trendingShowsTableView.dataSource = self;
    
    [self getTopShows:self.urlTrending];
    
}

- (IBAction)onShowMoreBtnClick:(id)sender {
    self.pageCount++;
    
    self.urlTrending = [NSString stringWithFormat:@"https://api-v2launch.trakt.tv/shows/trending?page=%i",
                        self.pageCount];
    
    [self getTopShows:self.urlTrending];
    [self.view makeToast:@"Loaded more shows" duration:1 position:CSToastPositionCenter];
}

- (void)leftToRightSwipeDidFire {
    int controllerIndex = 0;
    
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


-(void)getTopShows: (NSString *)urlTrending{
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    
    [headers setObject:@"16d47c0248ab45d23f38d864f0a4d999a557b80058a76fe78e5b16e0a1f0e23e"
                forKey:@"trakt-api-key"];
    [headers setObject:@"2"
                forKey:@"trakt-api-version"];
    [self.view makeToastActivity:CSToastPositionCenter];
    
    // TODO: fix repeatition
    [self.data getFrom: urlTrending headers:headers withCompletionHandler: ^(NSDictionary * result, NSError * err) {
        NSMutableArray *shows = [NSMutableArray array];
        
        for(id key in result){
            [shows addObject:[key objectForKey:@"show"]];
        }
        
        
        [self.trendingShows addObjectsFromArray:shows];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [self.trendingShowsTableView reloadData];
        });
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trendingShows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TopShowsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    if(cell == nil) {
        cell = [[TopShowsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:self.cellIdentifier];
    }
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    topLineView.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:topLineView];
    
    NSString *showTitle =[self.trendingShows[indexPath.row] objectForKey:@"title"];
    [self setPosterFromShowTitle:showTitle :cell];
    
    cell.titleLabel.text = showTitle;
    
    return cell;
}

-(void)setPosterFromShowTitle: (NSString*) showTitle :(TopShowsTableViewCell *)cell{
    NSString *url = [NSString stringWithFormat:@"http://api.tvmaze.com/singlesearch/shows?q=%@", showTitle];
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    [self.data getFrom: url headers:nil withCompletionHandler: ^(NSDictionary * result, NSError * err) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.posterImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[result objectForKey:@"image"] objectForKey:@"medium"]]]];
            cell.posterImageView.contentMode = UIViewContentModeScaleAspectFit;
        });
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath  {
    
    [self.view makeToastActivity:CSToastPositionCenter];
    RemoteShowDetailsViewController *showDetailsVC = [self.storyboard
                                                      instantiateViewControllerWithIdentifier: @"RemoteShowDetailsScene"];
    
    showDetailsVC.showTitle = [self.trendingShows[indexPath.row] objectForKey:@"title"];
    
    [self.navigationController pushViewController:showDetailsVC
                                         animated:YES];
    [self.view hideToastActivity];
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
