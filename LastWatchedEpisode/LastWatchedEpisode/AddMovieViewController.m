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

#import <CoreData/CoreData.h>

#import <Toast/UIView+Toast.h>

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
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
  
    NSString* title =self.textFieldTitle.text;
    NSString* descr =self.textFieldDescription.text;
    
    if ([title length] == 0) {
       [self.view makeToast:@"Title is required."];
        return;
    }
    
    NSManagedObjectContext* managedContext = delegate.managedObjectContext;
    NSEntityDescription *showEntity = [NSEntityDescription entityForName:@"Show" inManagedObjectContext:managedContext];
        NSManagedObject *show = [[NSManagedObject alloc] initWithEntity:showEntity insertIntoManagedObjectContext:managedContext];
    
    // K-V C key-value coding 
    [show setValue:title forKey:@"title"];
    [show setValue:descr forKey:@"plot"];
    
     NSError *mocSaveError = nil;
    
    if (![managedContext save:&mocSaveError])
    {
        NSLog(@"Save did not complete successfully. Error: %@",
              [mocSaveError localizedDescription]);
    }
    
    PMShow *sh= [PMShow showWithTitle:self.textFieldTitle.text andDescription:self.textFieldDescription.text];
      [delegate.data addShow:sh];
    
    [self.navigationController popViewControllerAnimated:YES];
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
