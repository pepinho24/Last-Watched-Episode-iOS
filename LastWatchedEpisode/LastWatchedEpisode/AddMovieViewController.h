//
//  AddMovieViewController.h
//  LastWatchedEpisode
//
//  Created by VM on 2/5/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMovieViewController : UIViewController
- (IBAction)AddShowBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *textFieldTitle;

@property (weak, nonatomic) IBOutlet UITextField *textFieldDescription;

@end
