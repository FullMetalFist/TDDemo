//
//  ViewController.m
//  TDDEMO
//
//  Created by Michael Vilabrera on 1/16/15.
//  Copyright (c) 2015 Giving Tree. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController ()

@property (strong, nonatomic) TableViewController *tableViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableViewController = [[TableViewController alloc] initWithNibName:nil bundle:nil];
    
    TWTRLogInButton *loginButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *sessionBlock, NSError *error) {
        // tweet
        if (sessionBlock) {
            NSLog(@"signed in as %@", [sessionBlock userName]);
            [self.navigationController pushViewController:self.tableViewController animated:YES];
        } else {
            NSLog(@"error %@", [error localizedDescription]);
        }
    }];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
}

@end
