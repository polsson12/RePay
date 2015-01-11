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
    //_CreateDebt.layer.borderWidth = 1;
    _ShowDebt.layer.cornerRadius = 6;
    //_ShowDebt.layer.borderWidth = 1;
    //_CreateDebt.layer.borderColor = [UIColor blueColor].CGColor;
    //[[UIBarButtonItem alloc] initWithTitle:@"Logga ut" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //Set the label to display the number of unconfirmed depts
    _numOfNewDetps.layer.masksToBounds = YES;
    _numOfNewDetps.layer.cornerRadius = 11;
    _numOfNewDetps.text = @"";
    _numOfNewDetps.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    //self.navigationController.navigationBar.backItem.title = @"Logga ut";
    NSLog(@"ska sätta back item title...");
    //[self.navigationController.navigationBar.backItem setTitle:@"Logga ut"];

    PFQuery *unconfirmedDepts = [PFQuery queryWithClassName:@"Debts"];
    //TODO: IMPORTANT!!!!!!! What if PFUser is NULL?
    [unconfirmedDepts whereKey:@"toFbId" equalTo:[[PFUser currentUser] objectForKey:@"fbId"]];
    [unconfirmedDepts whereKey:@"approved" equalTo:@NO];
    //PFQuery *unconfirmed = [PFQuery queryWithClassName:@"Debts"];
    //[unconfirmed whereKey:@"approved" equalTo:@NO];
    
    //PFQuery *unconfirmedDepts = [PFQuery orQueryWithSubqueries:@[toMe,unconfirmed]];
    
    
    [unconfirmedDepts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {//No error
            if ([objects count] == 0) {
                _numOfNewDetps.text = @"";
                _numOfNewDetps.hidden = YES;
            }
            else if ([objects count] <= 10) {
                NSLog(@"Kommer hit....");
                _numOfNewDetps.text = [NSString stringWithFormat:@"%lu",(unsigned long)[objects count]];
                _numOfNewDetps.hidden = NO;
            }else{
            _numOfNewDetps.text = @"10+";
            _numOfNewDetps.hidden = NO;

            }
        }
        else{ //some error
            UIAlertView *error = [[UIAlertView alloc]
                                  initWithTitle:@"Fel inträffade" message:@"Ett fel inträffade, kontrollera din internet anslutning eller försök igen senare." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [error show];
        }
        
        NSLog(@"Antalet unfirmed depts: %lu",(unsigned long) [objects count]);
        
    }];

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
        NSLog(@"Loggar ut...");
        [PFUser logOut];
        _user = [PFUser currentUser];
    }
    // parent is nil if this view controller was removed
}

@end