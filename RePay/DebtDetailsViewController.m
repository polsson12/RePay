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
        
        
        //NSLog( NSStringFromClass( [[_debts objectAtIndex:0]class] ));
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
    
    return [[_debts objectAtIndex:0] count] + [[_debts objectAtIndex:1] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Kommer hit...1");
    //NSLog(@"Inne i cell for row at index path");
    static NSString *cellID = @"UITableViewDetailsCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    // dequeue a table view cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID
                                      forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    

    
    // set its title label (tag #1)
    UILabel *date = (UILabel *)[cell viewWithTag:1];
    date.numberOfLines = 0; //will wrap text in new line
    [date sizeToFit];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd"];
    
    
    // set its author label (tag #2)
    UILabel *message = (UILabel *)[cell viewWithTag:2];
    date.numberOfLines = 0; //will wrap text in new line
    [date sizeToFit];
    
    // set its publication date label (tag #3)
    UILabel *amount = (UILabel *)[cell viewWithTag:3];
    date.numberOfLines = 0; //will wrap text in new line
    [date sizeToFit];
    
    if(tableView == _debtDetailsTableView){
        if (indexPath.row < [[_debts objectAtIndex:0] count]) {
            NSLog(@"indexPath.row : %ld",(long)indexPath.row);
            NSDate *d = [[[_debts objectAtIndex:0] objectAtIndex:indexPath.row] createdAt];
            date.text = [formatter stringFromDate:d];
            message.text = [[[_debts objectAtIndex:0] objectAtIndex:indexPath.row] message];
            amount.text = [[[[_debts objectAtIndex:0] objectAtIndex:indexPath.row] amount] stringValue];
            //cell.textLabel.text = [[[_debts objectAtIndex:0] objectAtIndex:indexPath.row] message];
        }else{
            NSLog(@"indexPath.row : %ld",(long)indexPath.row);
            NSDate *d = [[[_debts objectAtIndex:1] objectAtIndex:(indexPath.row%[[_debts objectAtIndex:1] count])] createdAt];
            date.text = [formatter stringFromDate:d];
            message.text = [[[_debts objectAtIndex:1] objectAtIndex:(indexPath.row%[[_debts objectAtIndex:1] count])] message];
            
            NSString *n = @"-";
            amount.text = [n stringByAppendingString:[[[[_debts objectAtIndex:1] objectAtIndex:(indexPath.row%[[_debts objectAtIndex:1] count])] amount] stringValue] ];
        }
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[_objects removeObjectAtIndex:indexPath.row];
        if (indexPath.row < [[_debts objectAtIndex:0] count]) {
            NSLog(@"Detta object:%@",[[[_debts objectAtIndex:0] objectAtIndex:indexPath.row] toName]);
            
            //TODO: redo this deletion
            NSString *objId = [[[_debts objectAtIndex:0] objectAtIndex:indexPath.row] objectId];

            PFObject *object = [PFObject objectWithoutDataWithClassName:@"Debts"
                                                               objectId:objId];
            [object deleteEventually];
            [[_debts objectAtIndex:0] removeObjectAtIndex:indexPath.row];
            
            
            //[[[_debts objectAtIndex:0] objectAtIndex:indexPath.row] deleteInBackground];
            /*[[[_debts objectAtIndex:0] objectAtIndex:indexPath.row] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                //TODO: More error handling and loading indicator..
                if (succeeded) {
                    
                    [[_debts objectAtIndex:0] removeObjectAtIndex:indexPath.row];

                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Misslyckades!"
                                                                    message:@"Misslyckades att radera skulden"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            
            
            }];*/
        }else{
            NSLog(@"KOmmer hit1");
            NSString *objId = [[[_debts objectAtIndex:1] objectAtIndex:(indexPath.row%[[_debts objectAtIndex:1] count])] objectId];
            NSLog(@"KOmmer hit2");

            PFObject *object = [PFObject objectWithoutDataWithClassName:@"Debts"
                                                               objectId:objId];
            
            [object deleteEventually];
            [[_debts objectAtIndex:1] removeObjectAtIndex:(indexPath.row%[[_debts objectAtIndex:1] count])];

            
            /*
            [[[_debts objectAtIndex:1] objectAtIndex:(indexPath.row%[[_debts objectAtIndex:0] delete])] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
                if (succeeded) {
                
                    [[_debts objectAtIndex:1] removeObjectAtIndex:(indexPath.row%[[_debts objectAtIndex:0] count])];
                    
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Misslyckades!"
                                                                    message:@"Misslyckades att radera skulden"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            }];*/
            
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
       // NSLog(@"Unhandled editing style! %ld", editingStyle);
    }
    [self calculateAmount];
}

/*- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}*/

- (void) calculateAmount{
    NSNumber* amount = @(0);
    
    
    for (int i = 0; i < [[_debts objectAtIndex:0] count]; i++) {
        NSLog(@"Amount %@", [[[_debts objectAtIndex:0] objectAtIndex:i] amount] );
        amount = [NSNumber numberWithFloat:([[[[_debts objectAtIndex:0] objectAtIndex:i] amount] floatValue]  + [amount floatValue])];
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
