//
//  UIViewController+DebtDetailsViewController.m
//  RePay
//
//  Created by Philip Olsson on 2014-12-08.
//  Copyright (c) 2014 Philip Olsson. All rights reserved.
//

#import "DebtDetailsViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "Debt.h"




@interface DebtDetailsViewController ()

@end


@implementation DebtDetailsViewController

@synthesize debts = _debts;


- (void)viewDidLoad {
    
    NSLog(@"Inne i Debt Details View Controller");
    if (_debts == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops"
                                                        message:@"Something went wrong"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Dismiss", nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        
        NSString* name;
        NSInteger index = 0;

        if([[_debts objectAtIndex:0] count] == 0){
            index = 1;
        }
        //Find out the name to put as text in the cell
        //If the debt objects toFbId string is not equal to the current user fbId we know that the text in the cell should be toName
        NSLog(@"Värde på index: %ld",(long)index);

        if (![[[[_debts objectAtIndex:index] objectAtIndex:0] toFbId] isEqualToString:[[PFUser currentUser] objectForKey:@"fbId"]]) {
            name = [[[_debts objectAtIndex:index] objectAtIndex:0] toName];
        }else{ //Else we know that the text in the cell should be fromName
            name = [[[_debts objectAtIndex:index] objectAtIndex:0] fromName];
        }
        _nameLabel.text = name;
        
        //Calculate the differance in debts
        [self calculateAmount];
        
        [_debtDetailsTableView reloadData];
        
    }
    
}

#pragma mark table view methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"Kommer hit...2");
    
    return [_debts count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Kommer hit...1");
    //NSLog(@"Inne i cell for row at index path");
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if(tableView == _debtDetailsTableView){
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[_objects removeObjectAtIndex:indexPath.row];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        NSLog(@"Unhandled editing style! %ld", editingStyle);
    }
}

- (void) calculateAmount{
    NSNumber* amount = 0;
    
    
    for (int i = 0; i < [[_debts objectAtIndex:0] count]; i++) {
        NSLog(@"Amount %@", [[[_debts objectAtIndex:0] objectAtIndex:i] amount] );
        amount = [NSNumber numberWithFloat:([[[[_debts objectAtIndex:0] objectAtIndex:i] amount] floatValue]  + [amount floatValue]) ];
    }

    for (int i = 0; i < [[_debts objectAtIndex:1] count]; i++) {
        NSLog(@"Amount %@", [[[_debts objectAtIndex:1] objectAtIndex:i] amount] );
        amount = [NSNumber numberWithFloat:([amount floatValue]-[[[[_debts objectAtIndex:1] objectAtIndex:i] amount] floatValue]) ];
    }

    _differanceLabel.text = [amount stringValue];
}


/*NSLog(@"innan for loop");
 for (int i = 0; i < [_debts count]; i++) {
 NSLog(@"inne i i");
 for (int j = 0 ; j < [[_debts objectAtIndex:i] count]; j++) {
 NSLog(@"i: %d    j:%d",i,j);
 }
 }
 NSLog(@"Storlek: %lu", [[_debts objectAtIndex:0] count]);
 NSLog(@"storlek på _debts %@", [[[_debts objectAtIndex:0] objectAtIndex:0] toName] );
 
 */




@end
