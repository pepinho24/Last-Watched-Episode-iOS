//
//  BrowseShowsViewController.m
//  LastWatchedEpisode
//
//  Created by VM on 2/6/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import "BrowseShowsViewController.h"

#import "AppDelegate.h"

#import "PMHttpData.h"

#import "PMShow.h"

@interface BrowseShowsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textFieldSearchShow;

@property (weak, nonatomic) IBOutlet UITableView *tableViewSearchResults;

- (IBAction)onSearchBtnClick:(id)sender;
- (IBAction)onShowMoreResultsBtnClick:(id)sender;

@property NSMutableArray *_shows;
@property int pageCount;
@property NSString *showName;

@property (strong, nonatomic) PMHttpData *data;

@end

@implementation BrowseShowsViewController

-(void)getShowsFromUrl{
    NSString *url = [NSString stringWithFormat:@"http://www.omdbapi.com/?s=%@&page=%i", self.showName,self.pageCount];
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    [self.data getFrom: url headers:nil withCompletionHandler: ^(NSDictionary * result, NSError * err) {
        NSArray *showsDicts = [result objectForKey:@"Search"];
        
        NSMutableArray *shows = [NSMutableArray array];
        [showsDicts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [shows addObject:[[PMShow alloc] initWithDict: obj]];
        }];
        
        [self._shows addObjectsFromArray:shows];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableViewSearchResults reloadData];
        });
    }];

}

-(void)onSearchBtnClick:(id)sender{
    
    // add paging
    self.pageCount = 1;
    self._shows = [NSMutableArray array];
    self.showName =self.textFieldSearchShow.text;
    [self getShowsFromUrl];
}

- (IBAction)onShowMoreResultsBtnClick:(id)sender {
    self.pageCount++;
    // show notification if clicked before assigning value to show name
    [self getShowsFromUrl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageCount = 1;
    self.data = [[PMHttpData alloc] init];
    
    [self.textFieldSearchShow becomeFirstResponder];
    
    self.tableViewSearchResults.delegate = self;
    self.tableViewSearchResults.dataSource = self;
    self._shows = [NSMutableArray array];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
