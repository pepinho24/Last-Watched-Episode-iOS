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
@property NSMutableArray *_shows;

@property (strong, nonatomic) NSString *url;

@property (strong, nonatomic) PMHttpData *data;

@end

@implementation PopularShowsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.labelTitle.text = @"Most Popular Shows";
// TODO : Check why does not get data
    NSString *url = @"http://www.omdbapi.com/?s=The+flash";
    [self.data getFrom: url headers:nil withCompletionHandler: ^(NSDictionary * result, NSError * err) {
        NSArray *showsDicts = [result objectForKey:@"Search"];
        
        NSMutableArray *shows = [NSMutableArray array];
        [showsDicts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [shows addObject:[[PMShow alloc] initWithDict: obj]];
        }];
        
        [self._shows addObjectsFromArray:shows];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mostPopularShowsTableView reloadData];
        });
    }];
    
    
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
