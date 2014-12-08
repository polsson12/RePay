//
//  UIViewController+FirstViewController.m
//  RePay
//
//  Created by Philip Olsson on 2014-11-25.
//  Copyright (c) 2014 Philip Olsson. All rights reserved.
//

#import "FirstViewController.h"

/*@implementation UIViewController (FirstViewController)

@end
*/

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize user = _user;




- (void)viewDidLoad {
    [super viewDidLoad];
    _CreateDebt.layer.cornerRadius = 6;
    _CreateDebt.layer.borderWidth = 1;
    _ShowDebt.layer.cornerRadius = 6;
    _ShowDebt.layer.borderWidth = 1;
    //_CreateDebt.layer.borderColor = [UIColor blueColor].CGColor;
    self.navigationController.navigationBar.backItem.title = @"Logga ut";
    //[[UIBarButtonItem alloc] initWithTitle:@"Logga ut" style:UIBarButtonItemStylePlain target:nil action:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    /*
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [self.delegate setParentSelectedCity:self.selectedCity];
    }
    [super viewWillDisappear:animated];
     */
}
- (IBAction)CreateDebtButton:(id)sender {
    
    NSLog(@"Skapa skuld...");
    /*
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
     */
    
}

- (IBAction)ShowDebtButton:(id)sender {
    NSLog(@"Visa skulder...");
}
/*
- (void)backButtonWasPressed:(id)aResponder {
    NSLog(@"Logga ut trycktes på..");

}
*/
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    if (!parent) {
        [PFUser logOut];
        _user = [PFUser currentUser];
    }
    // parent is nil if this view controller was removed
}

@end